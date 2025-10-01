class PurchaseResponseDto {
  final String paymentProvider;
  final String provider;
  final bool success;
  final String transactionRef;
  final String? clientSecret;
  final String message;

  PurchaseResponseDto({
    required this.paymentProvider,
    required this.provider,
    required this.success,
    required this.transactionRef,
    this.clientSecret,
    required this.message,
  });

  factory PurchaseResponseDto.fromJson(Map<String, dynamic> json) {
    return PurchaseResponseDto(
      paymentProvider: json['paymentProvider'] as String,
      provider: json['provider'] as String,
      success: json['success'] as bool,
      transactionRef: json['transactionRef'] as String,
      clientSecret: json['clientSecret'] as String?,
      message: json['message'] as String,
    );
  }
}
