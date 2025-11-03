import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/network/dio_client.dart';

abstract class WalletRemoteDataSource {
  Future<void> forgotPin(String accountNo);

  Future<void> resetPin(String accountNo, String otp, String walletPin);
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final Dio _dio = DioClient().dio;

  @override
  Future<void> forgotPin(String accountNo) async {
    try {
      final _ = await _dio.post(
        '/wallet/forgotPin',
        data: {'accountNo': accountNo},
      );
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> resetPin(String accountNo, String otp, String walletPin) async {
    try {
      final requestData = {
        'accountNo': accountNo,
        'otp': otp,
        'walletPin': walletPin,
      };
      final response = await _dio.post(
          '/wallet/resetPin',
          data: requestData
      );
    } on DioException {
      rethrow;
    }
  }
}

final walletRemoteDataSourceProvider = Provider<WalletRemoteDataSource>((ref) {
  return WalletRemoteDataSourceImpl();
});
