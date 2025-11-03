/// A widget that displays the primary action buttons on the home screen.
/// 
/// This widget arranges two pill-shaped action buttons ("Send" and "Top Up")
/// horizontally with equal width, separated by a small gap. Each button navigates
/// to a different route when tapped.
/// 
/// Uses [LayoutBuilder] to calculate button width responsively based on the
/// available space. The widget is designed to be used with Riverpod for state
/// management.
/// 
/// The "Scan" button is currently commented out, but can be enabled if needed.
/// 
/// - "Send": Navigates to the '/send' route.
/// - "Top Up": Navigates to the '/topup' route.
/// 
/// Requires [PillActionItem] widget for rendering individual action buttons.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PrimaryActions extends HookConsumerWidget {
  const PrimaryActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonWidth = (constraints.maxWidth - 16) / 2;

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: buttonWidth,
                child: PillActionItem(
                  icon: Icons.send,
                  label: 'Send',
                  onTap: () {context.push('/send');},
                ),
              ),

              /*SizedBox(
                width: buttonWidth,
                child: PillActionItem(
                  icon: Icons.qr_code,
                  label: 'Scan',
                  onTap: () => context.push('/scan'),
                ),
              ),*/

              SizedBox(
                width: buttonWidth,
                child: PillActionItem(
                  icon: Icons.account_balance_wallet,
                  label: 'Top Up',
                  onTap: () => context.push('/topup'),
                ),
              ),
            ]
        );
      }
    );
  }
}

/// A widget that displays a pill-shaped action item with an icon and label.
/// 
/// [PillActionItem] is a stateless widget that shows an icon and a text label
/// inside a rounded container. It responds to tap events via the [onTap] callback.
/// 
/// - [icon]: The icon to display.
/// - [label]: The text label to display next to the icon.
/// - [onTap]: The callback function to execute when the item is tapped.
class PillActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const PillActionItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(24), // pill shape
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
                icon, size: 20,
                color: Colors.black45
            ),

            const SizedBox(width: 12),

            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}