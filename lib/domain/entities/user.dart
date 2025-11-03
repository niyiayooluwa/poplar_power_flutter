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

  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    String? customRef,
    bool? verified,
    bool? active,
    String? systemRef,
    String? serviceRef,
    String? walletAccountNo,
    String? currency,
    bool? pinCreated,
    String? customerStatus,
    String? accountStatus,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      customRef: customRef ?? this.customRef,
      verified: verified ?? this.verified,
      active: active ?? this.active,
      systemRef: systemRef ?? this.systemRef,
      serviceRef: serviceRef ?? this.serviceRef,
      walletAccountNo: walletAccountNo ?? this.walletAccountNo,
      currency: currency ?? this.currency,
      pinCreated: pinCreated ?? this.pinCreated,
      customerStatus: customerStatus ?? this.customerStatus,
      accountStatus: accountStatus ?? this.accountStatus,
    );
  }
}
