import 'dart:ui';

/// Represents a field in the transaction details
class TransactionField {
  final String label;
  final String value;
  final bool isHighlighted;
  final Color? valueColor;
  final TextStyle? valueStyle;

  const TransactionField({
    required this.label,
    required this.value,
    this.isHighlighted = false,
    this.valueColor,
    this.valueStyle,
  });
}
