/// A [HookConsumerWidget] that represents the main home screen of the app.
/// 
/// Displays the user's balance, primary actions, quick actions, and a list of transactions.
/// Utilizes Riverpod for state management and Flutter Hooks for scroll control.
/// 
/// When the widget is first built, it invalidates the [transactionsProvider] to refresh transaction data.
/// 
/// Layout:
/// - [BalanceCard]: Shows the current balance.
/// - [PrimaryActions]: Displays main actionable buttons.
/// - [QuickActions]: Provides quick access actions.
/// - [TransactionList]: Shows a scrollable list of transactions.
/// 
/// All content is wrapped in a [SafeArea] and padded for consistent spacing.
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/ui/home/widget/primary_actions.dart';
import 'package:poplar_power/ui/home/widget/quick_actions.dart';
import 'package:poplar_power/ui/home/widget/transaction_list.dart';

import '../../core/application/transaction_providers.dart';
import '../../core/application/user_provider.dart';
import 'widget/balance_card.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    useEffect(() {
      Future.microtask(() => ref.invalidate(transactionsProvider));
      return null;
    }, const []);

    return Scaffold(
      extendBody: true,
      //backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BalanceCard(),
              const SizedBox(height: 16),
              const PrimaryActions(),
              const SizedBox(height: 12),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(transactionsProvider);
                    ref.invalidate(userProvider);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(height: 12),
                        QuickActions(),
                        SizedBox(height: 32),
                        TransactionList()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}