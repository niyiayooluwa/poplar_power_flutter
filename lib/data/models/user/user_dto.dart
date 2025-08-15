// lib/data/models/user/user_dto.dart
import 'package:poplar_power/domain/entities/user.dart'; // To convert to entity

class UserDto {
  final int id;
  final int companyAppId;
  final String email;
  final String phone;
  final String fullName;
  final String ref;
  final String? customRef;
  final String? sessionId;
  final String? mfaCode;
  final bool emailValid;
  final bool phoneValid;
  final int failedAuthAttempts;
  final int? lockAt;
  final int? unlockAt;
  final int lastLogin;
  final int modified;
  final int created;
  final bool active;
  final bool verified;
  final bool lock;

  UserDto({
    required this.id,
    required this.companyAppId,
    required this.email,
    required this.phone,
    required this.fullName,
    required this.ref,
    this.customRef,
    this.sessionId,
    this.mfaCode,
    required this.emailValid,
    required this.phoneValid,
    required this.failedAuthAttempts,
    this.lockAt,
    this.unlockAt,
    required this.lastLogin,
    required this.modified,
    required this.created,
    required this.active,
    required this.verified,
    required this.lock,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as int,
      companyAppId: json['companyAppId'] as int,
      email: json['email'] as String,
      phone: json['phone'] as String,
      fullName: json['fullName'] as String,
      ref: json['ref'] as String,
      customRef: json['customRef'] as String?,
      sessionId: json['sessionId'] as String?,
      mfaCode: json['mfaCode'] as String?,
      emailValid: json['emailValid'] as bool,
      phoneValid: json['phoneValid'] as bool,
      failedAuthAttempts: json['failedAuthAttempts'] as int,
      lockAt: json['lockAt'] as int?,
      unlockAt: json['unlockAt'] as int?,
      lastLogin: json['lastLogin'] as int,
      modified: json['modified'] as int,
      created: json['created'] as int,
      active: json['active'] as bool,
      verified: json['verified'] as bool,
      lock: json['lock'] as bool,
    );
  }

  User toEntity() {
    return User(
      id: id.toString(),
      email: email,
      fullName: fullName,
      phone: phone,
      customRef: customRef,
      verified: verified,
      active: active,
      balance: 40000.0,
    );
  }
}