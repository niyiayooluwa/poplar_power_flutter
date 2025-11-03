class PasswordResetRequestDto {
  final String username;
  final String password; // This is the new password
  final String otp;

  const PasswordResetRequestDto({
    required this.username,
    required this.password,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'otp': otp,
    };
  }
}
