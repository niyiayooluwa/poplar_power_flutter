import 'package:poplar_power/domain/entities/user.dart';
import 'package:poplar_power/domain/repositories/auth_repository.dart';
import 'package:poplar_power/utils/validators.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<User> execute(String email, String password) async {
    final emailError = validateEmail(email);
    if (emailError != null) {
      throw Exception(emailError);
    }

    if (password.isEmpty) {
      throw Exception('Password is required');
    }

    return await _repository.login(email, password);
  }
}
