// lib/ui/auth/view_model/auth_view_model.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../data/mock/mock_service/mock_auth_service.dart';

/// ViewModel managing login logic and state.
class LoginViewModel extends StateNotifier<AsyncValue<void>> {
  final MockAuthService _authService;

  LoginViewModel(this._authService) : super(const AsyncData(null));

  /// Attempts login using the mock auth service.
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    try {
      await _authService.login(email, password);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

/// Provides [loginViewModel] with a mock service for now.
final loginViewModelProvider =
  StateNotifierProvider<LoginViewModel, AsyncValue<void>>(
      (ref) => LoginViewModel(MockAuthService()),
);
