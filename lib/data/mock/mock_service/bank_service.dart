import 'package:flutter/material.dart';
import 'package:poplar_power/domain/entities/user.dart';
import 'package:poplar_power/ui/core/models/bank_notification.dart';
import 'package:poplar_power/ui/core/models/transaction.dart';

class BankService {
  // Fake data - Replace this with real API calls
  static User getCurrentUser() {
    return User(
      fullName: "John Doe",
      email: 'john.doe@email.com',
      phone: '123-456-7890',
      id: '2',
      verified: true,
      active: true,
    );
  }

  static List<Transaction> getRecentTransactions() {
    return [
      // Your existing transactions (kept for reference)
      Transaction(
        title: 'Starbucks',
        amount: -400.67,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        status: TransactionStatus.pending,
        icon: Icons.arrow_upward,
        transactionId: 'mock_id_1',
        merchant: 'Starbucks',
        paymentMethod: 'Wallet',
        fee: '₦0.00',
      ),
      Transaction(
        title: 'Transfer from Z-Merchant',
        amount: 35000.00,
        date: DateTime(2025, 7, 2, 13, 30, 18),
        status: TransactionStatus.success,
        icon: Icons.arrow_downward,
        transactionId: 'mock_id_2',
        merchant: 'Z-Merchant',
        paymentMethod: 'Bank Transfer',
        fee: '₦0.00',
      ),
      Transaction(
        title: 'Temu',
        amount: -5000.00,
        date: DateTime(2025, 7, 1, 12, 18, 55),
        status: TransactionStatus.success,
        icon: Icons.arrow_upward,
        transactionId: 'mock_id_3',
        merchant: 'Temu',
        paymentMethod: 'Wallet',
        fee: '₦0.00',
      ),
      Transaction(
        title: 'Temu',
        amount: -5000.00,
        date: DateTime(2025, 7, 1, 12, 15, 32),
        icon: Icons.cancel_outlined,
        status: TransactionStatus.failed,
        transactionId: 'mock_id_4',
        merchant: 'Temu',
        paymentMethod: 'Wallet',
        fee: '₦0.00',
      ),
      Transaction(
        title: 'Electricity',
        amount: -1890.99,
        date: DateTime(2025, 6, 30, 15, 55, 29),
        status: TransactionStatus.reversed,
        icon: Icons.subdirectory_arrow_left_sharp,
        transactionId: 'mock_id_5',
        merchant: 'EKEDC',
        paymentMethod: 'Wallet',
        fee: '₦0.00',
      ),
    ];
  }


  static List<BankNotification> getNotifications() {
    return [
      BankNotification(
        title: 'Login Successful',
        subtitle: 'You successfully logged in to your account from an iPhone device with iOS 16.5',
        icon: Icons.security,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        color: Colors.green,
      ),
      BankNotification(
        title: 'Card Payment',
        subtitle: 'Payment of \$45.67 processed at "Morning Brew Coffee Shop" using your Visa card ending in 7890',
        icon: Icons.credit_card,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        color: Colors.blue,
      ),
      BankNotification(
        title: 'Money Received',
        subtitle: 'Transfer of \$250.00 received from Jane Smith (Savings Account ••••4321) with memo: "Rent payment"',
        icon: Icons.arrow_downward,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        color: Colors.lightGreen,
      ),
      BankNotification(
        title: 'Bill Payment Due',
        subtitle: 'Reminder: Your billers bill of \$75.00 from City Power Co. is due tomorrow. Auto-pay is enabled',
        icon: Icons.receipt,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        color: Colors.orange,
      ),
      BankNotification(
        title: 'Password Change',
        subtitle: 'Your online banking password was successfully updated. If you did not make this change, contact support',
        icon: Icons.lock,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        color: Colors.purple,
      ),
      BankNotification(
        title: 'Large Withdrawal',
        subtitle: 'Withdrawal of \$5000.00 completed at ATM #NY-4521 (Broadway & 5th Ave). Available balance: \$12,340.50',
        icon: Icons.atm,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        color: Colors.redAccent,
      ),
      BankNotification(
        title: 'New Device Login',
        subtitle: 'New login detected from a Samsung Galaxy S23 (Android 14). Location: San Francisco, CA',
        icon: Icons.phonelink_setup,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        color: Colors.teal,
      ),
      BankNotification(
        title: 'Investment Update',
        subtitle: 'Your investment portfolio increased by 2.5% this week. Current value: \$58,720.00',
        icon: Icons.trending_up,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        color: Colors.indigo,
      ),
      BankNotification(
        title: 'Direct Debit Setup',
        subtitle: 'Recurring payment authorized for Netflix subscription (\$14.99/month). Next charge: July 15',
        icon: Icons.settings_applications,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        color: Colors.cyan,
      ),
      BankNotification(
        title: 'Low Balance Alert',
        subtitle: 'Your checking account balance is \$87.45, which is below the recommended minimum of \$100',
        icon: Icons.warning,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        color: Colors.amber,
      ),
      BankNotification(
        title: 'Statement Available',
        subtitle: 'Your June 2025 monthly statement is now available for download in PDF or CSV format',
        icon: Icons.article,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        color: Colors.blueGrey,
      ),
      BankNotification(
        title: 'Security Alert',
        subtitle: 'Unusual login attempt detected from an unrecognized device in Berlin, Germany. Account secured',
        icon: Icons.gpp_good,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        color: Colors.deepOrange,
      ),
      BankNotification(
        title: 'Transaction Failed',
        subtitle: 'Payment of \$129.99 to "Online Store" failed due to insufficient funds. Please check your balance',
        icon: Icons.error_outline,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        color: Colors.pink,
      ),
      BankNotification(
        title: 'Card Expiring Soon',
        subtitle: 'Your Visa debit card (••••5678) expires on August 31, 2025. A new card will be mailed automatically',
        icon: Icons.credit_card_off,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        color: Colors.brown,
      ),
      BankNotification(
        title: 'Loan Payment Reminder',
        subtitle: 'Upcoming auto-payment of \$385.20 for your personal loan (Account #PL-2024-7890) due July 10',
        icon: Icons.payment,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        color: Colors.lime,
      ),
      BankNotification(
        title: 'New Feature Available',
        subtitle: 'Explore our new Smart Budgeting tool with spending insights and customizable savings goals',
        icon: Icons.new_releases,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        color: Colors.lightBlue,
      ),
      BankNotification(
        title: 'Profile Update',
        subtitle: 'Your account profile was updated with a new phone number (555-987-6543) and email (user@example.com)',
        icon: Icons.person,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        color: Colors.greenAccent,
      ),
      BankNotification(
        title: 'App Update Available',
        subtitle: 'Version 4.2.0 of our mobile app is now available with enhanced security and faster transactions',
        icon: Icons.system_update_alt,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        color: Colors.deepPurple,
      ),
      BankNotification(
        title: 'Customer Survey',
        subtitle: 'We value your feedback! Take a 2-minute survey to help us improve your banking experience',
        icon: Icons.feedback,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        color: Colors.yellow,
      ),
      BankNotification(
        title: 'Account Verification',
        subtitle: 'Your identity verification is complete. All account features are now fully activated',
        icon: Icons.verified_user,
        date: DateTime(2025, 7, 3, 9, 15, 48),
        color: Colors.tealAccent,
      ),
    ];
  }
}