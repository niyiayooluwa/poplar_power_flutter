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
      balance: 12345.67,
    );
  }

  static List<Transaction> getRecentTransactions() {
    return [
      Transaction(
        title: 'Starbucks',
        amount: -400.67,
        date: 'June 3rd, 9:15:48',
        status: 'Successful',
        icon: Icons.arrow_upward,
      ),
      Transaction(
        title: 'Transfer from Z-Merchant',
        amount: 35000.00,
        date: 'June 2nd, 13:30:18',
        status: 'Successful',
        icon: Icons.arrow_downward,
      ),
      Transaction(
        title: 'Temu',
        amount: -5000.00,
        date: 'June 1st, 12:18:55',
        status: 'Successful',
        icon: Icons.arrow_upward,
      ),
      Transaction(
        title: 'Temu',
        amount: -5000.00,
        date: 'June 1st, 12:15:32',
        icon: Icons.arrow_upward,
        status: 'Failed',
      ),
      Transaction(
        title: 'Electricity',
        amount: -1890.99,
        date: '2 days ago',
        status: 'Successful',
        icon: Icons.arrow_upward,
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