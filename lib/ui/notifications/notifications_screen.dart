import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/ui/notifications/widget/notification_item.dart';
import '../../data/mock/mock_service/app_providers.dart';

class NotificationScreen extends HookConsumerWidget{
 const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final notifications = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Notifications'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
              children: [
                Column(
                    children: [
                      ...notifications.map((notification) =>
                          NotificationItem(notification: notification),
                      )
                    ]
                )
              ]
          ),
        ),
      )
    );
  }
}