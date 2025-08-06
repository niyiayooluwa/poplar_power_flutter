import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/model/transaction_class.dart';
import 'package:poplar_power/data/services/confirm_transaction_service.dart';
import 'package:poplar_power/domain/models/network_provider.dart';
import 'package:poplar_power/ui/core/widgets/pin_input.dart';
import 'package:poplar_power/ui/core/widgets/smart_input_field.dart';
import 'package:poplar_power/ui/quick_actions/airtime/viewmodel/buy_airtime_viewmodel.dart';

class AirtimeScreen extends HookConsumerWidget {
  const AirtimeScreen({super.key});

  static const presetAmounts = [50, 100, 200, 500, 1000, 2000];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(airtimePurchaseProvider.notifier);
    final state = ref.watch(airtimePurchaseProvider);

    final amountController = useTextEditingController();
    final phoneController = useTextEditingController();
    final isProcessing = useState(false);

    useEffect(() {
      // Only update controllers if the values are different to prevent loops
      if (amountController.text != (state.customAmount?.toString() ?? '')) {
        amountController.text = state.customAmount?.toString() ?? '';
      }
      if (phoneController.text != state.phoneNumber) {
        phoneController.text = state.phoneNumber;
      }
      return null;
    }, [state.customAmount, state.phoneNumber]);

    void showAirtimeConfirmation(BuildContext context) {
      TransactionSheetService.showConfirmation(
        context,
        title: 'Confirm Airtime Purchase',
        amount: '₦${state.effectiveAmount}',
        description: 'Airtime Purchase',
        transactionConfig: TransactionSheetService.airtimeConfig,
        fields: TransactionSheetService.createAirtimeFields(
          phoneNumber: state.phoneNumber,
          network: state.selectedNetwork?.label ?? 'Unknown',
          amount: '₦${state.effectiveAmount}',
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
                context.replace(
                  '/transaction-detail',
                  extra: Transaction(
                    title: 'Airtime Purchase',
                    amount: -state.effectiveAmount.toDouble(),
                    date: DateTime.timestamp(),
                    status: TransactionStatus.success,
                    icon: Icons.call,
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Buy Airtime')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Network',
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: 12),
              _buildNetworkSelector(state, viewModel, context),

              const SizedBox(height: 24),
              SmartInputField(
                label: 'Phone Number',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 11,
                  onChanged: (value) {
                    viewModel.setPhoneNumber(value);
                  }
              ),

              const SizedBox(height: 16),
              SmartInputField(
                label: 'Amount',
                keyboardType: TextInputType.number,
                controller: amountController,
                maxLength: 6,
                onChanged: (value) {
                  viewModel.setCustomAmount(int.tryParse(value) ?? 0);
                }
              ),

              const SizedBox(height: 24),
              Text(
                'Or select Amount',
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: 12),
              _buildAmountGrid(state, viewModel, context),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: state.isFormValid
                      ? () => showAirtimeConfirmation(context)
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
                      : Text(
                          state.isFormValid
                              ? 'Continue'
                              : 'Please complete the form',
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

  Widget _buildNetworkSelector(
    AirtimePurchaseState state,
    AirtimePurchaseViewModel viewModel,
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: NetworkProvider.values.map((provider) {
        final selected = state.selectedNetwork == provider;
        return SizedBox(
          child: _buildISPSelector(
            onSelect: () => viewModel.selectNetwork(provider),
            isSelected: selected,
            assetPath: provider.assetPath,
            context: context,
            name: provider.label,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildISPSelector({
    required VoidCallback onSelect,
    required bool isSelected,
    required String assetPath,
    required BuildContext context,
    required String name,
  }) {
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        alignment: Alignment.center,
        width: (MediaQuery.of(context).size.width - 48 - 32) / 4,
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.grey[100],
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset(
                assetPath,
                fit: BoxFit.fill,
                height: 30,
                width: 30,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountGrid(
    AirtimePurchaseState state,
    AirtimePurchaseViewModel viewModel,
    BuildContext context,
  ) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: AirtimeScreen.presetAmounts.map((amount) {
        final selected = state.selectedAmount == amount;
        return GestureDetector(
          onTap: () => viewModel.selectPresetAmount(amount),
          child: Container(
            width: (MediaQuery.of(context).size.width - 20 * 2 - 12 * 2) / 3,
            height: 75,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? Colors.blue : Colors.grey[300]!,
                width: selected ? 2 : 1,
              ),
              color: selected ? Colors.blue[50] : Colors.grey[100],
            ),
            alignment: Alignment.center,
            child: Text(
              '₦$amount',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected ? Colors.blue : Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
