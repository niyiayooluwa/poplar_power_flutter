import 'package:dart_either/dart_either.dart';
import 'package:poplar_power/domain/entities/user.dart';
import 'package:poplar_power/domain/failures/auth_failure.dart';
import 'package:poplar_power/domain/repositories/auth_repository.dart';

class GetProfileUseCase {
  final AuthRepository _repository;

  GetProfileUseCase(this._repository);

  Future<Either<AuthFailure, User>> execute() async {
    return await _repository.getAuthenticatedUser();
  }
}
