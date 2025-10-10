/// A widget that displays a set of quick action buttons for common tasks such as
/// purchasing airtime/data, paying electricity bills, subscribing to TV services,
/// and accessing more actions. Each action is represented by an icon, label, and color,
/// and navigates to a specific route when tapped.
///
/// This widget is intended to be used on the home screen to provide users with
/// fast access to frequently used features.
///
/// Uses [HookConsumerWidget] for Riverpod state management and navigation via [GoRouter].
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Displays a row of quick action buttons for common tasks on the home screen.
/// 
/// Each button navigates to a specific route when tapped. Uses [HookConsumerWidget]
/// for Riverpod state management and [GoRouter] for navigation.
class QuickActions extends HookConsumerWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // List of quick actions with icon, label, color, and route.
    final List<Map<String, dynamic>> quickActions = [
      {
        'icon': Icons.wifi,
        'label': 'Airtime/Data',
        'color': Colors.blue,
        'route': '/internet'
      },
      /*{
        'icon': Icons.call,
        'label': 'Airtime',
        'color': Colors.green,
        'route': '/airtime'
      },*/
      {
        'icon': Icons.power,
        'label': 'Electricity',
        'color': Colors.orange,
        'route': '/billers'
      },
      {
        'icon': Icons.tv,
        'label': 'TV',
        'color': Colors.red,
        'route': '/cable'
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
        // Section title
        Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge
        ),

        const SizedBox(height: 16),

        // Row of quick action items
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(quickActions.length, (index) {
            final item = quickActions[index];
            return QuickActionItem(
              icon: item['icon'],
              iconColor: item['color'],
              label: item['label'],
              onTap: () {
                // Navigate to the corresponding route when tapped
                context.push('${item['route']}');
              },
            );
          }),
        )
      ],
    );

  }
}

/// A widget that displays a quick action item with an icon and label.
/// 
/// [QuickActionItem] is typically used in a row or grid of quick actions.
/// It shows a circular icon with a customizable background color and a label below.
/// 
/// - [icon]: The icon to display.
/// - [iconColor]: The color of the icon and its background (with reduced opacity).
/// - [label]: The text label shown below the icon.
/// - [onTap]: The callback triggered when the item is tapped.
/// A widget that displays a single quick action item with an icon and label.
/// 
/// Used within a row or grid of quick actions. Shows a circular icon with a colored background
/// and a label below. Tapping the item triggers the [onTap] callback.
class QuickActionItem extends StatelessWidget {
  /// The icon to display for the quick action.
  final IconData icon;

  /// The color of the icon and its circular background.
  final Color iconColor;

  /// The label text shown below the icon.
  final String label;

  /// The callback triggered when the item is tapped.
  final VoidCallback onTap;

  /// Creates a [QuickActionItem].
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
      // Handles tap events and provides ripple effect.
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 72, // Fixed width to maintain spacing between items.
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular icon with colored background.
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // Use iconColor with reduced opacity for background.
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 8),
            // Label text below the icon.
            Text(
              label,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis, // Prevents overflow for long labels.
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