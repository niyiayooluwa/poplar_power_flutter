import 'package:dart_either/dart_either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/repositories/auth_repository_impl.dart';
import 'package:poplar_power/domain/entities/user.dart';
import 'package:poplar_power/domain/failures/auth_failure.dart';
import 'package:poplar_power/domain/repositories/auth_repository.dart';
import 'package:poplar_power/utils/validators.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<AuthFailure, User>> execute(
    String email,
    String password,
  ) async {
    final emailError = validateEmail(email);
    if (emailError != null) {
      return Left(AuthFailure.invalidEmail());
    }

    if (password.isEmpty) {
      return Left(
        AuthFailure.wrongPassword(),
      ); // Or a more specific message like 'Password cannot be empty'
    }

    return await _repository.login(email, password);
  }
}

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginUseCase(authRepository);
});