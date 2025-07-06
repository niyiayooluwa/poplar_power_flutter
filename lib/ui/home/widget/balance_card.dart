// File: lib/widgets/balance_card.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/mock_service/app_providers.dart';

class BalanceCard extends HookConsumerWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(userProvider);
    final balanceVisible = ref.watch(balanceVisibilityProvider);
    final state = useState(_getGreeting());

    final isDarkTheme = theme.brightness == Brightness.dark;
    final iconColor = isDarkTheme ? Colors.white : Colors.black;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                state.value,
                style: Theme.of(context).textTheme.titleMedium,
            ),

            Row(
              children: [
                InkWell(
                  onTap: () {context.push('/notifications');},
                  child:const SizedBox(
                    width: 32,
                    height: 32,
                    child: Icon(
                      Icons.notifications,
                      size: 24,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.primaryColor,
                        width: 2,
                      )
                  ),
                  width: 32,
                  height: 32,
                  child: Icon(Icons.person, size: 24,),
                )
              ],
            )
          ],
        ),

        const SizedBox(height: 24),

        Text(
          'Total Balance',
          style: theme.textTheme.titleSmall,
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Text(
                balanceVisible ? user.formattedBalance : '••••••',
                style: TextStyle(
                    //color: Colors.white,
                    fontSize: 48
                ),
              ),
            ),
            SizedBox(width: 24),
            GestureDetector(
              onTap: () =>
              ref.read(balanceVisibilityProvider.notifier).state =
              !balanceVisible,
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

  String _getGreeting() {
    final random = Random();
    List emojiList = [
      '😉','👌','👍','✌️','🤞','😎','😁','🫰','🤙','👋','👍','🙌'
    ];
    int randomIndex = random.nextInt(emojiList.length);
    String randomChar = emojiList[randomIndex];
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning $randomChar';
    if (hour < 17) return 'Good Afternoon $randomChar';
    return 'Good Evening $randomChar';
  }
}