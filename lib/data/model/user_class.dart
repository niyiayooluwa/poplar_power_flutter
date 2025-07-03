import 'package:intl/intl.dart';

class User {
  final String firstName;
  final String lastName;
  final String email;
  final double balance;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.balance
  });

  // Helper methods (business logic)
  String get formattedBalance {
    final currencyFormatter = NumberFormat.currency(
        locale: 'en_US',
        symbol: '₦',
        decimalDigits: 2
    );

    String formattedNumber = currencyFormatter.format(balance.abs());

    final numberPartFormatter = NumberFormat("#,##0.00", "en_US");

    String formattedValue = numberPartFormatter.format(balance.abs());

    return '\u20A6$formattedValue';
  }
  bool get hasPositiveBalance => balance > 0;
}