import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:poplar_power/ui/send/viewmodel/send_provider.dart';

import '../../../data/mock/mock_service/app_providers.dart';

class Send2ndStepScreen extends HookConsumerWidget {
  const Send2ndStepScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(sendViewModelProvider.notifier);
    final state = ref.watch(sendViewModelProvider);

    final amountString = state.amount ?? '0';
    final recipientName =
        state.accountName ?? 'Recipient'; // Use actual fetched name
    final recipientBank = state.selectedBank?.name ?? 'Bank';
    final recipientAccountNumber = state.accountNUmber ?? 'Account';
    final currentBalance = ref.read(userProvider).balance; // Mock current balance

    String formatCurrency(double value) {
      final formatter = NumberFormat.currency(
        locale: 'en_NG',
        symbol: '₦',
        decimalDigits: 0,
      );
      return formatter.format(value);
    }

    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('Send')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Recipient Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFFAFAFA),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    )
                  ]
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue.shade500,
                      child: Text(
                        recipientName.isNotEmpty
                            ? recipientName[0].toUpperCase()
                            : '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipientName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            recipientBank,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Change'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Amount Section
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Text(
                        formatCurrency(double.tryParse(amountString) ?? 0),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w300,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Current Balance ${formatCurrency(currentBalance)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Quick Amount Buttons
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        // Added runSpacing for vertical spacing between rows
                        children: state.quickAmounts.map((quickAmount) {
                          return OutlinedButton(
                            onPressed: () =>
                                viewModel.setQuickAmount(quickAmount),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFFF3F4F6),
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ), // Added consistent padding
                            ),
                            child: Text(
                              '₦${NumberFormat('#,###').format(quickAmount)}',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 40),

                      // Number Pad
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 24,
                          alignment: WrapAlignment.center,
                          children: [
                            ...List.generate(9, (index) {
                              final number = (index + 1).toString();
                              return SizedBox(
                                width: 100,
                                height: 55,
                                child: NumberButton(
                                  text: number,
                                  onPressed: () => viewModel.handleNumberPress(number),
                                ),
                              );
                            }),
                            SizedBox(
                              width: 100,
                              height: 55,
                              child: NumberButton(
                                text: '.',
                                onPressed: () => viewModel.handleNumberPress('.'),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              height: 55,
                              child: NumberButton(
                                text: '0',
                                onPressed: () => viewModel.handleNumberPress('0'),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              height: 55,
                              child: NumberButton(
                                icon: Icons.backspace_outlined,
                                onPressed: viewModel.handleBackspace,
                              ),
                            ),
                          ],
                        )

                      )
                    ],
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: amountString != '0'
                      ? () {
                    // Handle transfer
                  }
                      : null,
                style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                fixedSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

// Number Button Widget (Local to this file for now)
class NumberButton extends HookWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;

  const NumberButton({
    super.key,
    this.text,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: icon != null
                  ? Icon(icon, size: 24, color: Colors.black54)
                  : Text(
                text!,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
