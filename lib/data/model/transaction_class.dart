import 'package:flutter/material.dart';

class Transaction {
  final String title;
  final double amount;
  final String date;
  final IconData icon;

  Transaction({required this.title, required this.amount, required this.date, required this.icon});

  // Helper methods
  bool get isIncome => amount > 0;
  String get formattedAmount => '${isIncome ? '+' : ''}\$${amount.abs().toStringAsFixed(2)}';
  Color get amountColor => isIncome ? Colors.green : Colors.red;
}