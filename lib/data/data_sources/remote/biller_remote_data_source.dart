import 'package:dio/dio.dart';
import 'package:poplar_power/core/constants/api_constants.dart';
import 'package:poplar_power/data/models/billers/biller_dto.dart';
import 'package:poplar_power/data/models/billers/biller_product_dto.dart';
import 'package:poplar_power/data/models/billers/payment_request_dto.dart';
import 'package:poplar_power/data/models/billers/purchase_response_dto.dart';
import 'package:poplar_power/data/network/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

abstract class BillerRemoteDataSource {
  Future<List<BillerDto>> getBillersForCategory(String categoryId);
  Future<List<BillerProductDto>> getProductsForBiller(String billerId);
  Future<PurchaseResponseDto> purchase(PaymentRequestDto request);
}

class BillerRemoteDataSourceImpl implements BillerRemoteDataSource {
  final Dio _dio = DioClient().dio;

  Map<String, dynamic> _getAuthHeaders() {
    return {
      'x-sso-appId': ApiConstants.APP_ID,
      'x-sso-public': ApiConstants.PUBLIC_KEY,
    };
  }

  @override
  Future<List<BillerDto>> getBillersForCategory(String categoryId) async {
    try {
      final response = await _dio.get(
        '/autoPayBillers/categories/$categoryId/drill',
      );
      final List<dynamic> data = response.data;
      return data.map((json) => BillerDto.fromJson(json)).toList();
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<BillerProductDto>> getProductsForBiller(String billerId) async {
    try {
      final response = await _dio.get('/autoPayBillers/$billerId/products');
      final List<dynamic> data = response.data;
      return data.map((json) => BillerProductDto.fromJson(json)).toList();
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<PurchaseResponseDto> purchase(PaymentRequestDto request) async {
    try {
      final response = await _dio.post(
        '/buyProducts/purchase',
        data: request.toJson(),
        options: Options(headers: _getAuthHeaders()),
      );
      return PurchaseResponseDto.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }
}

//Data Source Provider
final billerRemoteDataSourceProvider = Provider<BillerRemoteDataSource>((ref) {
  return BillerRemoteDataSourceImpl();
});
