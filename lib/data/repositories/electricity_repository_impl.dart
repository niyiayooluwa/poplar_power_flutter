import 'package:dart_either/dart_either.dart';
import 'package:dio/dio.dart';
import 'package:poplar_power/data/data_sources/remote/electricity_remote_data_source.dart';
import 'package:poplar_power/data/models/electricity/buy_token_request_dto.dart';
import 'package:poplar_power/domain/failures/biller_failure.dart';
import 'package:poplar_power/domain/models/biller_product.dart';
import 'package:poplar_power/domain/models/electricity_disco.dart';
import 'package:poplar_power/domain/repositories/electricity_repository.dart';

class ElectricityRepositoryImpl implements ElectricityRepository {
  final ElectricityRemoteDataSource _remoteDataSource;

  ElectricityRepositoryImpl(this._remoteDataSource);

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
  Future<Either<BillerFailure, List<ElectricityDisco>>> getDiscosForCategory() async {
    try {
      final dtos = await _remoteDataSource.getDiscosForCategory();
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
  Future<Either<BillerFailure, List<BillerProduct>>> getProductsForDisco(
    String discoId,
  ) async {
    try {
      final dtos = await _remoteDataSource.getProductsForDisco(discoId);
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