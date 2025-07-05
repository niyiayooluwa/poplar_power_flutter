import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/mock_service/app_providers.dart';
import '../core/widgets/transaction_widget.dart';

class TransactionHistoryScreen extends HookConsumerWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Transaction History'),
        centerTitle: true
      ),
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                    children: [
                      ...transactions.map((transaction) =>
                          InkWell(
                            onTap: () {
                              // this is what happens when user taps the transaction
                              context.push('/transaction_history_detail-details', extra: transaction);
                            },
                            child: TransactionItem(transaction: transaction),
                          )
                      )
                    ]
                ),
              )
          )
      ),
    );
  }
}