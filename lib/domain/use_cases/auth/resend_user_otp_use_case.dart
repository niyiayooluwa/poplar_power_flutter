import 'package:dart_either/dart_either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/repositories/auth_repository_impl.dart';
import 'package:poplar_power/domain/failures/auth_failure.dart';
import 'package:poplar_power/domain/repositories/auth_repository.dart';

class ResendUserOtpUseCase {
  final AuthRepository _repository;

  ResendUserOtpUseCase(this._repository);

  Future<Either<AuthFailure, void>> execute(String email) async {
    return await _repository.resendUserOtp(email);
  }
}

final resendUserOtpUseCaseProvider = Provider<ResendUserOtpUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return ResendUserOtpUseCase(authRepository);
});