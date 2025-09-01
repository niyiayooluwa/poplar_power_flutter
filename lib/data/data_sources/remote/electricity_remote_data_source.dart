import 'package:dio/dio.dart';
import 'package:poplar_power/core/constants/api_constants.dart';
import 'package:poplar_power/data/models/electricity/biller_product_dto.dart';
import 'package:poplar_power/data/models/electricity/buy_token_request_dto.dart';
import 'package:poplar_power/data/models/electricity/electricity_disco_dto.dart';
import 'package:poplar_power/data/network/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

abstract class ElectricityRemoteDataSource {
  Future<List<ElectricityDiscoDto>> getDiscosForCategory();

  Future<List<BillerProductDto>> getProductsForDisco(String discoId);

  Future<void> buyToken(BuyTokenRequestDto request);
}

class ElectricityRemoteDataSourceImpl implements ElectricityRemoteDataSource {
  final Dio _dio = DioClient().dio;

  Map<String, dynamic> _getAuthHeaders() {
    return {
      'x-sso-appId': ApiConstants.APP_ID,
      'x-sso-public': ApiConstants.PUBLIC_KEY,
    };
  }

  @override
  Future<List<ElectricityDiscoDto>> getDiscosForCategory() async {
    try {
      final response = await _dio.get(
        '/autoPayBillers/categories/ELECTRIC_DISCO/drill',
      );
      final List<dynamic> data = response.data;
      return data.map((json) => ElectricityDiscoDto.fromJson(json)).toList();
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<BillerProductDto>> getProductsForDisco(String discoId) async {
    try {
      final response = await _dio.get('/autoPayBillers/$discoId/products');
      final List<dynamic> data = response.data;
      return data.map((json) => BillerProductDto.fromJson(json)).toList();
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> buyToken(BuyTokenRequestDto request) async {
    try {
      await _dio.post(
        '/token/buy',
        data: request.toJson(),
        options: Options(headers: _getAuthHeaders()),
      );
    } on DioException {
      rethrow;
    }
  }
}

//Data Source Provider
final electricityRemoteDataSourceProvider =
    Provider<ElectricityRemoteDataSource>((ref) {
      return ElectricityRemoteDataSourceImpl();
    });
