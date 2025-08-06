import 'package:flutter/material.dart';
import '../../domain/models/transaction_config.dart';
import '../../domain/models/transaction_field.dart';
import '../../ui/core/widgets/transaction_confirmation.dart';

class TransactionSheetService {
  static const TransactionConfig transferConfig = TransactionConfig(
    type: 'Money Transfer',
    icon: Icons.send,
    color: Colors.blue,
    subtitle: 'Send money to bank account',
  );

  static const TransactionConfig airtimeConfig = TransactionConfig(
    type: 'Buy Airtime',
    icon: Icons.phone,
    color: Colors.green,
    subtitle: 'Mobile airtime top-up',
  );

  static const TransactionConfig dataConfig = TransactionConfig(
    type: 'Buy Data',
    icon: Icons.wifi,
    color: Colors.purple,
    subtitle: 'Mobile data bundle',
  );

  static const TransactionConfig electricityConfig = TransactionConfig(
    type: 'Buy Electricity',
    icon: Icons.electric_bolt,
    color: Colors.orange,
    subtitle: 'Electricity bill payment',
  );

  static const TransactionConfig billConfig = TransactionConfig(
    type: 'Pay Bill',
    icon: Icons.receipt,
    color: Colors.red,
    subtitle: 'Utility bill payment',
  );

  static Future<void> showConfirmation(
      BuildContext context, {
        required String title,
        required List<TransactionField> fields,
        required VoidCallback onConfirm,
        VoidCallback? onCancel,
        TransactionConfig? transactionConfig,
        String? amount,
        String? description,
        String? referenceNumber,
        String? processingTime,
        bool showSecurityBadge = true,
        String confirmButtonText = "Confirm Payment",
        String cancelButtonText = "Cancel",
        bool isLoading = false,
      }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ConfirmTransactionSheet(
        title: title,
        fields: fields,
        onConfirm: onConfirm,
        onCancel: onCancel,
        transactionConfig: transactionConfig,
        amount: amount,
        description: description,
        referenceNumber: referenceNumber,
        processingTime: processingTime,
        showSecurityBadge: showSecurityBadge,
        confirmButtonText: confirmButtonText,
        cancelButtonText: cancelButtonText,
        isLoading: isLoading,
      ),
    );
  }

  /// Creates transaction fields for money transfer
  static List<TransactionField> createTransferFields({
    required String recipientName,
    required String accountNumber,
    required String bankName,
    required String fee,
    required String total,
  }) {
    return [
      TransactionField(label: 'To', value: recipientName),
      TransactionField(label: 'Account', value: accountNumber),
      TransactionField(label: 'Bank', value: bankName),
      TransactionField(label: 'Transaction Fee', value: fee),
      TransactionField(label: 'Total Amount', value: total, isHighlighted: true),
    ];
  }

  /// Creates transaction fields for airtime purchase
  static List<TransactionField> createAirtimeFields({
    required String phoneNumber,
    required String network,
    required String amount,
  }) {
    return [
      TransactionField(label: 'Phone Number', value: phoneNumber),
      TransactionField(label: 'Network', value: network),
      TransactionField(label: 'Amount', value: amount, isHighlighted: true),
    ];
  }

  /// Creates transaction fields for data purchase
  static List<TransactionField> createDataFields({
    required String phoneNumber,
    required String network,
    required String plan,
    required String amount,
  }) {
    return [
      TransactionField(label: 'Phone Number', value: phoneNumber),
      TransactionField(label: 'Network', value: network),
      TransactionField(label: 'Plan', value: plan),
      TransactionField(label: 'Amount', value: amount, isHighlighted: true),
    ];
  }

  /// Creates transaction fields for electricity purchase
  static List<TransactionField> createElectricityFields({
    required String disco,
    required String meterNumber,
    required String customerName,
    required String fee,
    required String total,
  }) {
    return [
      TransactionField(label: 'Disco', value: disco),
      TransactionField(label: 'Meter Number', value: meterNumber),
      TransactionField(label: 'Customer Name', value: customerName),
      TransactionField(label: 'Service Fee', value: fee),
      TransactionField(label: 'Total Amount', value: total, isHighlighted: true),
    ];
  }

  /// Creates transaction fields for bill payment
  static List<TransactionField> createBillFields({
    required String service,
    required String accountNumber,
    required String package,
    required String fee,
    required String total,
  }) {
    return [
      TransactionField(label: 'Service', value: service),
      TransactionField(label: 'Account Number', value: accountNumber),
      TransactionField(label: 'Package', value: package),
      TransactionField(label: 'Service Fee', value: fee),
      TransactionField(label: 'Total Amount', value: total, isHighlighted: true),
    ];
  }
}