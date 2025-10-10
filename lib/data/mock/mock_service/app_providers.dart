import 'package:hooks_riverpod/hooks_riverpod.dart' show StateProvider;
import 'package:poplar_power/domain/entities/user.dart';
import 'package:poplar_power/ui/core/models/bank_notification.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'bank_service.dart';

// UI state providers
final selectedTabProvider = StateProvider<int>((ref) => 0);
final balanceVisibilityProvider = StateProvider<bool>((ref) => true);

// Data providers using the service
final userProvider = Provider<User>((ref) {
  return BankService.getCurrentUser();
});


final notificationsProvider = Provider<List<BankNotification>>((ref) {
  return BankService.getNotifications();
});