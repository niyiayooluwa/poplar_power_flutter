import 'package:dart_either/dart_either.dart';
import 'package:poplar_power/domain/failures/auth_failure.dart';
import 'package:poplar_power/domain/repositories/auth_repository.dart';

class ResendOtpUseCase {
  final AuthRepository _repository;

  ResendOtpUseCase(this._repository);

  Future<Either<AuthFailure, void>> execute(String email) async {
    return await _repository.resendOtp(email);
  }
}
