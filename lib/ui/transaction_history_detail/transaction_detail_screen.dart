import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/model/transaction_class.dart';

// Provider for managing share state
final shareStateProvider = StateProvider<bool>((ref) => false);

class TransactionDetailScreen extends HookConsumerWidget {
  final Transaction transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShared = ref.watch(shareStateProvider);

    final color = switch (transaction.status) {
      TransactionStatus.success => switch (transaction.isCredit) {
        true => const Color(0xFFE7FAE6),
        false => const Color(0xFFFFB9BC),
      },
      TransactionStatus.failed => Colors.grey,
      TransactionStatus.reversed => Color(0xFF89D1FF),
      TransactionStatus.pending => Color(0xFFFBF4E8),
    };

    // Animation controller for the share button
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 200),
    );

    // Handle share button press
    void handleShare() {
      ref.read(shareStateProvider.notifier).state = true;
      animationController.forward();

      // Reset after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        ref.read(shareStateProvider.notifier).state = false;
        animationController.reverse();
      });
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              // Receipt Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Status Icon
                      _buildStatusIcon(),

                      const SizedBox(height: 24),

                      // Payment Status
                      _buildPaymentStatus(),

                      const SizedBox(height: 32),

                      // Transaction Details
                      _buildTransactionDetails(),

                      const SizedBox(height: 32),

                      // Share Button
                      _buildShareButton(isShared, handleShare, animationController),
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

  //Header
  Widget _buildHeader(context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHeaderButton(Icons.arrow_back, () => Navigator.of(context).pop()),
          _buildHeaderButton(Icons.download, () {}),
        ],
      ),
    );
  }

  //Header Button
  Widget _buildHeaderButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF374151)),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildStatusIcon() {
    return Stack(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: Color(0xFF1F2937), // gray-800
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                  transaction.icon,
                  color: Colors.white,
                  size: 40
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentStatus() {
    final method = switch (transaction.status) {
      TransactionStatus.success => switch (transaction.isCredit) {
        true => 'Received to Wallet',
        false => 'Paid via Wallet',
      },
      TransactionStatus.failed => 'Payment Failed',
      TransactionStatus.reversed => 'Payment Reversed',
      TransactionStatus.pending => 'Payment Pending',
    };
    return Column(
      children: [
        Text(
          method,
          style: TextStyle(
            color: Color(0xFF4C505C), // gray-600
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          transaction.formattedAmount,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827), // gray-900
          ),
        ),

        const SizedBox(height: 16),

        //This will be implemented based on the trajectory of the app
        /*Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7), // green-100
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shopping_cart,
                size: 16,
                color: Color(0xFF059669), // green-600
              ),
              SizedBox(width: 8),
              Text(
                'Groceries',
                style: TextStyle(
                  color: Color(0xFF047857), // green-700
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),*/
      ],
    );
  }

  Widget _buildTransactionDetails() {
    final color = switch (transaction.status) {
      TransactionStatus.success => Colors.green,
      TransactionStatus.failed => Colors.grey,
      TransactionStatus.reversed => Colors.blue,
      TransactionStatus.pending => Colors.orange,
    };
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow('Date', transaction.formattedDateOnly),
          _buildDetailRow('Time', transaction.formattedTimeOnly),
          _buildDetailRow('Transaction ID', 'BCX11100002'),
          _buildDetailRow('Status', transaction.statusLabel, color),
          const Divider(color: Color(0xFFF3F4F6)),
          _buildDetailRow('Fee', '₦0'),
          _buildDetailRow('Merchant', 'MarketSquare'),
          _buildDetailRow('Payment Method', 'Electronic Transfer'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      String label, String value, [Color color = const Color(0xFF111827)]
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B7280), // gray-600
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color, // gray-900
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton(bool isShared, VoidCallback onPressed, AnimationController controller) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isShared ? const Color(0xFF059669) : const Color(0xFF1F2937),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isShared ? Icons.check : Icons.share,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isShared ? 'Receipt Shared!' : 'Share Receipt',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}