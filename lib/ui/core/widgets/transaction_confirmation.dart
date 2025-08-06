import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/mock/mock_service/app_providers.dart';
import 'package:poplar_power/domain/models/payment_config.dart';
import 'package:poplar_power/domain/models/transaction_config.dart';
import 'package:poplar_power/domain/models/transaction_field.dart';

class ConfirmTransactionSheet extends HookConsumerWidget {
  final String title;
  final List<TransactionField> fields;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final TransactionConfig? transactionConfig;
  final String? amount;
  final String? description;
  final String? referenceNumber;
  final String? processingTime;
  final bool showSecurityBadge;
  final String confirmButtonText;
  final String cancelButtonText;
  final bool isLoading;

  const ConfirmTransactionSheet({
    super.key,
    required this.title,
    required this.fields,
    required this.onConfirm,
    this.onCancel,
    this.transactionConfig,
    this.amount,
    this.description,
    this.referenceNumber,
    this.processingTime,
    this.showSecurityBadge = true,
    this.confirmButtonText = "Confirm Payment",
    this.cancelButtonText = "Cancel",
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    final walletConfig = PaymentMethodConfig(
      name: 'Main Wallet',
      balance: user.formattedBalance,
      icon: Icons.account_balance_wallet,
      color: Colors.blue,
    );

    final cardConfig = const PaymentMethodConfig(
      name: 'Card',
      balance: '**** **** **** 1234',
      icon: Icons.credit_card,
      color: Colors.red,
    );

    final webPayConfig = const PaymentMethodConfig(
      name: 'Web Pay',
      balance: 'Pay with a web browser',
      icon: Icons.language,
      color: Colors.green,
    );

    final paymentMethods = [walletConfig, cardConfig, webPayConfig];

    final selectedPaymentMethod = useState(walletConfig);

    void showPaymentMethodSelector(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDragHandle(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: paymentMethods.map((method) {
                    return ListTile(
                      leading: Icon(method.icon, color: method.color),
                      title: Text(method.name),
                      subtitle: Text(method.balance),
                      onTap: () {
                        selectedPaymentMethod.value = method;
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                )
              ],
            )
          );
        },
      );
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      constraints: BoxConstraints(
        //maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          _buildHeader(context),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        if (amount != null) _buildAmountSection(context),
                        _buildTransactionDetails(context),
                        if (referenceNumber != null) _buildReferenceNumber(context),
                        GestureDetector(
                          onTap: () => showPaymentMethodSelector(context),
                          child: _buildPaymentMethod(context, selectedPaymentMethod.value),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildActionButtons(context),
          if (processingTime != null) _buildProcessingTime(context),
          const SizedBox(height: 36),
        ],
      )
    );
  }

  Widget _buildDragHandle() {
    return Container(
      height: 4,
      width: 40,
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        children: [
          if (transactionConfig != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: transactionConfig!.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                transactionConfig!.icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onCancel ?? () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[100],
              foregroundColor: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            amount!,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTransactionDetails(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: fields
            .map((field) => _buildDetailRow(context, field))
            .toList(),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, TransactionField field) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            field.label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          Flexible(
            child: Text(
              field.value,
              style: (field.valueStyle is TextStyle)
                  ? field.valueStyle as TextStyle
                  : theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: field.isHighlighted
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: field.valueColor ?? Colors.grey[900],
                      fontSize: field.isHighlighted ? 16 : 14,
                    ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(BuildContext context, PaymentMethodConfig selectedPaymentMethod) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selectedPaymentMethod.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selectedPaymentMethod.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              selectedPaymentMethod.icon,
              color: selectedPaymentMethod.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedPaymentMethod.name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Balance: ${selectedPaymentMethod.balance}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceNumber(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Text(
            'Reference Number',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
          ),
          const SizedBox(height: 4),
          Text(
            referenceNumber!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isLoading ? null : onConfirm,
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.arrow_forward),
              label: Text(confirmButtonText),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: isLoading
                  ? null
                  : (onCancel ?? () => Navigator.of(context).pop()),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(cancelButtonText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingTime(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.schedule, size: 16, color: Colors.grey[500]),
          const SizedBox(width: 8),
          Text(
            'Processing time: $processingTime',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
