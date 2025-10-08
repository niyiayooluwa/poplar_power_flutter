// lib/domain/entities/user.dart

class User {
  final String id;
  final String email;
  final String fullName;
  final String phone;
  final String? customRef;
  final bool verified;
  final bool active;
  final String? systemRef;
  final String? serviceRef;
  final String? walletAccountNo;
  final String? currency;
  final bool? pinCreated;
  final String? customerStatus;
  final String? accountStatus;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    this.customRef,
    required this.verified,
    required this.active,
    this.systemRef,
    this.serviceRef,
    this.walletAccountNo,
    this.currency,
    this.pinCreated,
    this.customerStatus,
    this.accountStatus,
  });
}
