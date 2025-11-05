import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A utility class for securely storing and managing user credentials (email and password).
///
/// This class uses `flutter_secure_storage` to store credentials, ensuring they are
/// kept safe on the device.
class CredentialsStorage {
  static const _storage = FlutterSecureStorage();

  static const _emailKey = 'user_email';
  static const _passwordKey = 'user_password';
  static const _biometricEnabledKey = 'biometric_enabled';

  /// Saves the provided [email] and [password] to secure storage.
  Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _passwordKey, value: password);
  }

  /// Saves the biometric preference.
  Future<void> saveBiometricPreference(bool enabled) async {
    await _storage.write(key: _biometricEnabledKey, value: enabled.toString());
  }

  /// Retrieves the biometric preference.
  Future<bool> getBiometricPreference() async {
    final value = await _storage.read(key: _biometricEnabledKey);
    return value == 'true';
  }

  /// Retrieves the stored email from secure storage.
  /// Returns the email string if it exists, otherwise returns `null`.
  Future<String?> getEmail() async {
    return await _storage.read(key: _emailKey);
  }

  /// Retrieves the stored password from secure storage.
  /// Returns the password string if it exists, otherwise returns `null`.
  Future<String?> getPassword() async {
    return await _storage.read(key: _passwordKey);
  }

  /// Deletes the stored email and password from secure storage.
  Future<void> deleteCredentials() async {
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _passwordKey);
  }
}
