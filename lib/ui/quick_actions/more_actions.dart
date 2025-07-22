import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../home/widget/quick_actions.dart';

class MoreActions extends StatelessWidget {
  const MoreActions({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> quickActions = [
      {
        'icon': Icons.wifi,
        'label': 'Internet',
        'color': Colors.blue,
        'route': '/internet'
      },
      {
        'icon': Icons.call,
        'label': 'Airtime',
        'color': Colors.green,
        'route': '/airtime'
      },
      {
        'icon': Icons.power,
        'label': 'Electricity',
        'color': Colors.orange,
        'route': '/electricity'
      },
      {
        'icon': Icons.tv,
        'label': 'TV',
        'color': Colors.red,
        'route': '/cable'
      }
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Billers')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(quickActions.length, (index) {
                  final item = quickActions[index];
                  return QuickActionItem(
                    icon: item['icon'],
                    iconColor: item['color'],
                    label: item['label'],
                    onTap: () {
                      context.push('${item['route']}');
                    },
                  );
                }),
              )
            ],
          )
        ),
      ),
    );
  }
}
