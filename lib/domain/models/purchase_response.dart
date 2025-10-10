import 'package:poplar_power/data/models/billers/purchase_response_dto.dart';

class PurchaseResponse {
  final String paymentProvider;
  final String transactionRef;
  final String? clientSecret;
  final String? paymentLink;
  final String message;

  PurchaseResponse({
    required this.paymentProvider,
    required this.transactionRef,
    this.clientSecret,
    this.paymentLink,
    required this.message,
  });
}

extension PurchaseResponseDtoX on PurchaseResponseDto {
  PurchaseResponse toEntity() {
    return PurchaseResponse(
      paymentProvider: paymentProvider,
      transactionRef: transactionRef,
      clientSecret: clientSecret,
      paymentLink: paymentLink,
      message: message,
    );
  }
}
