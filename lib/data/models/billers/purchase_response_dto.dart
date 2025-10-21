class PurchaseResponseDto {
  final String paymentProvider;
  final String provider;
  final bool success;
  final String transactionRef;
  final String? clientSecret;
  final String? paymentLink;
  final String message;
  final String providerReference;

  PurchaseResponseDto({
    required this.paymentProvider,
    required this.provider,
    required this.success,
    required this.transactionRef,
    this.clientSecret,
    this.paymentLink,
    required this.message,
    required this.providerReference
  });

  factory PurchaseResponseDto.fromJson(Map<String, dynamic> json) {
    return PurchaseResponseDto(
      paymentProvider: json['paymentProvider'] as String,
      provider: json['provider'] as String,
      success: json['success'] as bool,
      transactionRef: json['transactionRef'] as String,
      clientSecret: json['clientSecret'] as String?,
      paymentLink: json['paymentLink'] as String?,
      message: json['message'] as String,
      providerReference: json['paystackReference'] as String,
    );
  }
}
