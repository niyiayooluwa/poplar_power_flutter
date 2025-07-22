// File: lib/widgets/balance_card.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuickActions extends HookConsumerWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final theme = Theme.of(context);
    //final isDarkTheme = theme.brightness == Brightness.dark;
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
        'icon': Icons.more_horiz,
        'label': 'More',
        'color': Colors.grey,
        'route': '/more-actions'
      }
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge
        ),

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
    );

  }
}

class QuickActionItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const QuickActionItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 72, // Fixed width to maintain spacing
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis, // 👈 Prevents overflow
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

