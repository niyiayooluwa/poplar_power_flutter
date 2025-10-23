// lib/data/data_sources/remote/auth_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/core/constants/api_constants.dart'; // For custom headers
import 'package:poplar_power/data/models/auth/auth_response_dto.dart';
import 'package:poplar_power/data/models/auth/login_request_dto.dart';
import 'package:poplar_power/data/models/auth/resend_otp_request_dto.dart';
import 'package:poplar_power/data/models/auth/signup_request_dto.dart';
import 'package:poplar_power/data/models/auth/verify_otp_request_dto.dart';
import 'package:poplar_power/data/models/auth/password_reset_request_dto.dart'; // New import
import 'package:poplar_power/data/models/user/user_dto.dart';
import 'package:poplar_power/data/network/dio_client.dart';

/// Abstract class defining the contract for authentication-related remote data operations.
/// This class outlines the methods that any implementation of an authentication remote data source must provide.
abstract class AuthRemoteDataSource {
  /// Attempts to log in a user with the provided credentials.
  ///
  /// Takes a [LoginRequestDto] containing the user's login information.
  /// Returns a [Future] that resolves to an [AuthResponseDto] containing authentication tokens and user details upon successful login.
  Future<AuthResponseDto> login(LoginRequestDto requestDto);

  /// Attempts to register a new user with the provided details.
  ///
  /// Takes a [SignupRequestDto] containing the new user's information.
  /// Returns a [Future] that resolves to an [UserDto] containing user details upon successful registration.
  Future<UserDto> register(SignupRequestDto requestDto);

  /// Fetches the details of the currently authenticated user.
  ///
  /// Returns a [Future] that resolves to a [UserDto] containing the authenticated user's information.
  Future<UserDto> getAuthenticatedUser();

  /// Verifies the OTP for a user.
  ///
  /// Takes a [VerifyOtpRequestDto] containing the user's email and OTP.
  /// Returns a [Future] that resolves to a Map upon successful verification.
  Future<Map<String, dynamic>> verifyOtp(VerifyOtpRequestDto requestDto);

  /// Resends the OTP to a user.
  ///
  /// Takes a [ResendOtpRequestDto] containing the user's email.
  /// Returns a [Future] that resolves to void upon successful resend.
  Future<void> resendOtp(ResendOtpRequestDto requestDto);
  Future<void> verifyOtpAndResetPassword(String email, String otp, String newPassword);
}

/// Implementation of [AuthRemoteDataSource] that interacts with a remote API using Dio.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio = DioClient().dio;

  // Helper to add custom headers from Postman collection
  Map<String, dynamic> _getAuthHeaders() {
    return {
      'x-sso-appId': ApiConstants.APP_ID,
      'x-sso-public': ApiConstants.PUBLIC_KEY,
    };
  }

  /// Logs in a user by sending a POST request to the '/auth/login' endpoint.
  ///
  /// The [requestDto] contains the login credentials.
  /// Custom authentication headers are added to the request.
  ///
  /// Returns an [AuthResponseDto] upon successful login.
  /// Rethrows a [DioException] if an error occurs during the API call, allowing higher layers to handle it.
  @override
  Future<AuthResponseDto> login(LoginRequestDto requestDto) async {
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

  /// Registers a new user by sending a POST request to the '/auth/register' endpoint.
  ///
  /// The [requestDto] contains the user's registration details.
  /// Custom authentication headers are added to the request.
  ///
  /// Returns an [UserDto] upon successful registration.
  /// Rethrows a [DioException] if an error occurs during the API call.
  @override
  Future<UserDto> register(SignupRequestDto requestDto) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: requestDto.toJson(),
        options: Options(headers: _getAuthHeaders()),
      );
      return UserDto.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }

  /// Fetches the authenticated user's details by sending a GET request to the '/auth/me' endpoint.
  ///
  /// Custom authentication headers are added to the request.
  ///
  /// Returns a [UserDto] containing the authenticated user's information.
  /// Rethrows a [DioException] if an error occurs during the API call.
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

  /// Verifies the OTP for a user by sending a POST request to the '/auth/verify' endpoint.
  ///
  /// The [requestDto] contains the user's email and OTP.
  /// Custom authentication headers are added to the request.
  ///
  /// Returns a [Map] upon successful verification.
  /// Rethrows a [DioException] if an error occurs during the API call.
  @override
  Future<Map<String, dynamic>> verifyOtp(VerifyOtpRequestDto requestDto) async {
    try {
      final response = await _dio.post(
        '/auth/verify',
        data: requestDto.toJson(),
        options: Options(headers: _getAuthHeaders()),
      );
      return response.data as Map<String, dynamic>;
    } on DioException {
      rethrow;
    }
  }

  /// Resends the OTP to a user by sending a POST request to the '/auth/resend-verification' endpoint.
  ///
  /// The [requestDto] contains the user's email.
  /// Custom authentication headers are added to the request.
  ///
  /// Returns void upon successful resend.
  /// Rethrows a [DioException] if an error occurs during the API call.

  @override
  Future<void> resendOtp(ResendOtpRequestDto requestDto) async {
    try {
      await _dio.post(
        '/auth/resend-verification',
        data: requestDto.toJson(),
        options: Options(headers: _getAuthHeaders()),
      );
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> verifyOtpAndResetPassword(String email, String otp, String newPassword) async {
    try {
      final requestDto = PasswordResetRequestDto(
        username: email,
        password: newPassword,
        otp: otp,
      );
      await _dio.post(
        '/auth/verify',
        data: requestDto.toJson(),
        options: Options(headers: _getAuthHeaders()),
      );
    } on DioException {
      rethrow;
    }
  }
}

//Data Source Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl();
});