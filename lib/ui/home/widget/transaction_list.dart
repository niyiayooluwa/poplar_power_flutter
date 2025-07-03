import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../data/model/transaction_class.dart';
import '../../../data/mock_service/app_providers.dart';

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
              onTap: () {},
              child: Text(
                'See More >',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            )
          ],
        ),

        ...transactions.map((transaction)
        => TransactionItem(transaction: transaction)),
      ],
    );
  }
}

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ),

      decoration: BoxDecoration(
        //color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
                transaction.icon,
                color: Colors.grey[600]
            ),
          ),


          SizedBox(width: 16),


          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    transaction.title,
                    style: TextStyle(fontWeight: FontWeight.w600)
                ),

                Text(
                    transaction.date,
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12
                    )
                ),
              ],
            ),
          ),


          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.formattedAmount,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: transaction.amountColor
                ),
              ),

              Text(
                transaction.status,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: transaction.amountColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}