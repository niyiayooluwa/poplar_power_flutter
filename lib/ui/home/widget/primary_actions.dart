// File: lib/widgets/balance_card.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PrimaryActions extends HookConsumerWidget {
  const PrimaryActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;
    final iconColor = isDarkTheme ? Colors.white : Colors.black;

    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonWidth = (constraints.maxWidth - 32) / 3;

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

              SizedBox(
                width: buttonWidth,
                child: PillActionItem(
                  icon: Icons.qr_code,
                  label: 'Scan',
                  onTap: () => context.push('/scan'),
                ),
              ),

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
      onTap: onTap,
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