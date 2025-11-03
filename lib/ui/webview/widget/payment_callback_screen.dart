import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/ui/core/viewmodels/transaction_flow_viewmodel.dart';

class PaymentCallbackScreen extends HookConsumerWidget {
  final String? trxref;
  final String? reference;

  const PaymentCallbackScreen({super.key, this.trxref, this.reference});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionFlowNotifier = ref.read(transactionFlowProvider.notifier);

    useEffect(() {
      // Use a post-frame callback to ensure the view is built before we act.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (trxref != null || reference != null) {
          // We have a reference, so the payment was likely successful.
          // We can now trigger the verification.
          transactionFlowNotifier.completeWebPayment();
          // We do NOT navigate away here. We let the orchestrator handle it.
        } else {
          // The callback was missing the transaction reference.
          // This is an error condition.
          transactionFlowNotifier.setError('Payment callback failed: Missing transaction reference.');
          // If there's an error, we should navigate away.
          GoRouter.of(context).go('/home');
        }
      });
      return null; // No cleanup needed
    }, [trxref, reference]);

    // Show a simple loading indicator while we process the callback.
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Finalizing payment...'),
          ],
        ),
      ),
    );
  }
}
