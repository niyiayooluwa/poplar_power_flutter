import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A utility class for securely storing and managing an authentication token.
///
/// This class uses `flutter_secure_storage` to store the token, ensuring it's
/// kept safe on the device.
class TokenStorage {
  // An instance of FlutterSecureStorage, used for all storage operations.
  // It's declared as `static const` because we only need one instance throughout the app.
  static const _storage = FlutterSecureStorage();

  // The key under which the authentication token will be stored.
  // Using a constant for the key helps prevent typos and ensures consistency.
  static const _tokenKey = 'auth_token';


  //============================================================================
  // AUTH TOKEN METHODS
  //============================================================================
  /// Saves the provided authentication [token] to secure storage.
  ///
  /// [token]: The authentication token string to be saved.
  static Future<void> saveToken(String token) async {
    // Writes the token to secure storage using the predefined key.
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Retrieves the stored authentication token from secure storage.
  ///
  /// Returns the token string if it exists, otherwise returns `null`.
  static Future<String?> getToken() async {
    // Reads the token from secure storage using the predefined key.
    return await _storage.read(key: _tokenKey);
  }

  /// Deletes the stored authentication token from secure storage.
  static Future<void> deleteToken() async {
    // Deletes the token from secure storage using the predefined key.
    await _storage.delete(key: _tokenKey);
  }
}