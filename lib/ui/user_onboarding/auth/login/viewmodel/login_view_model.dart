import 'dart:ui';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/core/application/user_provider.dart';
import 'package:poplar_power/domain/use_cases/auth/login_use_case.dart';


/// ViewModel managing login logic and state.
class LoginViewModel extends StateNotifier<AsyncValue<void>> {
  final LoginUseCase _loginUseCase;
  final Ref _ref;

  LoginViewModel(this._loginUseCase, this._ref)
    : super(const AsyncData(null));

  Future<void> login(
    String email,
    String password, {
    required VoidCallback onSuccess,
    required Function(String email, String password) onOtpRequired,
  }) async {
    state = const AsyncLoading();

    final result = await _loginUseCase.execute(email, password);

    result.fold(
      ifLeft: (failure) {
        if (failure.message.contains("Account is not verified")) {
          onOtpRequired(email, password); // Pass password here
        } else {
          state = AsyncError(failure.message, StackTrace.current);
        }
      },
      ifRight: (user) {
        if (!user.verified) {
          onOtpRequired(user.email, password); // Pass password here
        } else {
          _ref.read(userProvider.notifier).onLoginSuccess(user);
          onSuccess();
        }
        state = const AsyncData(null);
      },
    );
  }
}

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, AsyncValue<void>>((ref) {
      final loginUseCase = ref.watch(loginUseCaseProvider);
      return LoginViewModel(loginUseCase, ref);
    });
