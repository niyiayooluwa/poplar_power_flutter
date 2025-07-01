import 'package:dio/dio.dart';

/// Handles network calls related to authentication like login and signup
class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.poplarpower.com', //TODO: Replace with actual base URL
      headers: {
        'Content-Type': 'application/json',
      },
    )
  );

  ///Sends login request to backend with user credentials
  ///
  /// Throws a [DioException] if the request fails
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/auth/login', //TODO: Replace with actual login endpoint
      data: {
        'email': email,
        'password': password,
      },
    );
  }
}