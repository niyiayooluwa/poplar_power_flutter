import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/ui/core/widgets/async_selectable_field.dart';
import 'package:poplar_power/ui/core/widgets/smart_input_field.dart';
import 'package:poplar_power/ui/quick_actions/electricity/viewmodel/buy_electricity_viewmodel.dart';

class ElectricityScreen extends HookConsumerWidget {
  const ElectricityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(buyElectricityViewModelProvider.notifier);
    final state = ref.watch(buyElectricityViewModelProvider);

    // Text controllers
    final discoController = useTextEditingController();
    final productController = useTextEditingController();
    final amountController = useTextEditingController();
    final meterNumberController = useTextEditingController();
    final notificationPreference = useTextEditingController();

    final isProcessing = useState(false);

    // Reset product field when disco changes
    useEffect(() {
      if (state.selectedDisco == null) {
        productController.clear();
      }
      return null;
    }, [state.selectedDisco]);

    useEffect(
      () {
        discoController.text = state.selectedDisco?.name ?? '';
        productController.text = state.selectedProduct?.name ?? '';
        amountController.text = state.amount;
        meterNumberController.text = state.meterNumber;
        return null;
      },
      [
        state.selectedDisco,
        state.selectedProduct,
        state.amount,
        state.meterNumber,
      ],
    );

    void showElectricityConfirmation() {
      if (!state.isFormValid) return;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Buy Electricity')),
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
                onSelected: (selectedName) {
                  final selected = state.discos.valueOrNull?.firstWhere(
                    (d) => d.name == selectedName,
                  );
                  if (selected != null) {
                    viewModel.selectDisco(selected);
                  }
                },
                fallbackIcon: const Icon(Icons.power_rounded),
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
                  onSelected: (selectedName) {
                    final selected = state.products.valueOrNull?.firstWhere(
                      (p) => p.name == selectedName,
                    );
                    if (selected != null) {
                      viewModel.selectProduct(selected);
                    }
                  },
                ),
              const SizedBox(height: 16),

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
              SizedBox(height: 16),

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
                  // Enable button if form is valid and not currently processing
                  onPressed: state.isFormValid && !isProcessing.value
                      ? showElectricityConfirmation
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    // Adjust padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isProcessing.value
                      ? const SizedBox(
                          height:
                              24, // Consistent height for text and indicator
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
                                // Using titleMedium for button text
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
