class ResendOtpRequestDto {
  final String email;

  const ResendOtpRequestDto({required this.email});

  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}
