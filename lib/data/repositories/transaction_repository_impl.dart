import 'package:dart_either/dart_either.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/data_sources/remote/transaction_remote_data_source.dart';
import 'package:poplar_power/data/models/billers/get_balance_request_dto.dart';
import 'package:poplar_power/domain/failures/transaction_failure.dart';
import 'package:poplar_power/domain/models/transaction_status.dart';
import 'package:poplar_power/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource _remoteDataSource;

  TransactionRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, double>> getBalance(String accountNo, String pin) async {
    try {
      final request = GetBalanceRequestDto(accountNo: accountNo, pin: pin);
      final response = await _remoteDataSource.getBalance(request);
      return Right(response.balance);
    } on DioException catch (e) {
      return Left(TransactionFailure(e.message ?? 'An unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<TransactionStatus>>> getTransactionHistory(String email) async {
    try {
      final response = await _remoteDataSource.getTransactionHistory(email);
      return Right(response.map((e) => e.toDomain()).toList());
    } on DioException catch (e) {
      return Left(TransactionFailure(e.message ?? 'An unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, TransactionStatus>> getTransactionStatus(String nettpayRef) async {
    try {
      final response = await _remoteDataSource.getTransactionStatus(nettpayRef);
      return Right(response.toDomain());
    } on DioException catch (e) {
      return Left(TransactionFailure(e.message ?? 'An unknown error occurred'));
    }
  }
}

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final remoteDataSource = ref.watch(transactionRemoteDataSourceProvider);
  return TransactionRepositoryImpl(remoteDataSource);
});
