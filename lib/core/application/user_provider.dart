import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/repositories/auth_repository_impl.dart';
import 'package:poplar_power/data/storage/user_profile_storage.dart';
import 'package:poplar_power/domain/entities/user.dart';
import 'package:poplar_power/domain/repositories/auth_repository.dart';
import 'package:poplar_power/domain/use_cases/wallet/get_wallet_balance_use_case.dart';

class UserState {
  final AsyncValue<User?> user;
  final AsyncValue<double> balance;

  UserState({required this.user, required this.balance});

  factory UserState.initial() =>
      UserState(user: const AsyncLoading(), balance: const AsyncLoading());

  UserState copyWith({AsyncValue<User?>? user, AsyncValue<double>? balance}) {
    return UserState(user: user ?? this.user, balance: balance ?? this.balance);
  }
}

class UserNotifier extends StateNotifier<UserState> {
  final AuthRepository _authRepository;
  final UserProfileStorage _profileStorage;
  final GetWalletBalanceUseCase _getWalletBalanceUseCase;

  UserNotifier(
    this._authRepository,
    this._profileStorage,
    this._getWalletBalanceUseCase,
  ) : super(UserState.initial());

  Future<void> checkInitialStatus() async {
    // If user data is already available, no need to re-initialize
    if (state.user is AsyncData && state.user.value != null) {
      return;
    }

    // First, try to load from local storage
    final localUser = await _profileStorage.loadUser();
    if (localUser != null) {
      state = state.copyWith(user: AsyncData(localUser));
      await _fetchBalance(localUser);
      return;
    }

    // If no local user, check for a token and fetch from API
    final hasToken = await _authRepository.hasToken();
    if (hasToken) {
      final result = await _authRepository.getAuthenticatedUser();
      result.fold(
        ifLeft: (failure) =>
            state = state.copyWith(user: const AsyncData(null)),
        ifRight: (user) async {
          _profileStorage.saveUser(user); // Save to local storage
          state = state.copyWith(user: AsyncData(user));
          await _fetchBalance(user);
        },
      );
    } else {
      state = state.copyWith(user: const AsyncData(null));
    }
  }

  void onLoginSuccess(User user) async {
    _profileStorage.saveUser(user); // Save to local storage
    state = state.copyWith(user: AsyncData(user));
    await _fetchBalance(user);
  }

  Future<void> _fetchBalance(User user) async {
    state = state.copyWith(balance: const AsyncLoading());
    final result = await _getWalletBalanceUseCase.execute();

    result.fold(
      ifLeft: (failure) => state = state.copyWith(
        balance: AsyncError(failure, StackTrace.current),
      ),
      ifRight: (balance) => state = state.copyWith(balance: AsyncData(balance)),
    );
  }

  Future<void> logout() async {
    await _authRepository.logout();
    await _profileStorage.deleteUser(); // Delete from local storage
    state = state.copyWith(
      user: const AsyncData(null),
      balance: const AsyncData(0.0),
    );
  }
}

final userProfileStorageProvider = Provider((_) => UserProfileStorage());

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final profileStorage = ref.watch(userProfileStorageProvider);
  final getWalletBalanceUseCase = ref.watch(getWalletBalanceUseCaseProvider);
  return UserNotifier(authRepository, profileStorage, getWalletBalanceUseCase)
    ..checkInitialStatus();
});
