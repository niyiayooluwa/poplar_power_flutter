import 'package:dart_either/dart_either.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/data_sources/remote/biller_remote_data_source.dart';
import 'package:poplar_power/data/models/billers/payment_request_dto.dart';
import 'package:poplar_power/domain/failures/biller_failure.dart';
import 'package:poplar_power/domain/models/biller.dart';
import 'package:poplar_power/domain/models/biller_product.dart';
import 'package:poplar_power/domain/models/purchase_response.dart';
import 'package:poplar_power/domain/repositories/biller_repository.dart';

class _CacheEntry<T> {
  final T data;
  final DateTime timestamp;

  _CacheEntry(this.data) : timestamp = DateTime.now();

  bool isStale(Duration maxAge) => DateTime.now().difference(timestamp) > maxAge;
}

class BillerRepositoryImpl implements BillerRepository {
  final BillerRemoteDataSource _remoteDataSource;
  final Map<String, _CacheEntry> _cache = {};
  static const Duration _cacheDuration = Duration(minutes: 5);

  BillerRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<BillerFailure, PurchaseResponse>> purchase(
    PaymentRequestDto request,
  ) async {
    try {
      final dto = await _remoteDataSource.purchase(request);
      return Right(dto.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(BillerFailure.unknown());
    }
  }

  @override
  Future<Either<BillerFailure, List<Biller>>> getBillersForCategory(
    String categoryId,
  ) async {
    final cacheKey = 'billers_category_$categoryId';

    // Check cache first
    final cachedEntry = _cache[cacheKey];
    if (cachedEntry != null && !cachedEntry.isStale(_cacheDuration)) {
      return Right(cachedEntry.data as List<Biller>);
    }

    try {
      final billerDtos = await _remoteDataSource.getBillersForCategory(categoryId);
      final billers = billerDtos.map((dto) => dto.toEntity()).toList();
      _cache[cacheKey] = _CacheEntry(billers);
      return Right(billers);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(BillerFailure.unknown());
    }
  }

  @override
  Future<Either<BillerFailure, List<BillerProduct>>> getProductsForBiller(
    String billerId,
  ) async {
    final cacheKey = 'products_biller_$billerId';

    // Check cache first
    final cachedEntry = _cache[cacheKey];
    if (cachedEntry != null && !cachedEntry.isStale(_cacheDuration)) {
      return Right(cachedEntry.data as List<BillerProduct>);
    }

    try {
      final dtos = await _remoteDataSource.getProductsForBiller(billerId);
      final entities = dtos.map((dto) => dto.toEntity()).toList();
      _cache[cacheKey] = _CacheEntry(entities);
      return Right(entities);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(BillerFailure.unknown());
    }
  }

  BillerFailure _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return BillerFailure.network();
      case DioExceptionType.badResponse:
        return BillerFailure.unknown(); // Simplified for now
      default:
        return BillerFailure.unknown();
    }
  }
}

// Repository Provider
final billerRepositoryProvider = Provider<BillerRepository>((ref) {
  final remoteDataSource = ref.watch(billerRemoteDataSourceProvider);
  return BillerRepositoryImpl(remoteDataSource);
});
