class VerifyOtpRequestDto {
  final String email;
  final String password;
  final String otp;

  const VerifyOtpRequestDto({
    required this.email,
    required this.password,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {'username': email, 'password': password, 'otp': otp};
  }
}
