import 'package:poplar_power/domain/repositories/auth_repository.dart';

class LogOutUseCase {
  final AuthRepository _repository;

  LogOutUseCase(this._repository);

  Future<void> execute() async {
    return await _repository.logout();
  }
}
