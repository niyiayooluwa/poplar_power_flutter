import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/model/transaction_class.dart';
import 'package:poplar_power/ui/core/widgets/loading_overlay.dart';
import 'package:poplar_power/ui/core/widgets/pin_input.dart';
import '../viewmodel/buy_data_provider.dart';

/// A screen widget that allows users to confirm the details of their data bundle purchase.
///
/// This screen displays the selected ISP, phone number, bundle name, and bundle price.
/// It provides a button to confirm the purchase, which then prompts the user
/// to enter their PIN for authorization.
class ConfirmDetailsScreen extends HookConsumerWidget {
  const ConfirmDetailsScreen({super.key});

  @override
  /// Builds the UI for the confirmation screen.
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the view model and state
    final viewModel = ref.read(buyDataViewModelProvider.notifier);
    final state = ref.watch(buyDataViewModelProvider);

    // Get the currently selected ISP and bundle, and the available bundles for the selected ISP
    final selectedISP = state.selectedISP;
    final selectedBundle = state.selectedBundle;
    final price = selectedBundle?.price.toDouble() ?? 0;

    // Get the current theme for styling.
    final theme = Theme.of(context);

    // State variable to manage the visibility of the bottom sheet for PIN entry.
    final isProcessing = useState(false);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: BackButton(),
            centerTitle: true,
            title: const Text('Confirm Details'),
          ),
          body: SafeArea(
            // Apply padding to the content.
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Vertical spacing.
                    const SizedBox(height: 24),

                    // Label indicating the recipient.
                    Text('To', style: theme.textTheme.bodyLarge),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // Center the ISP name and phone number.
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          selectedISP?.name ?? 'N/A',
                          style: theme.textTheme.bodyLarge,
                        ),

                        // Horizontal spacing between ISP name and phone number.
                        const SizedBox(width: 32),

                        // Display the phone number, or 'N/A' if not available.
                        Text(
                          state.phoneNumber ?? 'N/A',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // Display the selected bundle name, or 'N/A' if not available.
                    Text(
                      'Bundle: ${selectedBundle?.name ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      // Display the selected bundle price, or 'N/A' if not available.
                      'Price: ${selectedBundle?.price ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Vertical spacing.
                    const SizedBox(height: 16),

                    // Button to confirm the purchase.
                    ElevatedButton(
                      onPressed: () async {
                        // Show the bottom sheet and wait for the result (PIN)
                        final pin = await showModalBottomSheet<String>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => FractionallySizedBox(
                            heightFactor: 0.5,
                            child: PinEntrySheet(
                              onCompleted: (pin) {
                                Navigator.of(context).pop(pin); // Dismiss sheet with PIN
                              },
                            ),
                          ),
                        );

                        // If user completed PIN entry
                        if (pin != null) {
                          isProcessing.value = true;

                          await Future.delayed(Duration(seconds: 1)); // Simulate API call

                          isProcessing.value = false; // Optional slight delay
                          context.replace(
                            '/transaction-detail',
                            extra: Transaction(
                              title: 'Data Purchase',
                              amount: -price,
                              date: DateTime.timestamp(),
                              status: TransactionStatus.success,
                              icon: Icons.wifi,
                            ),
                          );
                        }
                      },
                      child: const Text('Confirm Purchase'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),

        LoadingOverlay(
            isVisible: isProcessing.value
        )
      ],
    );
  }
}
