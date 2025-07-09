import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/ui/home/widget/primary_actions.dart';
import 'package:poplar_power/ui/home/widget/quick_actions.dart';
import 'package:poplar_power/ui/home/widget/transaction_list.dart';

import 'widget/balance_card.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

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
                child: SingleChildScrollView(
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
            ],
          ),
        ),
      ),
    );
  }
}