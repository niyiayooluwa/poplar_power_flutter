import 'package:flutter/material.dart';
import 'package:poplar_power/domain/models/payment_provider.dart';

/// Configuration for payment method display
class PaymentMethodConfig {
  final String name;
  final String balance;
  final IconData icon;
  final Color color;
  final PaymentProvider provider;

  const PaymentMethodConfig({
    required this.name,
    required this.balance,
    required this.icon,
    this.color = Colors.blue,
    required this.provider,
  });
}