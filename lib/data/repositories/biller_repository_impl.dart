import 'package:dart_either/dart_either.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/data_sources/remote/biller_remote_data_source.dart';
import 'package:poplar_power/data/models/billers/buy_token_request_dto.dart';
import 'package:poplar_power/domain/failures/biller_failure.dart';
import 'package:poplar_power/domain/models/biller.dart';
import 'package:poplar_power/domain/models/biller_product.dart';
import 'package:poplar_power/domain/repositories/biller_repository.dart';

class BillerRepositoryImpl implements BillerRepository {
  final BillerRemoteDataSource _remoteDataSource;

  BillerRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<BillerFailure, void>> buyToken(
    BuyTokenRequestDto request,
  ) async {
    try {
      await _remoteDataSource.buyToken(request);
      return const Right(null);
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
    try {
      final dtos = await _remoteDataSource.getBillersForCategory(categoryId);
      // Assuming ElectricityDiscoDto has a toEntity() method
      final entities = dtos.map((dto) => dto.toEntity()).toList();
      return Right(entities);
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
    try {
      final dtos = await _remoteDataSource.getProductsForBiller(billerId);
      // Assuming BillerProductDto has a toEntity() method
      final entities = dtos.map((dto) => dto.toEntity()).toList();
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
