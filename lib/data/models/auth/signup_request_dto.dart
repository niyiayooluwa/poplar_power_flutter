class SignupRequestDto {
  final String email;
  final String password;
  final String phone;
  final String fullName;
  final String? customRef;
  final int pin;

  const SignupRequestDto({
    required this.email,
    required this.password,
    required this.phone,
    required this.fullName,
    this.customRef,
    required this.pin
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'phone': phone,
      'fullName': fullName,
      'pin': pin,
      if (customRef != null) 'customRef': customRef,
    };
  }
}