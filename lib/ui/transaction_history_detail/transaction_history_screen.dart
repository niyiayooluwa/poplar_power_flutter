import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/mock/mock_service/app_providers.dart';
import '../../data/model/transaction_class.dart';
import '../core/widgets/transaction_widget.dart';

import 'package:intl/intl.dart';

class TransactionHistoryScreen extends HookConsumerWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Get all transactions from the state management provider
    final transactions = ref.watch(transactionsProvider);

    // Track user's search input with reactive state
    final searchQuery = useState('');
    final searchController = useTextEditingController();

    // Filter transactions based on search query
    // Rebuilds automatically when transactions or search query changes
    final filtered = useMemoized(() {
      if (searchQuery.value.isEmpty) return transactions;

      return transactions.where((tx) =>
          tx.title.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }, [transactions, searchQuery.value]);

    // Group transactions by month and year (e.g., "July 2025")
    final groupedTransactions = <String, List<Transaction>>{};
    for (final tx in filtered) {
      final monthYear = DateFormat.yMMMM().format(tx.date);
      groupedTransactions.putIfAbsent(monthYear, () => []).add(tx);
    }

    // Build the sectioned list with month headers and transaction items
    final List<Widget> sectionedList = [];
    groupedTransactions.forEach((month, txList) {
      // Add month header
      sectionedList.add(
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 8),
          child: Text(
            month,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

      // Add all transactions for this month
      sectionedList.addAll(
        txList.map(
              (transaction) => InkWell(
            onTap: () {
              // Navigate to transaction detail screen
              context.push(
                '/transaction-detail',
                extra: transaction,
              );
            },
            child: TransactionItem(transaction: transaction),
          ),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Transaction History'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Search bar for filtering transactions
              TextField(
                controller: searchController,
                onChanged: (value) => searchQuery.value = value,
                decoration: InputDecoration(
                  hintText: 'Search transactions...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),

              const SizedBox(height: 16),

              // Scrollable list of grouped transactions
              Expanded(
                child: ListView(
                  children: sectionedList,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}