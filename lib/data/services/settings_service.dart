import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _biometricsKey = 'enableBiometrics';

  Future<bool> getBiometricsSetting() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricsKey) ?? false;
  }

  Future<void> setBiometricsSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricsKey, value);
  }
}
