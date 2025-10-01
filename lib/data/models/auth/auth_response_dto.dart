import 'package:poplar_power/data/models/user/user_dto.dart';

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
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    final ssoResponse = json['ssoResponse'] as Map<String, dynamic>;
    return AuthResponseDto(
      isAuthenticated: ssoResponse['is_authenticated'] as bool,
      sessionId: ssoResponse['sessionId'] as String?,
      user: ssoResponse['user'] != null
          ? UserDto.fromJson(ssoResponse['user'] as Map<String, dynamic>)
          : null,
      token: ssoResponse['token'] as String?,
      mfaRequired: ssoResponse['mfa_required'] as bool,
      mfaType: ssoResponse['mfa_type'] as String?,
      deviceIsRegistered: ssoResponse['device_is_registered'] as bool,
      data: ssoResponse['data'],
      poplarToken: ssoResponse['poplarToken'] as String?,
      success: ssoResponse['success'] as bool,
      message: ssoResponse['message'] as String,
    );
  }
}
