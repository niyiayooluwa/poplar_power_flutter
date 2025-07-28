import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel extends StateNotifier<ProfileState> {
  ProfileViewModel() : super(ProfileState.initial()) {
    _loadProfile();
    _loadBiometricsSetting();
  }

  Future<void> _loadProfile() async {
    // Simulate loading profile data
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      profile: Profile(
        fullName: 'John Doe',
        email: 'john.doe@example.com',
        phoneNumber: '+1 123-456-7890',
      ),
      isLoading: false,
    );
  }

  Future<void> _loadBiometricsSetting() async {
    final prefs = await SharedPreferences.getInstance();
    final enableBiometrics = prefs.getBool('enableBiometrics') ?? false;
    state = state.copyWith(enableBiometrics: enableBiometrics);
  }

  Future<void> setBiometrics(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enableBiometrics', value);
    state = state.copyWith(enableBiometrics: value);
  }

  void changePassword() {
    // Simulate change password logic
    print('Change password button pressed');
  }
}

class ProfileState {
  final Profile? profile;
  final bool isLoading;
  final bool enableBiometrics;

  ProfileState({
    this.profile,
    this.isLoading = true,
    this.enableBiometrics = false,
  });

  factory ProfileState.initial() => ProfileState();

  ProfileState copyWith({
    Profile? profile,
    bool? isLoading,
    bool? enableBiometrics,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      enableBiometrics: enableBiometrics ?? this.enableBiometrics,
    );
  }
}

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, ProfileState>(
  (ref) => ProfileViewModel(),
);
