import 'package:poplar_power/domain/models/notification_preference.dart';

class TransactionPayload {
  final String customerIdentifier;
  final int amount;
  final String categoryGroup;
  final String categoryOrBiller;
  final String billerOrProductId;
  final NotificationPreference notificationPreference;

  TransactionPayload({
    required this.customerIdentifier,
    required this.amount,
    required this.categoryGroup,
    required this.categoryOrBiller,
    required this.billerOrProductId,
    required this.notificationPreference,
  });
}
