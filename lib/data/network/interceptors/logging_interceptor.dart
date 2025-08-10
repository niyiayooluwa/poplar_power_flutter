// lib/data/network/interceptors/logging_interceptor.dart
import 'dart:developer'; // For log() function
import 'package:dio/dio.dart';

/// A Dio interceptor that logs network requests, responses, and errors.
/// This is useful for debugging network interactions.
class LoggingInterceptor extends Interceptor {
  /// Called when a request is about to be sent.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Log the HTTP method and path of the request.
    log('REQUEST[${options.method}] => PATH: ${options.path}');
    // Log the headers of the request.
    log('Headers: ${options.headers}');
    // If the request has a body, log it.
    if (options.data != null) {
      log('Request Body: ${options.data}');
    }
    // Continue with the request.
    super.onRequest(options, handler);
  }

  /// Called when a response is received.
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log the status code and path of the response.
    log(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    // If the response has data, log it.
    if (response.data != null) {
      log('Response Data: ${response.data}');
    }
    // Continue with the response.
    super.onResponse(response, handler);
  }

  /// Called when an error occurs during a request or response.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log the status code (if available) and path of the request that caused the error.
    log(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    // Log the error message.
    log('Error Message: ${err.message}');
    // If the error response has data, log it.
    if (err.response != null) {
      log('Error Response Data: ${err.response?.data}');
    }
    // Continue with the error handling.
    super.onError(err, handler);
  }
}
