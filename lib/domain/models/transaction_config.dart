import 'package:flutter/material.dart';

/// Configuration for the transaction type
class TransactionConfig {
  final String type;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const TransactionConfig({
    required this.type,
    required this.icon,
    required this.color,
    this.subtitle,
  });
}