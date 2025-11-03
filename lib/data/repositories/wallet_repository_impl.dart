import 'package:dart_either/dart_either.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/data_sources/remote/wallet_remote_data_source.dart';

import 'package:poplar_power/domain/failures/transaction_failure.dart';
import 'package:poplar_power/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource _remoteDataSource;

  WalletRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, void>> forgotPin(String accountNo) async {
    try {
      final response = await _remoteDataSource.forgotPin(accountNo);
      return Right(null);
    } on DioException catch (e) {
      return Left(TransactionFailure(e.message ?? 'An unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPin(String accountNo,
      String otp,
      String walletPin,) async {
    try {
      final response = await _remoteDataSource.resetPin(
          accountNo, otp, walletPin);
      return Right(null);
    } on DioException catch (e) {
      return Left(TransactionFailure(e.message ?? 'An unknown error occurred'));
    }
  }
}

  final walletRepositoryProvider = Provider<WalletRepository>((ref) {
    final remoteDataSource = ref.watch(walletRemoteDataSourceProvider);
    return WalletRepositoryImpl(remoteDataSource);
  });
