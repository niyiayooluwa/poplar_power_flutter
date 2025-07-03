import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Transaction {
  final String title;
  final double amount;
  final String date;
  final String status;
  final IconData icon;

  Transaction({
    required this.title, required this.amount,
    required this.date, required this.icon,
    required this.status
  });

  // Helper methods
  bool get isIncome => amount > 0;

  String get formattedAmount {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '₦',
      decimalDigits: 2
    );

    String formattedNumber = currencyFormatter.format(amount.abs());

    final numberPartFormatter = NumberFormat("#,##0.00", "en_US");

    String formattedValue = numberPartFormatter.format(amount.abs());

    return '${isIncome ? '+' : '-'}\u20A6$formattedValue';
  }

  bool get isFailed => status == 'Failed';

  Color get amountColor {
    if (isFailed) {
      return Colors.grey;
  } else {
      return isIncome ? Colors.green : Colors.red;
  }
  }
}