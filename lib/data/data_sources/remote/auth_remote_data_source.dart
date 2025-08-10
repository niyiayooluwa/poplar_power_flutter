// lib/data/data_sources/remote/auth_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:poplar_power/data/models/auth/auth_response_dto.dart';
import 'package:poplar_power/data/model/dto/auth/login.dart';
import 'package:poplar_power/data/model/dto/auth/signup.dart';
import 'package:poplar_power/data/models/user/user_dto.dart';
import 'package:poplar_power/data/network/dio_client.dart';
import 'package:poplar_power/core/constants/api_constants.dart'; // For custom headers

abstract class AuthRemoteDataSource {
  Future<AuthResponseDto> login(LoginRequest requestDto);
  Future<AuthResponseDto> register(SignupRequest requestDto);
  Future<UserDto> getAuthenticatedUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio = DioClient().dio;

  // Helper to add custom headers from Postman collection
  Map<String, dynamic> _getAuthHeaders() {
    return {
      'x-sso-appId': ApiConstants.APP_ID,
      'x-sso-public': ApiConstants.PUBLIC_KEY,
    };
  }

  @override
  Future<AuthResponseDto> login(LoginRequest requestDto) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: requestDto.toJson(),
        options: Options(headers: _getAuthHeaders()),
      );
      return AuthResponseDto.fromJson(response.data);
    } on DioException {
      rethrow; // Let interceptors or higher layers handle specific DioErrors
    }
  }

  @override
  Future<AuthResponseDto> register(SignupRequest requestDto) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: requestDto.toJson(),
        options: Options(headers: _getAuthHeaders()),
      );
      return AuthResponseDto.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<UserDto> getAuthenticatedUser() async {
    try {
      final response = await _dio.get(
        '/auth/me',
        options: Options(headers: _getAuthHeaders()),
      );
      return UserDto.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }
}
