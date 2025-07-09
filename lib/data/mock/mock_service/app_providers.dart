import 'package:hooks_riverpod/hooks_riverpod.dart' show StateProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../model/bank_notification.dart';
import '../../model/transaction_class.dart';
import '../../model/user_class.dart';
import 'bank_service.dart';

// UI state providers
final selectedTabProvider = StateProvider<int>((ref) => 0);
final balanceVisibilityProvider = StateProvider<bool>((ref) => true);

// Data providers using the service
final userProvider = Provider<User>((ref) {
  return BankService.getCurrentUser();
});

final transactionsProvider = Provider<List<Transaction>>((ref) {
  return BankService.getRecentTransactions();
});

final notificationsProvider = Provider<List<BankNotification>>((ref) {
  return BankService.getNotifications();
});