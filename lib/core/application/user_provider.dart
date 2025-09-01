import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/repositories/auth_repository_impl.dart';
import 'package:poplar_power/domain/entities/user.dart';
import 'package:poplar_power/domain/repositories/auth_repository.dart';

class UserNotifier extends StateNotifier<AsyncValue<User?>> {

  final AuthRepository _authRepository;
  UserNotifier(this._authRepository) : super(const AsyncLoading());

  Future<void> checkInitialStatus() async {
    final hasToken = await _authRepository.hasToken();
    if (hasToken) {
      final result = await _authRepository.getAuthenticatedUser();
      result.fold(
        ifLeft: (failure) => state = const AsyncData(null),
        ifRight: (user) => state = AsyncData(user),
      );
    } else {
      state = const AsyncData(null);
    }
  }

  void onLoginSuccess(User user) {
    state = AsyncData(user);
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = const AsyncData(null);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<User?>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return UserNotifier(authRepository)..checkInitialStatus();
});