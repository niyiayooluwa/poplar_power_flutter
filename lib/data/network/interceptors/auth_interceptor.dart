import 'package:dio/dio.dart';
import 'package:poplar_power/data/storage/token_storage.dart';

/// An interceptor for Dio HTTP client to handle authentication.
///
/// This interceptor automatically adds an Authorization header with a Bearer token
/// to outgoing requests, except for predefined public paths. It also handles
/// 401 Unauthorized errors, providing a placeholder for token refresh logic
/// or forcing a logout.
class AuthInterceptor extends Interceptor {
  /// Called when a request is about to be sent.
  ///
  /// If the request path is not a public path, it retrieves the token
  /// from [TokenStorage] and adds it to the 'Authorization' header.
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Define paths that do not require authentication.
    final publicPaths = ['/auth/login', '/auth/register', '/buyProducts/verify', '/auth/resend-verification'];

    bool isPublicPath = publicPaths.any((path) => options.path.contains(path));

    if (!isPublicPath) {
      final token = await TokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        // Add the Authorization header with the Bearer token.
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    // Continue with the request.
    super.onRequest(options, handler);
  }

  /// Called when an error occurs during a request.
  ///
  /// Specifically handles 401 Unauthorized errors.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    //Handle 401 Unauthorized Errors
    if (err.response?.statusCode == 401) {
      // If the error is a 401 Unauthorized error, it means the token is invalid or expired.
      // If token refresh fails, or if you don't have refresh token logic,
      // you would navigate the user to the login screen.
      //TODO(): Implement token refresh logic or force logout. Link up with GB
      //Navigator.of(context).pushReplacementNamed('/login');
    }
    // Continue with the error handling.
    super.onError(err, handler);
  }
}