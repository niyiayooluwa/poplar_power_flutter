import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/core/application/user_provider.dart';

import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/models/transaction_status.dart';
import '../../domain/use_cases/transaction/get_transaction_history_use_case.dart';
import '../../domain/use_cases/transaction/get_transaction_status_use_case.dart';

final transactionsProvider = StateNotifierProvider.autoDispose<
    TransactionsNotifier, AsyncValue<List<TransactionStatus>>>((ref) {
  final getTransactionHistory =
      GetTransactionHistoryUseCase(ref.watch(transactionRepositoryProvider));
  final user = ref.watch(userProvider);
  return TransactionsNotifier(
      getTransactionHistory, user.user.value?.email ?? '');
});

class TransactionsNotifier
    extends StateNotifier<AsyncValue<List<TransactionStatus>>> {
  final GetTransactionHistoryUseCase _getTransactionHistory;
  final String _email;

  TransactionsNotifier(this._getTransactionHistory, this._email)
      : super(const AsyncLoading()) {
    if (_email.isNotEmpty) {
      getTransactions();
    }
  }

  Future<void> getTransactions() async {
    state = const AsyncLoading();
    final result = await _getTransactionHistory.execute(_email);
    if (!mounted) return;
    state = result.fold(
      ifLeft: (failure) => AsyncError(failure, StackTrace.current),
      ifRight: (data) => AsyncData(data),
    );
  }
}

final transactionStatusProvider =
    FutureProvider.family<TransactionStatus, String>((ref, nettpayRef) async {
  final getTransactionStatus = ref.watch(getTransactionStatusUseCaseProvider);
  final result = await getTransactionStatus.execute(nettpayRef);
  return result.fold(
    ifLeft: (failure) => throw failure,
    ifRight: (status) => status,
  );
});