import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/entities/user.dart';
import 'package:poplar_power/domain/use_cases/profile/get_profile_use_case.dart';
import 'package:poplar_power/domain/use_cases/profile/logout_use_case.dart';
import 'package:poplar_power/data/repositories/auth_repository_impl.dart';
import 'package:poplar_power/data/services/settings_service.dart';

class ProfileViewModel extends StateNotifier<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final LogOutUseCase _logOutUseCase;
  final SettingsService _settingsService;

  ProfileViewModel(
    this._getProfileUseCase,
    this._logOutUseCase,
    this._settingsService,
  ) : super(ProfileState.initial()) {
    loadProfile();
    _loadBiometricsSetting();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true);
    final result = await _getProfileUseCase.execute();
    result.fold(
      ifLeft: (failure) => state = state.copyWith(isLoading: false),
      ifRight: (user) => state = state.copyWith(
        user: user,
        isLoading: false,
      ),
    );
  }

  Future<void> _loadBiometricsSetting() async {
    final enableBiometrics = await _settingsService.getBiometricsSetting();
    state = state.copyWith(enableBiometrics: enableBiometrics);
  }

  Future<void> setBiometrics(bool value) async {
    await _settingsService.setBiometricsSetting(value);
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
  final User? user;
  final bool isLoading;
  final bool enableBiometrics;
  final bool isLoggedOut;

  ProfileState({
    this.user,
    this.isLoading = true,
    this.enableBiometrics = false,
    this.isLoggedOut = false,
  });

  factory ProfileState.initial() => ProfileState();

  ProfileState copyWith({
    User? user,
    bool? isLoading,
    bool? enableBiometrics,
    bool? isLoggedOut,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      enableBiometrics: enableBiometrics ?? this.enableBiometrics,
      isLoggedOut: isLoggedOut ?? this.isLoggedOut,
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
        final getProfileUseCase = ref.watch(getProfileUseCaseProvider);
        final logOutUseCase = ref.watch(logOutUseCaseProvider);
        final settingsService = ref.watch(settingsServiceProvider);
        return ProfileViewModel(getProfileUseCase, logOutUseCase, settingsService);
      },
    );