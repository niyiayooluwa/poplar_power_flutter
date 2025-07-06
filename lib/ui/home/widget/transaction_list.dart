import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../data/mock_service/app_providers.dart';
import '../../core/widgets/transaction_widget.dart';

class TransactionList extends ConsumerWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                'Recent Transactions',
                style: Theme.of(context).textTheme.titleLarge
            ),

            InkWell(
              onTap: () {
                context.push('/transaction_history_detail-history');
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Text(
                  'See More >',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            )
          ],
        ),

        ...transactions.take(5).map((transaction) =>
            InkWell(
              onTap: () {
                // this is what happens when user taps the transaction
                context.push('/transaction_history_detail-details', extra: transaction);
              },
              child: TransactionItem(transaction: transaction),
            )
        )
      ],
    );
  }
}