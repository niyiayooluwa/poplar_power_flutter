import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poplar_power/domain/models/transaction_status.dart' as domain;

enum TransactionStatus {
  success,
  failed,
  reversed,
  pending,
}

class Transaction {
  final String title;
  final double amount;
  final DateTime date;
  final TransactionStatus status;
  final IconData icon;
  final String transactionId;
  final String merchant;
  final String paymentMethod;
  final String fee;


  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.status,
    required this.icon,
    required this.transactionId,
    required this.merchant,
    required this.paymentMethod,
    required this.fee,
  });


  factory Transaction.fromStatus(domain.TransactionStatus domainStatus) {
    final uiStatus = _getUiStatus(domainStatus);
    final isCredit = domainStatus.amount.isNegative;

    return Transaction(
      title: domainStatus.provider,
      amount: domainStatus.amount,
      date: DateTime.parse(domainStatus.createdAt),
      status: uiStatus,
      icon: _getIcon(uiStatus, isCredit),
      transactionId: domainStatus.nettpayRef,
      merchant: domainStatus.billerId, // Using provider as merchant
      paymentMethod: domainStatus.provider,
      // TODO: Fee is not available in the API response. Defaulting to 0.
      fee: '₦0',
    );
  }

  static TransactionStatus _getUiStatus(domain.TransactionStatus domainStatus) {
    if (domainStatus.reversed) {
      return TransactionStatus.reversed;
    }
    if (domainStatus.delivered) {
      return TransactionStatus.success;
    }
    // TODO: This assumes that if a transaction is not delivered and not reversed, it's pending.
    // The backend doesn't provide an explicit 'failed' or 'pending' status.
    return TransactionStatus.pending;
  }

  static IconData _getIcon(TransactionStatus status, bool isCredit) {
    switch (status) {
      case TransactionStatus.reversed:
        return Icons.subdirectory_arrow_left_sharp;
      case TransactionStatus.failed:
        return Icons.cancel_outlined;
      case TransactionStatus.pending:
      case TransactionStatus.success:
        return isCredit ? Icons.arrow_downward : Icons.arrow_upward;
    }
  }


  /// Whether this transaction_history_detail is a credit (income) type.
  bool get isCredit => amount > 0;

  /// Whether the transaction_history_detail failed.
  bool get isFailed => status == TransactionStatus.failed;

  /// Whether the transaction_history_detail was reversed.
  bool get isReversed => status == TransactionStatus.reversed;

  /// Formats the amount with ₦, thousands separator, and sign.
  String get formattedAmount {
    final formatter = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    );

    final prefix = isCredit ? '+' : '-';
    return '$prefix${formatter.format(amount.abs())}';
  }

  /// Returns the appropriate color depending on the status and amount.
  Color get amountColor {
    if (isFailed) return Colors.grey;
    if (isReversed) return Colors.blue;
    if (status == TransactionStatus.pending) return Colors.orange;
    return isCredit ? Colors.green : Colors.red;
  }

  /// Converts the enum status to a readable string.
  String get statusLabel {
    switch (status) {
      case TransactionStatus.success:
        return 'Successful';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.reversed:
        return 'Reversed';
      case TransactionStatus.pending:
        return 'Pending';
    }
  }

  /// Returns a formatted date string like "July 3rd, 9:15:48"
  String get formattedDateTime {
    final day = date.day;
    final daySuffix = _getDaySuffix(day);
    final month = DateFormat.MMMM().format(date); // July
    final time = DateFormat.Hms().format(date); // 9:15:48

    return '$month $day$daySuffix, $time';
  }

  /// Private method to get the day suffix
  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }

  String get formattedDateOnly {
    final day = DateFormat('d').format(date);
    final suffix = _getDaySuffix(int.parse(day));
    final month = DateFormat('MMMM').format(date);
    return '$month $day$suffix';
  }

  /// Example: "09:15 AM"
  String get formattedTimeOnly {
    return DateFormat('hh:mm a').format(date); // use 'HH:mm' for 24-hour format
  }
}
