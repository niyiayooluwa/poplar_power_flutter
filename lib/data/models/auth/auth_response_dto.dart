import 'dart:convert';

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
    // Handle the nested JSON string in the message field
    String finalMessage = json['message'];
    if (json['message'] is String && json['message'].contains('{')) {
      try {
        final nestedJson = jsonDecode(json['message'].substring(json['message'].indexOf('{')));
        finalMessage = nestedJson['message'] ?? json['message'];
      } catch (e) {
        // Ignore if parsing fails, use the original message
      }
    }

    return AuthResponseDto(
      isAuthenticated: json['is_authenticated'] as bool,
      sessionId: json['sessionId'] as String?,
      user: json['user'] != null ? UserDto.fromJson(json['user'] as Map<String, dynamic>) : null,
      token: json['token'] as String?,
      mfaRequired: json['mfa_required'] as bool,
      mfaType: json['mfa_type'] as String?,
      deviceIsRegistered: json['device_is_registered'] as bool,
      data: json['data'],
      poplarToken: json['poplarToken'] as String?,
      success: json['success'] as bool,
      message: finalMessage,
    );
  }
}
