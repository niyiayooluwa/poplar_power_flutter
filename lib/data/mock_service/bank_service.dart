import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../model/bank_notification.dart';
import '../model/transaction_class.dart';
import '../model/user_class.dart';

class BankService {
  // Fake data - Replace this with real API calls
  static User getCurrentUser() {
    return User(
      firstName: "John",
      lastName: "Doe",
      email: 'john.doe@email.com',
      balance: 33345.67,
    );
  }

  static List<Transaction> getRecentTransactions() {
    return [
      Transaction(
        title: 'Starbucks',
        amount: -400.67,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        status: TransactionStatus.pending,
        icon: Icons.arrow_upward,
      ),
      Transaction(
        title: 'Transfer from Z-Merchant',
        amount: 35000.00,
        date: DateTime(2025, 7, 2, 13, 30, 18),
        status: TransactionStatus.success,
        icon: Icons.arrow_downward,
      ),
      Transaction(
        title: 'Temu',
        amount: -5000.00,
        date: DateTime(2025, 7, 1, 12, 18, 55),
        status: TransactionStatus.success,
        icon: Icons.arrow_upward,
      ),
      Transaction(
        title: 'Temu',
        amount: -5000.00,
        date: DateTime(2025, 7, 1, 12, 15, 32),
        icon: Icons.cancel_outlined,
        status: TransactionStatus.failed,
      ),
      Transaction(
        title: 'Electricity',
        amount: -1890.99,
        date: DateTime(2025, 6, 30, 15, 55, 29),
        status: TransactionStatus.reversed,
        icon: Icons.subdirectory_arrow_left_sharp,
      ),
      Transaction(
        title: 'Electricity',
        amount: -1890.99,
        date: DateTime(2025, 6, 30, 15, 55, 29),
        status: TransactionStatus.reversed,
        icon: Icons.subdirectory_arrow_left_sharp,
      ),
    ];
  }

  static List<BankNotification> getNotifications() {
    return [
      BankNotification(
        title: 'Login Successful',
        subtitle: 'Logged in from iPhone - 2 min ago',
        icon: Icons.security,
        color: Colors.green,
      ),
      BankNotification(
        title: 'Card Payment',
        subtitle: '\$45.67 at Coffee Shop - 1 hour ago',
        icon: Icons.credit_card,
        color: Colors.blue,
      ),
    ];
  }
}