import 'package:dio/dio.dart';

import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// A singleton class that provides a configured instance of Dio for making HTTP requests.
///
/// This class ensures that only one instance of Dio is created and used throughout
/// the application, configured with base options and interceptors.
class DioClient {
  // The Dio instance used for network requests.
  final Dio _dio;

  // Private constructor to prevent direct instantiation.
  // Initializes Dio with base options and adds interceptors.
  DioClient._internal() : _dio = Dio(_baseOptions) {
    // Adds an interceptor for handling authentication.
    _dio.interceptors.add(AuthInterceptor());
    // Adds an interceptor for logging network requests and responses.
    _dio.interceptors.add(LoggingInterceptor());
  }

  // The single instance of DioClient.
  static final DioClient _instance = DioClient._internal();

  // Factory constructor to return the singleton instance.
  factory DioClient() {
    return _instance;
  }

  // Base options for the Dio instance.
  // These options are applied to all requests made by this Dio instance.
  static final BaseOptions _baseOptions = BaseOptions(
    baseUrl: 'https://api.example.com',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  /// Getter for the Dio instance.
  Dio get dio => _dio;
}