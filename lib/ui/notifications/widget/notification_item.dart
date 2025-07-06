import 'package:flutter/material.dart';
import '../../../data/model/bank_notification.dart';

class NotificationItem extends StatelessWidget{
  final BankNotification notification;

  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
      ),

      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),

      decoration: BoxDecoration(
        //color: Colors.grey[200],
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0.5,
            blurRadius: 3,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                      notification.icon,
                      color: Colors.grey[600]
                  ),
                ),

                SizedBox(width: 16),

                Text(
                    notification.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 20
                    )
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          Text(
              notification.subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500
              )
          ),

          const SizedBox(height: 4),
          const Divider(),
          const SizedBox(height: 4),

          Text(
              notification.formattedDateTime,
              style: TextStyle(
                  fontSize: 12
              )
          ),
        ],
      ),
    );
  }
}