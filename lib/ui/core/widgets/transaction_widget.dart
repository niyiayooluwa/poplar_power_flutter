import 'package:flutter/material.dart';
import '../../../data/model/transaction_class.dart';


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
                    transaction.formattedDateTime,
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

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: transaction.amountColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  transaction.statusLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: transaction.amountColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}