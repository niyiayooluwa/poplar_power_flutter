import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/core/application/user_provider.dart';

final balanceVisibilityProvider = StateProvider<bool>((ref) => true);

/// A widget that displays the user's balance, greeting, and profile access.
class BalanceCard extends HookConsumerWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Watch user data from Riverpod provider
    final userState = ref.watch(userProvider);
    // State for greeting text with emoji
    final greeting = useState(_getGreeting());
    // State for balance visibility toggle
    final balanceVisible = ref.watch(balanceVisibilityProvider);

    // Determine icon color based on theme brightness
    final isDarkTheme = theme.brightness == Brightness.dark;
    final iconColor = isDarkTheme ? Colors.white : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: greeting and profile icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Greeting text
            Text(greeting.value, style: Theme.of(context).textTheme.titleMedium),

            Row(
              children: [
                /*
                // Uncomment to enable notifications icon
                InkWell(
                  onTap: () {
                    context.push('/notifications');
                  },
                  child: const SizedBox(
                    width: 32,
                    height: 32,
                    child: Icon(Icons.notifications, size: 24),
                  ),
                ),
                const SizedBox(width: 8),
                */

                // Profile icon with border
                InkWell(
                  onTap: () {
                    context.push('/profile');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.primaryColor, width: 2),
                    ),
                    width: 32,
                    height: 32,
                    child: Icon(Icons.person, size: 24),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Label for balance
        Text('Total Balance', style: theme.textTheme.titleSmall),

        // Row for balance value and visibility toggle
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Animated balance value (visible/hidden)
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: userState.balance.when(
                data: (balance) => Text(
                  balanceVisible ? '₦${balance.toStringAsFixed(2)}' : '••••••',
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                loading: () => const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (err, stack) => Text(
                  balanceVisible ? '₦0.00' : '••••••',
                  style: TextStyle(
                    fontSize: 40,
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ),
            SizedBox(width: 24),
            // Eye icon to toggle balance visibility
            GestureDetector(
              onTap: () => ref.read(balanceVisibilityProvider.notifier).state = !balanceVisible,
              child: Icon(
                balanceVisible ? Icons.visibility : Icons.visibility_off,
                color: iconColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Returns a greeting string with a random emoji based on the current time of day.
  String _getGreeting() {
    final random = Random();
    List emojiList = [
      '😉',
      '👌',
      '👍',
      '✌️',
      '🤞',
      '😎',
      '😁',
      '🫰',
      '🤙',
      '👋',
      '👍',
      '🙌',
    ];
    int randomIndex = random.nextInt(emojiList.length);
    String randomChar = emojiList[randomIndex];
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning $randomChar';
    if (hour < 17) return 'Good Afternoon $randomChar';
    return 'Good Evening $randomChar';
  }
}
