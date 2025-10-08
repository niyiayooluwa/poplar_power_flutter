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
  final int? lastLogin;
  final int modified;
  final int created;
  final bool active;
  final bool verified;
  final bool lock;
  final String? systemRef;
  final String? serviceRef;
  final String? walletAccountNo;
  final String? currency;
  final bool? pinCreated;
  final String? customerStatus;
  final String? accountStatus;

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
    this.systemRef,
    this.serviceRef,
    this.walletAccountNo,
    this.currency,
    this.pinCreated,
    this.customerStatus,
    this.accountStatus,
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
      lastLogin: json['lastLogin'] as int?,
      modified: json['modified'] as int,
      created: json['created'] as int,
      active: json['active'] as bool,
      verified: json['verified'] as bool,
      lock: json['lock'] as bool,
      systemRef: json['systemRef'] as String?,
      serviceRef: json['serviceRef'] as String?,
      walletAccountNo: json['walletAccountNo'] as String?,
      currency: json['currency'] as String?,
      pinCreated: json['pinCreated'] as bool?,
      customerStatus: json['customerStatus'] as String?,
      accountStatus: json['accountStatus'] as String?,
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
      systemRef: systemRef,
      serviceRef: serviceRef,
      walletAccountNo: walletAccountNo,
      currency: currency,
      pinCreated: pinCreated,
      customerStatus: customerStatus,
      accountStatus: accountStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyAppId': companyAppId,
      'email': email,
      'phone': phone,
      'fullName': fullName,
      'ref': ref,
      'customRef': customRef,
      'sessionId': sessionId,
      'mfaCode': mfaCode,
      'emailValid': emailValid,
      'phoneValid': phoneValid,
      'failedAuthAttempts': failedAuthAttempts,
      'lockAt': lockAt,
      'unlockAt': unlockAt,
      'lastLogin': lastLogin,
      'modified': modified,
      'created': created,
      'active': active,
      'verified': verified,
      'lock': lock,
      'systemRef': systemRef,
      'serviceRef': serviceRef,
      'walletAccountNo': walletAccountNo,
      'currency': currency,
      'pinCreated': pinCreated,
      'customerStatus': customerStatus,
      'accountStatus': accountStatus,
    };
  }

  factory UserDto.fromEntity(User user) {
    // This is a partial conversion, as we can't reconstruct all API fields from the entity.
    // It's primarily for saving the user profile to local storage.
    return UserDto(
      id: int.tryParse(user.id) ?? 0,
      email: user.email,
      phone: user.phone,
      fullName: user.fullName,
      verified: user.verified,
      active: user.active,
      customRef: user.customRef,
      systemRef: user.systemRef,
      serviceRef: user.serviceRef,
      walletAccountNo: user.walletAccountNo,
      currency: user.currency,
      pinCreated: user.pinCreated,
      customerStatus: user.customerStatus,
      accountStatus: user.accountStatus,
      // Fields not in User entity are set to default/dummy values
      companyAppId: 0,
      ref: '',
      sessionId: null,
      mfaCode: null,
      emailValid: false,
      phoneValid: false,
      failedAuthAttempts: 0,
      lockAt: null,
      unlockAt: null,
      lastLogin: null,
      modified: 0,
      created: 0,
      lock: false,
    );
  }
}