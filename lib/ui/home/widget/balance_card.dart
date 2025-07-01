// File: lib/widgets/balance_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/mock_service/app_providers.dart';

class BalanceCard extends HookConsumerWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final balanceVisible = ref.watch(balanceVisibilityProvider);
    final isScrolled = useState(false);

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[900]!, Colors.blue[700]!],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isScrolled.value
            ? [BoxShadow(color: Colors.blue.withOpacity(0.3))]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getGreeting(),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            "${user.firstName} ${user.lastName}",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),

          SizedBox(height: 20),

          Text('Total Balance', style: TextStyle(color: Colors.white70)),

          Row(
            children: [
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: Text(
                  balanceVisible ? user.formattedBalance : '••••••',
                  style: TextStyle(color: Colors.white, fontSize: 32),
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () =>
                    ref.read(balanceVisibilityProvider.notifier).state =
                        !balanceVisible,
                child: Icon(
                  balanceVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }
}
