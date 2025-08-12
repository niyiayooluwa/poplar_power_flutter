import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:poplar_power/data/repositories/auth_repository_impl.dart';
import 'package:poplar_power/data/services/settings_service.dart';
import 'package:poplar_power/domain/models/profile.dart';
import 'package:poplar_power/domain/use_cases/profile/get_profile_use_case.dart';
import 'package:poplar_power/domain/use_cases/profile/logout_use_case.dart';

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
        profile: Profile(
          fullName: user.fullName,
          email: user.email,
          phoneNumber: user.phone,
        ),
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
  final Profile? profile;
  final bool isLoading;
  final bool enableBiometrics;
  final bool isLoggedOut;

  ProfileState({
    this.profile,
    this.isLoading = true,
    this.enableBiometrics = false,
    this.isLoggedOut = false,
  });

  factory ProfileState.initial() => ProfileState();

  ProfileState copyWith({
    Profile? profile,
    bool? isLoading,
    bool? enableBiometrics,
    bool? isLoggedOut,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      enableBiometrics: enableBiometrics ?? this.enableBiometrics,
      isLoggedOut: isLoggedOut ?? this.isLoggedOut,
    );
  }
}

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, ProfileState>(
      (ref) => ProfileViewModel(
        GetProfileUseCase(
          AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSourceImpl()),
        ),
        LogOutUseCase(
          AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSourceImpl()),
        ),
        SettingsService(),
      ),
    );
