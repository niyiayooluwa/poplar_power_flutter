import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/failures/auth_failure.dart';
import 'package:poplar_power/domain/repositories/auth_repository.dart';
import 'package:poplar_power/data/repositories/auth_repository_impl.dart'; // Import auth_repository_impl.dart

class PasswordRecoveryUseCase {
  final AuthRepository _authRepository;

  PasswordRecoveryUseCase(this._authRepository);

  Future<AuthFailure?> execute(
    String email,
    String otp,
    String newPassword,
  ) async {
    return await _authRepository.resetPassword(email, otp, newPassword);
  }
}

final passwordRecoveryUseCaseProvider = Provider<PasswordRecoveryUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return PasswordRecoveryUseCase(authRepository);
});
