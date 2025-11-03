import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:poplar_power/ui/core/models/transaction.dart';

import '../../core/application/transaction_providers.dart';
import '../core/widgets/transaction_widget.dart';

class TransactionHistoryScreen extends HookConsumerWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Transaction History'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(transactionsProvider);
          },
          child: transactionsAsync.when(
            data: (transactions) {
              final uiTransactions =
                  transactions.map((t) => Transaction.fromDomainStatus(t)).toList()
                    ..sort((a, b) => b.date.compareTo(a.date));
              return _TransactionHistoryList(transactions: uiTransactions);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) =>
                const Center(child: Text("You haven't made any transactions yet.")),
          ),
        ),
      ),
    );
  }
}

class _TransactionHistoryList extends HookConsumerWidget {
  const _TransactionHistoryList({required this.transactions});

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final searchQuery = useState('');
    final searchController = useTextEditingController();

    if (transactions.isEmpty) {
      return const Center(
        child: Text("You haven't made any transactions yet."),
      );
    }

    final filtered = useMemoized(() {
      if (searchQuery.value.isEmpty) return transactions;

      return transactions
          .where((tx) =>
              tx.title.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }, [transactions, searchQuery.value]);

    final groupedTransactions = <String, List<Transaction>>{};
    for (final tx in filtered) {
      final monthYear = DateFormat.yMMMM().format(tx.date);
      groupedTransactions.putIfAbsent(monthYear, () => []).add(tx);
    }

    final List<Widget> sectionedList = [];
    groupedTransactions.forEach((month, txList) {
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

      sectionedList.addAll(
        txList.map(
          (transaction) => InkWell(
            onTap: () {
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
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
          Expanded(
            child: ListView(
              children: sectionedList,
            ),
          ),
        ],
      ),
    );
  }
}