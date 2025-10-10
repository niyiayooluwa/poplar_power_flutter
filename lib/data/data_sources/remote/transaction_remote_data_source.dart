import 'package:dio/dio.dart';
import 'package:poplar_power/data/models/wallet/get_balance_request_dto.dart';
import 'package:poplar_power/data/models/wallet/get_balance_response_dto.dart';
import 'package:poplar_power/data/models/transaction/transaction_status_dto.dart';
import 'package:poplar_power/data/network/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:poplar_power/domain/models/verification_response.dart';

abstract class TransactionRemoteDataSource {
  Future<TransactionStatusDto> getTransactionStatus(String nettpayRef);
  Future<List<TransactionStatusDto>> getTransactionHistory(String email);
  Future<GetBalanceResponseDto> getBalance(GetBalanceRequestDto request);
  Future<VerificationResponse> verifyTransaction(String reference);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio _dio = DioClient().dio;

  @override
  Future<TransactionStatusDto> getTransactionStatus(String nettpayRef) async {
    try {
      final response = await _dio.get('/buyProducts/status/$nettpayRef');
      return TransactionStatusDto.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<TransactionStatusDto>> getTransactionHistory(String email) async {
    try {
      final response = await _dio.get(
        '/buyProducts/history',
        queryParameters: {'email': email},
      );
      final List<dynamic> data = response.data;
      return data.map((json) => TransactionStatusDto.fromJson(json)).toList();
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<GetBalanceResponseDto> getBalance(GetBalanceRequestDto request) async {
    try {
      final response = await _dio.post(
        '/transaction/getBalance',
        data: request.toJson(),
      );
      return GetBalanceResponseDto.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<VerificationResponse> verifyTransaction(String reference) async {
    try {
      final response = await _dio.post('/buyProducts/verify/$reference');
      return VerificationResponse.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }
}

final transactionRemoteDataSourceProvider = Provider<TransactionRemoteDataSource>((ref) {
  return TransactionRemoteDataSourceImpl();
});
