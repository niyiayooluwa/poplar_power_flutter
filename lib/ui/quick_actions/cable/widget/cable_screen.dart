import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/ui/core/models/transaction.dart';
import 'package:poplar_power/ui/core/widgets/async_selectable_field.dart';
import 'package:poplar_power/ui/core/widgets/pin_input.dart';
import 'package:poplar_power/ui/core/widgets/smart_input_field.dart';
import 'package:poplar_power/ui/core/widgets/transaction_confirmation.dart';
import 'package:poplar_power/ui/quick_actions/cable/viewmodel/buy_cable_viewmodel.dart';

class CableScreen extends HookConsumerWidget {
  const CableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Viewmodel and state
    final viewModel = ref.read(buyCableViewModelProvider.notifier);
    final state = ref.watch(buyCableViewModelProvider);

    // Text editing controllers for input fields
    final cableController = useTextEditingController();
    final productController = useTextEditingController();
    final priceController = useTextEditingController();
    final accountNumberController = useTextEditingController();

    final isProcessing = useState(false);

    useEffect(() {
      if (state.selectedProvider == null) {
        productController.clear();
        priceController.clear();
      }
      return null;
    }, [state.selectedProvider]);

    useEffect(
      () {
        cableController.text = state.selectedProvider?.name ?? '';
        productController.text = state.selectedProduct?.name ?? '';
        priceController.text = state.amount ?? '';
        accountNumberController.text = state.accountNumber!;
        return null;
      },
      [
        state.selectedProvider,
        state.selectedProduct,
        state.amount,
        state.accountNumber,
      ],
    );

    /// Resets the buy cable flow by clearing all input fields and resetting the view model state.
    void reset() {
      cableController.clear();
      productController.clear();
      priceController.clear();
      accountNumberController.clear();
      //viewModel.reset(); // Reset the view model state
    }

    void showCableConfirmation(BuildContext context) {
      TransactionSheetService.showConfirmation(
        context,
        title: 'Confirm Cable Subscription',
        amount: '₦{someAmount?.price}',
        description: '${state.selectedProduct?.name}',
        transactionConfig: TransactionSheetService.billConfig,
        fields: TransactionSheetService.createBillFields(
          service: cableController.text,
          accountNumber: accountNumberController.text,
          package: state.selectedProduct!.name,
          fee: priceController.text,
          total: priceController.text,
        ),
        onConfirm: () async {
          context.pop(); // Dismiss the bottom sheet
          await Future.delayed(
            Duration(milliseconds: 500),
          ); // Simulate API call
          // Show the bottom sheet and wait for the result (PIN)
          final pin =  await PinEntryService.showPinEntryWithRetry(
            context,
            title: 'Authentication Required',
            validator: (pin) => pin == '1234',
            maxAttempts: 3,
          );

          // If user completed PIN entry
          if (pin != null) {
            isProcessing.value = true;

            await Future.delayed(Duration(seconds: 1)); // Simulate API call

            isProcessing.value = false; // Optional slight delay
            context.replace(
              '/transaction-detail',
              extra: Transaction(
                title: 'Cable Subscription',
                amount: 2233,
                date: DateTime.timestamp(),
                status: TransactionStatus.success,
                icon: Icons.wifi,
              ),
            );
          }
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () async {
            reset();
            context.pop();
          },
        ),
        title: const Text('Cable'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              AsyncSelectableField(
                label: 'Select TV ',
                controller: cableController,
                optionsProvider: mappedCableProvider,
                onTap: () async {
                  if (!state.cableProviders.isLoading &&
                      (state.cableProviders.valueOrNull?.isEmpty ?? true)) {
                    viewModel.fetchProviders();
                  }
                },
                onSelected: (name) {
                  final selected = state.cableProviders.valueOrNull?.firstWhere(
                    (c) => c.name == name,
                  );
                  if (selected != null) {
                    viewModel.selectCableProvider(selected);
                  }
                },
                fallbackIcon: const Icon(Icons.tv, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              if (state.selectedProvider != null)
                AsyncSelectableField(
                  label: 'Package',
                  controller: productController,
                  optionsProvider: mappedProductsProvider,
                  onTap: () async {
                    if (!state.products.isLoading &&
                        (state.products.valueOrNull?.isEmpty ?? true)) {
                      viewModel.fetchProducts(state.selectedProvider!.alias);
                    }
                  },
                  onSelected: (name) {
                    final selected = state.products.valueOrNull?.firstWhere(
                          (p) => p.name == name,
                    );
                    if (selected != null) {
                      viewModel.selectPackage(selected);
                    }
                  },
                  fallbackIcon: const Icon(Icons.tv, color: Colors.grey),
                ),
              if (state.selectedProvider != null)
                const SizedBox(height: 16),


              /// Account Number
              SmartInputField(
                label: 'Account Number',
                controller: accountNumberController,
                keyboardType: TextInputType.number,
                maxLength: state.selectedProvider?.accountNumberSize,
                onChanged: viewModel.setAccountNumber
              ),
              const SizedBox(height: 16),


              /// Price Display
              /*if (selectedPackage != null)
                // Show bundle price if a bundle is selected
                SmartInputField(
                  label: 'Price',
                  controller: priceController,
                  readOnly: true,
                ),*/

              Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: state.isFormValid
                      ? () =>
                            showCableConfirmation(
                              context,
                            ) //context.push('/confirm-details')
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    fixedSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Next',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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

final mappedCableProvider = Provider<AsyncValue<List<SelectableOption>>>((ref) {
  final state = ref.watch(buyCableViewModelProvider);
  return state.cableProviders.whenData(
    (list) => list
        .map((d) => SelectableOption(name: d.name, imageUrl: d.logoUrl))
        .toList(),
  );
});

final mappedProductsProvider = Provider<AsyncValue<List<SelectableOption>>>((
  ref,
) {
  final state = ref.watch(buyCableViewModelProvider);
  return state.products.whenData(
    (list) => list.map((p) => SelectableOption(name: p.name)).toList(),
  );
});
