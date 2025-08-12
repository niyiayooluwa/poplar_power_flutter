import 'package:dart_either/dart_either.dart';
import 'package:poplar_power/domain/entities/user.dart';
import 'package:poplar_power/domain/failures/auth_failure.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, User>> login(String email, String password);
  Future<Either<AuthFailure, User>> register(String email, String password, String phone, String fullName, String? customRef);
  Future<void> logout();
  Future<bool> hasToken(); // Check if user is logged in
  Future<Either<AuthFailure, User>> getAuthenticatedUser(); // Get profile of logged-in user
}
