import 'package:poplar_power/domain/entities/user.dart';
import 'package:poplar_power/domain/repositories/auth_repository.dart';
import 'package:poplar_power/utils/validators.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<User> execute(String email, String password, String phone, String fullName, String? customRef) async {
    final emailError = validateEmail(email);
    if (emailError != null) {
      throw Exception(emailError);
    }

    final passwordError = validatePassword(password);
    if (passwordError != null) {
      throw Exception(passwordError);
    }

    if (phone.isEmpty) {
      throw Exception('Phone number is required');
    }

    if (fullName.isEmpty) {
      throw Exception('Full name is required');
    }

    return await _repository.register(email, password, phone, fullName, customRef);
  }
}
