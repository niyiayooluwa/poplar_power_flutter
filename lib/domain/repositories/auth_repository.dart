// lib/domain/repositories/auth_repository.dart
import 'package:poplar_power/domain/entities/user.dart'; // Returns domain entity

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String phone, String fullName, String? customRef);
  Future<void> logout();
  Future<bool> hasToken(); // Check if user is logged in
  Future<User> getAuthenticatedUser(); // Get profile of logged-in user
}
