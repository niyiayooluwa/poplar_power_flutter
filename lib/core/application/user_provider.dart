import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/repositories/auth_repository_impl.dart';
import 'package:poplar_power/data/storage/user_profile_storage.dart';
import 'package:poplar_power/domain/entities/user.dart';
import 'package:poplar_power/domain/repositories/auth_repository.dart';

class UserNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository _authRepository;
  final UserProfileStorage _profileStorage;

  UserNotifier(this._authRepository, this._profileStorage)
      : super(const AsyncLoading());

  Future<void> checkInitialStatus() async {
    // First, try to load from local storage
    final localUser = await _profileStorage.loadUser();
    if (localUser != null) {
      state = AsyncData(localUser);
      return;
    }

    // If no local user, check for a token and fetch from API
    final hasToken = await _authRepository.hasToken();
    if (hasToken) {
      final result = await _authRepository.getAuthenticatedUser();
      result.fold(
        ifLeft: (failure) => state = const AsyncData(null),
        ifRight: (user) {
          _profileStorage.saveUser(user); // Save to local storage
          state = AsyncData(user);
        },
      );
    } else {
      state = const AsyncData(null);
    }
  }

  void onLoginSuccess(User user) {
    _profileStorage.saveUser(user); // Save to local storage
    state = AsyncData(user);
  }

  Future<void> logout() async {
    await _authRepository.logout();
    await _profileStorage.deleteUser(); // Delete from local storage
    state = const AsyncData(null);
  }
}

final userProfileStorageProvider = Provider((_) => UserProfileStorage());

final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<User?>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final profileStorage = ref.watch(userProfileStorageProvider);
  return UserNotifier(authRepository, profileStorage)..checkInitialStatus();
});