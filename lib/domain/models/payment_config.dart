import 'package:flutter/material.dart';

/// Configuration for payment method display
class PaymentMethodConfig {
  final String name;
  final String balance;
  final IconData icon;
  final Color color;

  const PaymentMethodConfig({
    required this.name,
    required this.balance,
    required this.icon,
    this.color = Colors.blue,
  });
}