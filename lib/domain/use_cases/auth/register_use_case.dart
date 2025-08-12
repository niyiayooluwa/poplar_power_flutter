import 'package:dart_either/dart_either.dart';
import 'package:poplar_power/domain/entities/user.dart';
import 'package:poplar_power/domain/failures/auth_failure.dart';
import 'package:poplar_power/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<Either<AuthFailure, User>> execute(
    String email,
    String password,
    String phone,
    String fullName,
    String? customRef,
  ) async {
    return await _repository.register(
      email,
      password,
      phone,
      fullName,
      customRef,
    );
  }
}
