class SignupRequest {
  final String email;
  final String password;
  final String phone;
  final String fullName;
  final String? customRef;

  const SignupRequest({
    required this.email,
    required this.password,
    required this.phone,
    required this.fullName,
    this.customRef,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'phone': phone,
      'fullName': fullName,
      if (customRef != null) 'customRef': customRef,
    };
  }
}

class SignupResponse {}