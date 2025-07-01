import 'package:flutter/material.dart';
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
      balance: 12345.67,
    );
  }

  static List<Transaction> getRecentTransactions() {
    return [
      Transaction(
        title: 'Starbucks',
        amount: -5.67,
        date: 'Today',
        icon: Icons.local_cafe,
      ),
      Transaction(
        title: 'Salary Deposit',
        amount: 3500.00,
        date: 'Yesterday',
        icon: Icons.work,
      ),
      Transaction(
        title: 'Amazon',
        amount: -89.99,
        date: '2 days ago',
        icon: Icons.shopping_cart,
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