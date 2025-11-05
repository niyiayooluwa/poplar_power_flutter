import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart'; // Import local_auth
import 'package:poplar_power/core/application/user_provider.dart';
import 'package:poplar_power/data/storage/credentials_storage.dart'; // Import CredentialsStorage
import 'package:poplar_power/domain/use_cases/profile/get_profile_use_case.dart';
import 'package:poplar_power/domain/use_cases/profile/logout_use_case.dart';
import 'package:poplar_power/data/repositories/auth_repository_impl.dart';
import 'package:poplar_power/data/services/settings_service.dart';

class ProfileViewModel extends StateNotifier<ProfileState> {
  final LogOutUseCase _logOutUseCase;
  final SettingsService _settingsService;
  final CredentialsStorage _credentialsStorage; // Add CredentialsStorage
  final LocalAuthentication _localAuth = LocalAuthentication(); // Add LocalAuthentication instance

  ProfileViewModel(
    this._logOutUseCase,
    this._settingsService,
    this._credentialsStorage, // Add to constructor
  ) : super(ProfileState.initial()) {
    _loadBiometricsSetting();
    _checkBiometricSupport();
  }

  Future<void> _loadBiometricsSetting() async {
    final enableBiometrics = await _credentialsStorage.getBiometricPreference(); // Use CredentialsStorage
    state = state.copyWith(enableBiometrics: enableBiometrics);
  }

  Future<void> _checkBiometricSupport() async {
    final canCheck = await _localAuth.canCheckBiometrics;
    final isSupported = await _localAuth.isDeviceSupported();
    state = state.copyWith(canCheckBiometrics: canCheck && isSupported);
  }

  Future<void> setBiometrics(bool value) async {
    await _credentialsStorage.saveBiometricPreference(value); // Use CredentialsStorage
    state = state.copyWith(enableBiometrics: value);
  }

  void changePassword() {
    // Simulate change password logic
  }

  Future<void> logout() async {
    await _logOutUseCase.execute();
    state = state.copyWith(isLoggedOut: true);
  }

  void resetLogoutStatus() {
    state = state.copyWith(isLoggedOut: false);
  }
}

class ProfileState {
  final bool isLoading;
  final bool enableBiometrics;
  final bool isLoggedOut;
  final bool canCheckBiometrics; // Add this line

  ProfileState({
    this.isLoading = true,
    this.enableBiometrics = false,
    this.isLoggedOut = false,
    this.canCheckBiometrics = false, // Initialize
  });

  factory ProfileState.initial() => ProfileState();

  ProfileState copyWith({
    bool? isLoading,
    bool? enableBiometrics,
    bool? isLoggedOut,
    bool? canCheckBiometrics, // Add to copyWith
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      enableBiometrics: enableBiometrics ?? this.enableBiometrics,
      isLoggedOut: isLoggedOut ?? this.isLoggedOut,
      canCheckBiometrics: canCheckBiometrics ?? this.canCheckBiometrics,
    );
  }
}

final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GetProfileUseCase(authRepository);
});

final logOutUseCaseProvider = Provider<LogOutUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LogOutUseCase(authRepository);
});

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, ProfileState>(
      (ref) {
        final logOutUseCase = ref.watch(logOutUseCaseProvider);
        final settingsService = ref.watch(settingsServiceProvider);
        final credentialsStorage = ref.watch(credentialsStorageProvider);
        return ProfileViewModel(logOutUseCase, settingsService, credentialsStorage);
      },
    );