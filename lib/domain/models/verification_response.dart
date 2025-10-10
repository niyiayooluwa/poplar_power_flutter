class VerificationResponse {
  final bool success;
  final String message;
  final String? providerStatus;

  VerificationResponse({
    required this.success,
    required this.message,
    this.providerStatus,
  });

  factory VerificationResponse.fromJson(Map<String, dynamic> json) {
    return VerificationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'An unknown error occurred.',
      providerStatus: json['providerStatus'],
    );
  }
}
