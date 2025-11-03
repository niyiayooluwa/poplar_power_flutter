import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/routing/navigator_key.dart';
import 'package:poplar_power/ui/core/models/transaction.dart';
import 'package:poplar_power/ui/core/viewmodels/transaction_flow_viewmodel.dart';
import 'package:poplar_power/ui/core/widgets/pin_input.dart';
import 'package:poplar_power/ui/core/widgets/transaction_confirmation.dart';

/// This widget orchestrates the transaction flow UI.
/// It listens to the [transactionFlowProvider] and displays the appropriate
/// UI (e.g., confirmation sheet, PIN entry, webview) based on the current state.
class TransactionFlowOrchestrator extends ConsumerWidget {
  final Widget child;

  const TransactionFlowOrchestrator({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
        ref.listen<TransactionFlowState>(transactionFlowProvider, (previous, next) {
      // We use ref.listen to trigger UI events (like showing a dialog)
      // without rebuilding the entire widget tree.

      // Prevent re-triggering for the same step.
      if (previous?.step == next.step) return;

      // Dismiss any open dialogs before showing a new one or navigating.
      final isShowingDialog = previous?.step == TransactionFlowStep.showingConfirmation ||
          previous?.step == TransactionFlowStep.awaitingPin;
      if (isShowingDialog) {
        Navigator.of(navigatorKey.currentContext!).pop();
      }

      switch (next.step) {
        case TransactionFlowStep.showingConfirmation:
          showModalBottomSheet(
            context: navigatorKey.currentContext!,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) => ConfirmTransactionSheet(
              title: next.title,
              fields: next.fields,
              amount: next.amount,
              onConfirm: () {
                ref.read(transactionFlowProvider.notifier).confirmTransaction();
              },
              onCancel: () {
                ref.read(transactionFlowProvider.notifier).cancelTransaction();
              },
            ),
          );
          break;

        case TransactionFlowStep.awaitingPin:
          PinEntryService.showPinEntryWithRetry(
            navigatorKey.currentContext!,
            title: 'Enter PIN',
            validator: (pin) {
              // Here, you could do real validation.
              // For now, we'll just pass it to the viewmodel.
              ref.read(transactionFlowProvider.notifier).submitPin(pin);
              return true; // Assume validation passes to close the sheet.
            },
          ).then((pin) {
            // If the user cancels the PIN entry
            if (pin == null) {
              ref.read(transactionFlowProvider.notifier).cancelTransaction();
            }
          });
          break;

        case TransactionFlowStep.processingWebPayment:
          if (next.webPaymentUrl != null) {
            GoRouter.of(navigatorKey.currentContext!).push('/webview', extra: {'url': next.webPaymentUrl});
          }
          break;

        case TransactionFlowStep.success:
          if (next.verifiedTransaction != null) {
            final uiTransaction = Transaction.fromDomainStatus(next.verifiedTransaction!);
            GoRouter.of(navigatorKey.currentContext!).push('/transaction-detail', extra: uiTransaction);
            ref.read(transactionFlowProvider.notifier).reset();
          }
          break;

        case TransactionFlowStep.error:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.errorMessage ?? 'An unknown error occurred.')),
          );
          ref.read(transactionFlowProvider.notifier).reset();
          break;

        case TransactionFlowStep.none:
        case TransactionFlowStep.processing:
          // Do nothing, these are intermediate states.
          break;
        case TransactionFlowStep.verifying:
          // Do nothing, the webview is showing its own loading indicator.
          break;
        case TransactionFlowStep.verificationSuccess:
          if (next.verifiedTransaction != null) {
            final uiTransaction = Transaction.fromDomainStatus(next.verifiedTransaction!);
            // Pop the webview
            Navigator.of(navigatorKey.currentContext!).pop();
            // Push the details screen
            GoRouter.of(navigatorKey.currentContext!).push('/transaction-detail', extra: uiTransaction);
            ref.read(transactionFlowProvider.notifier).reset();
          }
          break;
      }
    });

    // The orchestrator itself doesn't render any UI, it just presents other UI.
    // It returns the child widget that it wraps.
    return child;
  }
}
