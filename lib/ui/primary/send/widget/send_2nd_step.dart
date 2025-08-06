import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:poplar_power/data/model/transaction_class.dart';
import 'package:poplar_power/ui/core/widgets/pin_input.dart';
import 'package:poplar_power/ui/primary/send/viewmodel/send_provider.dart';

import '../../../../data/mock/mock_service/app_providers.dart';
import '../../../../data/services/confirm_transaction_service.dart';

class Send2ndStepScreen extends HookConsumerWidget {
  const Send2ndStepScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(sendViewModelProvider.notifier);
    final state = ref.watch(sendViewModelProvider);

    final amountString = state.amount;
    final recipientName =
        state.accountName ?? 'Recipient'; // Use actual fetched name
    final recipientBank = state.selectedBank?.name ?? 'Bank';
    final recipientAccountNumber = state.accountNUmber ?? 'Account';
    final currentBalance = ref
        .read(userProvider)
        .balance; // Mock current balance
    final isProcessing = useState(false);

    String formatCurrency(double value) {
      final formatter = NumberFormat.currency(
        locale: 'en_NG',
        symbol: '₦',
        decimalDigits: 0,
      );
      return formatter.format(value);
    }

    void showTransferConfirmation(BuildContext context) {
      TransactionSheetService.showConfirmation(
        context,
        title: 'Transfer Money',
        amount: '₦$amountString',
        description: 'Transfer to $recipientName',
        transactionConfig: TransactionSheetService.transferConfig,
        fields: TransactionSheetService.createTransferFields(
          recipientName: recipientName,
          accountNumber: recipientAccountNumber,
          bankName: recipientBank,
          fee: '0',
          total: amountString,
        ),
        onConfirm: () async {
          try {
            context.pop(); // Dismiss the bottom sheet
            await Future.delayed(const Duration(milliseconds: 500));

            // Show the bottom sheet and wait for the result (PIN)
            final pin = await PinEntryService.showPinEntryWithRetry(
              context,
              title: 'Authentication Required',
              validator: (pin) => pin == '1234', // Your validation logic
              maxAttempts: 3,
            );

            // If user completed PIN entry
            if (pin != null) {
              isProcessing.value = true;

              await Future.delayed(
                const Duration(seconds: 1),
              ); // Simulate API call

              isProcessing.value = false;

              if (context.mounted) {
                ref.invalidate(sendViewModelProvider);
                context.replace(
                  '/transaction-detail',
                  extra: Transaction(
                    title: 'Transfer to $recipientName',
                    amount: -int.tryParse(state.amount)!.toDouble(),
                    date: DateTime.timestamp(),
                    status: TransactionStatus.success,
                    icon: Icons.send,
                  ),
                );
              }
            }
          } catch (error) {
            isProcessing.value = false;
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Purchase failed: $error')),
              );
            }
          }
        },
      );
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
                    ),
                  ],
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
                                  onPressed: () =>
                                      viewModel.handleNumberPress(number),
                                ),
                              );
                            }),
                            SizedBox(
                              width: 100,
                              height: 55,
                              child: NumberButton(
                                text: '.',
                                onPressed: () =>
                                    viewModel.handleNumberPress('.'),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              height: 55,
                              child: NumberButton(
                                text: '0',
                                onPressed: () =>
                                    viewModel.handleNumberPress('0'),
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: amountString.length >= 3
                      ? () => showTransferConfirmation(context)
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    fixedSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isProcessing.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : amountString.length >= 3
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.send, color: Colors.white),
                            const SizedBox(width: 16),
                            Text(
                              'Transfer',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        )
                      : Text(
                          'Please enter a valid amount',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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