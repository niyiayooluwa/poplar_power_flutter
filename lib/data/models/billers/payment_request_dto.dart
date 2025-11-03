import 'package:poplar_power/domain/models/notification_preference.dart';
import 'package:poplar_power/domain/models/payment_provider.dart';

class PaymentRequestDto {
  final String customerIdentifier;
  final int amount;
  final String? walletPin;
  final String? email;
  final String? phoneNumber;
  final NotificationPreference notificationPreference;
  final PaymentProvider provider;
  final String categoryGroup;
  final String categoryOrBiller;
  final String billerOrProductId;

  PaymentRequestDto({
    required this.customerIdentifier,
    required this.amount,
    this.walletPin,
    this.email,
    this.phoneNumber,
    this.notificationPreference = NotificationPreference.both,
    required this.provider,
    required this.categoryGroup,
    required this.categoryOrBiller,
    required this.billerOrProductId,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerIdentifier': customerIdentifier,
      'amount': amount,
      'walletPin': walletPin,
      'email': email,
      'phoneNumber': phoneNumber,
      'notificationPreference': notificationPreference.toJson(),
      'provider': provider.toJson(),
      'categoryGroup': categoryGroup,
      'categoryOrBiller': categoryOrBiller,
      'billerOrProductId': billerOrProductId,
    };
  }
}
