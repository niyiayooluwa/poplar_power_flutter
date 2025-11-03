import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Required for useEffect
import 'package:poplar_power/ui/core/models/transaction.dart';

import '../../../core/application/transaction_providers.dart';
import '../../core/widgets/transaction_widget.dart';

/// A widget that displays a list of recent transactions.
///
/// If there are no transactions, it shows an empty state message.
/// Provides navigation to transaction history and transaction detail screens.
class TransactionList extends HookConsumerWidget {
  /// Creates a [TransactionList] widget.
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Side-effect: Invalidate the transactionsProvider when the widget first builds.
    // This ensures the transaction list is refreshed every time this widget is shown.
    useEffect(() {
      Future.microtask(() => ref.invalidate(transactionsProvider));
      return null;
    }, []);

    // Watches the transactionsProvider for transaction data.
    final transactions = ref.watch(transactionsProvider);

    /// Builds the header row with title and "See More" navigation.
    Widget buildHeader() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Transactions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          InkWell(
            // Navigates to the transaction history screen when tapped.
            onTap: () {
              context.push('/transaction-history');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text(
                'See More >',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      );
    }

    /// Builds the empty state UI when there are no transactions.
    Widget buildEmptyState() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("You haven't made any transactions yet."),
            ),
          ),
        ],
      );
    }

    // Handles the different states of the transactionsProvider (data, loading, error).
    return transactions.when(
      data: (data) {
        // Maps the raw transaction data to UI models.
        final uiTransactions = data.map((t) => Transaction.fromDomainStatus(t)).toList()
          ..sort((a, b) => b.date.compareTo(a.date));

        // If there are no transactions, show the empty state.
        if (uiTransactions.isEmpty) {
          return buildEmptyState();
        }

        // Shows up to 5 recent transactions with navigation to detail screens.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(),
            ...uiTransactions.take(5).map(
              (transaction) => InkWell(
                // Navigates to the transaction detail screen when tapped.
                onTap: () {
                  context.push('/transaction-detail', extra: transaction);
                },
                child: TransactionItem(transaction: transaction),
              ),
            ),
          ],
        );
      },
      // Shows a loading indicator while transactions are being fetched.
      loading: () => const Center(child: CircularProgressIndicator()),
      // Shows the empty state if there is an error fetching transactions.
      error: (err, stack) => buildEmptyState(),
    );
  }
}
