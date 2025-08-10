import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.status,
    required this.icon,
  });

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
