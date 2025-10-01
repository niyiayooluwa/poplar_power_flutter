import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/application/transaction_providers.dart';
import '../../core/widgets/transaction_widget.dart';

class TransactionList extends ConsumerWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);

    return transactions.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("You haven't made any transactions yet."),
              ),
            );
          }
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
                      context.push('/transaction-history');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      child: Text(
                        'See More >',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  )
                ],
              ),

              ...data.take(5).map((transaction) =>
                  InkWell(
                    onTap: () {
                      // this is what happens when user taps the transaction
                      context.push('/transaction-detail', extra: transaction);
                    },
                    child: TransactionItem(transaction: transaction),
                  )
              )
            ],
          );
        },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text(err.toString())),
    );
  }
}