import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/models/transaction_field.dart';
import 'package:poplar_power/ui/core/viewmodels/transaction_flow_viewmodel.dart';
import 'package:poplar_power/ui/core/widgets/async_selectable_field.dart';
import 'package:poplar_power/ui/core/widgets/smart_input_field.dart';
import 'package:poplar_power/ui/quick_actions/electricity/viewmodel/buy_electricity_viewmodel.dart';

class ElectricityScreen extends HookConsumerWidget {
  const ElectricityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    // The local `isProcessing` state is no longer needed.

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

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            viewModel.reset();
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
              SmartInputField(
                label: 'Meter Number',
                controller: meterNumberController,
                keyboardType: TextInputType.number,
                maxLength: state.selectedDisco?.accountNumberSize,
                onChanged: viewModel.setMeterNumber,
              ),
              const SizedBox(height: 16),

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
                onSelected: ((selected) => viewModel.setPreference(selected)),
              ),
              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: state.isFormValid
                      ? () {
                          transactionFlow.startTransaction(
                            title: 'Confirm Token Purchase',
                            amount: '₦${state.amount}',
                            fields: [
                              TransactionField(
                                  label: 'Disco',
                                  value: state.selectedDisco?.name ?? 'N/A'),
                              TransactionField(
                                  label: 'Meter Number',
                                  value: state.meterNumber),
                              TransactionField(
                                  label: 'Customer Name',
                                  value: 'John Doe'), // TODO(dev): Get real name
                              TransactionField(
                                  label: 'Service Fee', value: '₦0.00'),
                              TransactionField(
                                  label: 'Total Amount',
                                  value: '₦${state.amount}',
                                  isHighlighted: true),
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
                  child: transactionState.step ==
                          TransactionFlowStep.processing
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
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
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
