// lib/domain/entities/user.dart

class User {
  final String id;
  final String email;
  final String fullName;
  final String phone;
  final String? customRef; // Optional based on your register DTO
  final double? balance; // Assuming balance might be part of the user entity

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    this.customRef,
    this.balance,
  });
}
