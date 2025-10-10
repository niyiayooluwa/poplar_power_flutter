import 'package:poplar_power/data/models/user/user_dto.dart';
import 'package:poplar_power/data/models/auth/wallet_dto.dart';

class AuthResponseDto {
  final bool isAuthenticated;
  final String? sessionId;
  final UserDto? user;
  final String? token;
  final bool mfaRequired;
  final String? mfaType;
  final bool deviceIsRegistered;
  final dynamic data;
  final String? poplarToken;
  final bool success;
  final String message;
  final WalletDto? wallet;

  AuthResponseDto({
    required this.isAuthenticated,
    this.sessionId,
    this.user,
    this.token,
    required this.mfaRequired,
    this.mfaType,
    required this.deviceIsRegistered,
    this.data,
    this.poplarToken,
    required this.success,
    required this.message,
    this.wallet,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    final ssoResponse = json['ssoResponse'] as Map<String, dynamic>? ?? {};
    final walletData = json['wallet']?['data'] as Map<String, dynamic>?;
    final accountData = walletData?['account'] as Map<String, dynamic>?;

    // Merge user data from ssoResponse.user and wallet.data.account only
    final Map<String, dynamic> mergedUserJson = {};
    if (ssoResponse['user'] != null) {
      mergedUserJson.addAll(ssoResponse['user'] as Map<String, dynamic>);
    }

    if (accountData != null) {
      // Safely parse numeric values that might come as strings
      final bankAccount = accountData['bankAccount'];
      final sysAccount = accountData['sysAccount'];

      mergedUserJson.addAll({
        'walletAccountNo': bankAccount is String
            ? int.tryParse(bankAccount)
            : bankAccount as int?,
        'systemRef': sysAccount is String
            ? int.tryParse(sysAccount)
            : sysAccount as int?,
      });
    }

    return AuthResponseDto(
      isAuthenticated: ssoResponse['is_authenticated'] as bool? ?? false,
      sessionId: ssoResponse['sessionId'] as String?,
      user: mergedUserJson.isNotEmpty ? UserDto.fromJson(mergedUserJson) : null,
      token: ssoResponse['token'] as String?,
      mfaRequired: ssoResponse['mfa_required'] as bool? ?? false,
      mfaType: ssoResponse['mfa_type'] as String?,
      deviceIsRegistered: ssoResponse['device_is_registered'] as bool? ?? false,
      data: ssoResponse['data'],
      poplarToken: ssoResponse['poplarToken'] as String?,
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? 'Unknown error',
      wallet: json['wallet'] != null
          ? WalletDto.fromJson(json['wallet'] as Map<String, dynamic>)
          : null,
    );
  }
  /*factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    final ssoResponse = json['ssoResponse'] as Map<String, dynamic>;
    final walletData = json['wallet']?['data'] as Map<String, dynamic>?;
    final accountData = walletData?['account'] as Map<String, dynamic>?;

    // Merge user data from ssoResponse.user and wallet.data.account only
    final Map<String, dynamic> mergedUserJson = {};
    if (ssoResponse['user'] != null) {
      mergedUserJson.addAll(ssoResponse['user'] as Map<String, dynamic>);
    }

    if (accountData != null) {
      // Safely parse numeric values that might come as strings
      final bankAccount = accountData['bankAccount'];
      final sysAccount = accountData['sysAccount'];

      mergedUserJson.addAll({
        'walletAccountNo': bankAccount is String
            ? int.tryParse(bankAccount)
            : bankAccount as int?,
        'systemRef': sysAccount is String
            ? int.tryParse(sysAccount)
            : sysAccount as int?,
      });
    }

    return AuthResponseDto(
      isAuthenticated: ssoResponse['is_authenticated'] as bool,
      sessionId: ssoResponse['sessionId'] as String?,
      user: mergedUserJson.isNotEmpty ? UserDto.fromJson(mergedUserJson) : null,
      token: ssoResponse['token'] as String?,
      mfaRequired: ssoResponse['mfa_required'] as bool,
      mfaType: ssoResponse['mfa_type'] as String?,
      deviceIsRegistered: ssoResponse['device_is_registered'] as bool,
      data: ssoResponse['data'],
      poplarToken: ssoResponse['poplarToken'] as String?,
      success: ssoResponse['success'] as bool,
      message: ssoResponse['message'] as String,
      wallet: json['wallet'] != null
          ? WalletDto.fromJson(json['wallet'] as Map<String, dynamic>)
          : null,
    );
  }*/
}
