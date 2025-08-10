// lib/data/models/auth/auth_response_dto.dart
import 'package:poplar_power/data/models/user/user_dto.dart'; // Import UserDto

class AuthResponseDto {
  final String token;
  final UserDto user; // Assuming user details are returned with the token

  AuthResponseDto({
    required this.token,
    required this.user,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      token: json['token'] as String,
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
