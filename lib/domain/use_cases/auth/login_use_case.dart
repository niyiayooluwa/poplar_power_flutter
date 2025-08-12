import 'package:dart_either/dart_either.dart';
import 'package:poplar_power/domain/entities/user.dart';
import 'package:poplar_power/domain/failures/auth_failure.dart';
import 'package:poplar_power/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<AuthFailure, User>> execute(String email, String password) async {
    return await _repository.login(email, password);
  }
}
