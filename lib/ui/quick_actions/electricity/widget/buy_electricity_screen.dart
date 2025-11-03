import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/models/notification_preference.dart';
import 'package:poplar_power/domain/models/transaction_field.dart';
import 'package:poplar_power/ui/core/models/transaction_payload.dart';
import 'package:poplar_power/ui/core/viewmodels/transaction_flow_viewmodel.dart';
import 'package:poplar_power/ui/core/widgets/async_selectable_field.dart';
import 'package:poplar_power/ui/core/widgets/smart_input_field.dart';
import 'package:poplar_power/ui/quick_actions/electricity/viewmodel/buy_electricity_viewmodel.dart';

class ElectricityScreen extends HookConsumerWidget {
  const ElectricityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Viewmodel and state
    final viewModel = ref.read(buyElectricityViewModelProvider.notifier);
    final state = ref.watch(buyElectricityViewModelProvider);
    final transactionFlow = ref.read(transactionFlowProvider.notifier);
    final transactionState = ref.watch(transactionFlowProvider);

    // Text controllers
    final discoController = useTextEditingController();
    final productController = useTextEditingController();
    final amountController = useTextEditingController();
    final meterNumberController = useTextEditingController();
    final notificationPreference = useTextEditingController();

    final theme = Theme.of(context);

    // Sync state to controllers individually to prevent unwanted resets.
    useEffect(() {
      final newText = state.selectedDisco?.name ?? '';
      if (discoController.text != newText) {
        discoController.text = newText;
      }
      return null;
    }, [state.selectedDisco]);

    useEffect(() {
      final newText = state.selectedProduct?.name ?? '';
      if (productController.text != newText) {
        productController.text = newText;
      }
      return null;
    }, [state.selectedProduct]);

    useEffect(() {
      if (amountController.text != state.amount) {
        amountController.text = state.amount;
      }
      return null;
    }, [state.amount]);

    useEffect(() {
      if (meterNumberController.text != state.meterNumber) {
        meterNumberController.text = state.meterNumber;
      }
      return null;
    }, [state.meterNumber]);

    // The `showElectricityConfirmation` function has been removed.
    // All its logic is now handled by the central TransactionFlowOrchestrator.

    void resetFlow() {
      discoController.clear();
      productController.clear();
      amountController.clear();
      meterNumberController.clear();
      notificationPreference.clear();
      viewModel.reset();
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            resetFlow();
            context.pop();
          },
        ),
        title: const Text('Buy Electricity'),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AsyncSelectableField(
                label: 'Select Disco',
                controller: discoController,
                optionsProvider: mappedDiscosProvider,
                onTap: () async {
                  if (!state.discos.isLoading &&
                      (state.discos.valueOrNull?.isEmpty ?? true)) {
                    viewModel.fetchDiscos();
                  }
                },
                onSelected: viewModel.selectDiscoByOption,
                fallbackIcon: const Icon(
                  Icons.power_rounded,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),

              if (state.selectedDisco != null)
                AsyncSelectableField(
                  label: 'Package',
                  controller: productController,
                  optionsProvider: mappedProductsProvider,
                  onTap: () async {
                    if (!state.products.isLoading &&
                        (state.products.valueOrNull?.isEmpty ?? true)) {
                      viewModel.fetchProducts(state.selectedDisco!.alias);
                    }
                  },
                  onSelected: viewModel.selectProductByOption,
                ),
              if (state.selectedDisco != null) const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      flex: 8,
                      child: SmartInputField(
                        label: 'Meter Number',
                        controller: meterNumberController,
                        keyboardType: TextInputType.number,
                        maxLength: state.selectedDisco?.accountNumberSize,
                        onChanged: viewModel.setMeterNumber,
                      ),
                    ),

                    Flexible(
                      flex: 2,
                      child: FilledButton(
                        onPressed:
                            state.canVerify &&
                                !state.verificationState.isLoading
                            ? () {
                                viewModel.verifyCustomer();
                              }
                            : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state.verificationState.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Verify',
                                style: Theme.of(context).textTheme.titleMedium
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
              const SizedBox(height: 16),

              state.verificationState.when(
                // This function runs when data is available
                data: (customer) {
                  if (customer == null) {
                    // Don't show anything until verification is successful
                    return const SizedBox.shrink();
                  }

                  final customerName = customer.fullname;

                  return Text(
                    customerName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.green,
                    ),
                  );
                },

                // This widget shows while the customer name is being fetched
                loading: () => const SizedBox.shrink(),
    /*const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),*/

                error: (Object error, StackTrace stackTrace) {
                  return Text(
                    'Account verification failed',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.red,
                    ),
                  );
                },
              ),

              SmartInputField(
                label: 'Amount',
                controller: amountController,
                keyboardType: TextInputType.number,
                onChanged: viewModel.setAmount,
              ),
              const SizedBox(height: 16),

              SmartInputField(
                label: 'Notification Preference',
                controller: notificationPreference,
                options: ['Email', 'SMS', 'BOTH'],
                onSelected: ((selected) => viewModel.setPreference(
                  NotificationPreference.fromJson(selected),
                )),
              ),
              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: state.isFormValid
                      ? () {
                          final payload = TransactionPayload(
                            customerIdentifier: state.meterNumber,
                            amount: int.tryParse(state.amount) ?? 0,
                            categoryGroup: 'ELECTRICITY',
                            categoryOrBiller: state.selectedDisco!.alias,
                            billerOrProductId: state.selectedProduct!.name,
                            notificationPreference:
                                state.notificationPreference!,
                          );

                          transactionFlow.startTransaction(
                            payload: payload,
                            title: 'Confirm Token Purchase',
                            amount: '₦${state.amount}',
                            fields: [
                              TransactionField(
                                label: 'Disco',
                                value: state.selectedDisco?.name ?? 'N/A',
                              ),
                              TransactionField(
                                label: 'Meter Number',
                                value: state.meterNumber,
                              ),
                              state.verificationState.when(
                                // This function runs when data is available
                                data: (customer) => TransactionField(
                                  label: 'Customer Name',
                                  // Check if customer is not null, otherwise show 'N/A'
                                  value: customer?.fullname ?? 'N/A',
                                ),

                                // This widget shows while the customer name is being fetched
                                loading: () => const TransactionField(
                                  label: 'Customer Name',
                                  value: 'Verifying...',
                                ),

                                // This widget shows if the verification fails
                                error: (err, stack) => TransactionField(
                                  label: 'Customer Name',
                                  value: 'Verification Failed',
                                  valueColor: Colors
                                      .red, // Optional: highlight the error
                                ),
                              ),
                              TransactionField(
                                label: 'Service Fee',
                                value: '₦0.00',
                              ),
                              TransactionField(
                                label: 'Total Amount',
                                value: '₦${state.amount}',
                                isHighlighted: true,
                              ),
                            ],
                          );
                        }
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: transactionState.step == TransactionFlowStep.processing
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Next',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// Computed providers for UI-ready options
final mappedDiscosProvider = Provider<AsyncValue<List<SelectableOption>>>((
  ref,
) {
  final state = ref.watch(buyElectricityViewModelProvider);
  return state.discos.whenData(
    (list) => list
        .map((d) => SelectableOption(name: d.name, imageUrl: d.logoUrl))
        .toList(),
  );
});

final mappedProductsProvider = Provider<AsyncValue<List<SelectableOption>>>((
  ref,
) {
  final state = ref.watch(buyElectricityViewModelProvider);
  return state.products.whenData(
    (list) => list.map((p) => SelectableOption(name: p.name)).toList(),
  );
});
