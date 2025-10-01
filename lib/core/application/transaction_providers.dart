import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/core/application/user_provider.dart';
import 'package:poplar_power/domain/use_cases/transaction/get_transaction_history_use_case.dart';
import 'package:poplar_power/ui/core/models/transaction.dart';

final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final userAsyncValue = ref.watch(userProvider);
  final getTransactionHistory = ref.watch(getTransactionHistoryUseCaseProvider);

  return userAsyncValue.when(
    data: (user) async {
      // If there is no user, there are no transactions.
      if (user == null) {
        return [];
      }

      final result = await getTransactionHistory.execute(user.email);

      return result.fold(
        ifLeft: (failure) => throw failure,
        ifRight: (transactionStatusList) => transactionStatusList
            .map((status) => Transaction.fromStatus(status))
            .toList(),
      );
    },
    loading: () => [], // Return empty list while user is loading
    error: (err, stack) => throw err, // Propagate user error
  );
});
