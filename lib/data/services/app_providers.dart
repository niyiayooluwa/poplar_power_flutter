import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/services/settings_service.dart';

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService();
});
