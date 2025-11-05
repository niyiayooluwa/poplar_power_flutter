import 'dart:ui';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart'; 
import 'package:poplar_power/core/application/user_provider.dart';
import 'package:poplar_power/data/repositories/auth_repository_impl.dart'; 
import 'package:poplar_power/data/storage/credentials_storage.dart'; 
import 'package:poplar_power/domain/repositories/auth_repository.dart';
import 'package:poplar_power/domain/use_cases/auth/login_use_case.dart';


/// ViewModel managing login logic and state.
class LoginViewModel extends StateNotifier<AsyncValue<void>> {
  final LoginUseCase _loginUseCase;
  final AuthRepository _authRepository; 
  final CredentialsStorage _credentialsStorage; 
  final Ref _ref;
  final LocalAuthentication _localAuth = LocalAuthentication(); 

  LoginViewModel(this._loginUseCase, this._authRepository, this._credentialsStorage, this._ref)
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

  Future<bool> canAuthenticateWithBiometrics() async {
    final hasBiometrics = await _localAuth.canCheckBiometrics;
    final isDeviceSupported = await _localAuth.isDeviceSupported();
    final biometricEnabled = await _credentialsStorage.getBiometricPreference();
    final storedEmail = await _credentialsStorage.getEmail();
    final storedPassword = await _credentialsStorage.getPassword();

    return hasBiometrics && isDeviceSupported && biometricEnabled && storedEmail != null && storedPassword != null;
  }

  Future<void> authenticateWithBiometrics({
    required VoidCallback onSuccess,
    required Function(String message) onError,
  }) async {
    state = const AsyncLoading();
    try {
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to log in',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (isAuthenticated) {
        final storedEmail = await _credentialsStorage.getEmail();
        final storedPassword = await _credentialsStorage.getPassword();

        if (storedEmail != null && storedPassword != null) {
          final result = await _authRepository.login(storedEmail, storedPassword);
          result.fold(
            ifLeft: (failure) {
              state = AsyncError(failure.message, StackTrace.current);
              onError(failure.message);
            },
            ifRight: (user) {
              _ref.read(userProvider.notifier).onLoginSuccess(user);
              onSuccess();
              state = const AsyncData(null);
            },
          );
        } else {
          state = AsyncError('No stored credentials found', StackTrace.current);
          onError('No stored credentials found');
        }
      } else {
        state = const AsyncData(null);
        onError('Biometric authentication failed or cancelled');
      }
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
      onError(e.toString());
    }
  }
}

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, AsyncValue<void>>((ref) {
      final loginUseCase = ref.watch(loginUseCaseProvider);
      final authRepository = ref.watch(authRepositoryProvider);
      final credentialsStorage = ref.watch(credentialsStorageProvider);
      return LoginViewModel(loginUseCase, authRepository, credentialsStorage, ref);
    });
