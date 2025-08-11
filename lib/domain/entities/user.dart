// lib/domain/entities/user.dart

class User {
  final String id;
  final String email;
  final String fullName;
  final String phone;
  final String? customRef;
  final bool verified;
  final bool active;
  final double? balance;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    this.customRef,
    required this.verified,
    required this.active,
    this.balance,
  });
}
