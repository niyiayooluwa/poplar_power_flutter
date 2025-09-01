import 'package:dart_either/dart_either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/repositories/auth_repository_impl.dart';
import 'package:poplar_power/domain/entities/user.dart';
import 'package:poplar_power/domain/failures/auth_failure.dart';
import 'package:poplar_power/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository _repository;

  VerifyOtpUseCase(this._repository);

  Future<Either<AuthFailure, User>> execute(
    String email,
    String password,
    String otp,
  ) async {
    return await _repository.verifyOtp(email, password, otp);
  }
}

final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return VerifyOtpUseCase(authRepository);
});
