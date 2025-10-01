import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/models/transaction_field.dart';
import 'package:poplar_power/ui/core/models/transaction_payload.dart';
import 'package:poplar_power/ui/core/viewmodels/transaction_flow_viewmodel.dart';
import 'package:poplar_power/ui/core/widgets/async_selectable_field.dart';
import 'package:poplar_power/ui/core/widgets/smart_input_field.dart';
import 'package:poplar_power/ui/quick_actions/cable/viewmodel/buy_cable_viewmodel.dart';

class CableScreen extends HookConsumerWidget {
  const CableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Viewmodel and state
    final viewModel = ref.read(buyCableViewModelProvider.notifier);
    final state = ref.watch(buyCableViewModelProvider);
    final transactionFlow = ref.read(transactionFlowProvider.notifier);
    final transactionState = ref.watch(transactionFlowProvider);

    // Text editing controllers for input fields
    final cableController = useTextEditingController();
    final productController = useTextEditingController();
    final priceController = useTextEditingController();
    final accountNumberController = useTextEditingController();

    useEffect(() {
      final newText = state.selectedProvider?.name ?? '';
      if (cableController.text != newText) {
        cableController.text = newText;
      }
      return null;
    }, [state.selectedProvider]);

    useEffect(() {
      final newText = state.selectedProduct?.name ?? '';
      if (productController.text != newText) {
        productController.text = newText;
      }
      return null;
    }, [state.selectedProduct]);

    useEffect(() {
      final newText = state.selectedProduct?.amount.toString() ?? '';
      if (priceController.text != newText) {
        priceController.text = newText;
      }
      return null;
    }, [state.selectedProduct]);

    useEffect(() {
      final newText = state.accountNumber;
      if (accountNumberController.text != newText) {
        accountNumberController.text = newText;
      }
      return null;
    }, [state.accountNumber]);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () async {
            viewModel.reset();
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
                label: 'Select TV Provider',
                controller: cableController,
                optionsProvider: mappedCableProvider,
                onTap: () async {
                  if (!state.cableProviders.isLoading &&
                      (state.cableProviders.valueOrNull?.isEmpty ?? true)) {
                    viewModel.fetchProviders();
                  }
                },
                onSelected: viewModel.selectCableProviderByOption,
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
                  onSelected: viewModel.selectPackageByOption,
                  fallbackIcon: const Icon(Icons.tv, color: Colors.grey),
                ),
              if (state.selectedProvider != null) const SizedBox(height: 16),
              SmartInputField(
                  label: 'Account Number',
                  controller: accountNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: state.selectedProvider?.accountNumberSize,
                  onChanged: viewModel.setAccountNumber),
              const SizedBox(height: 16),
              if (state.selectedProduct != null)
                SmartInputField(
                  label: 'Price',
                  controller: priceController,
                  readOnly: true,
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: state.isFormValid
                      ? () {
                          final payload = TransactionPayload(
                            customerIdentifier: state.accountNumber,
                            amount: state.selectedProduct?.amount ?? 0,
                            categoryGroup: 'PAY_TV',
                            categoryOrBiller: state.selectedProvider!.alias,
                            billerOrProductId: state.selectedProduct!.id,
                            notificationPreference:
                                state.notificationPreference,
                          );
                          transactionFlow.startTransaction(
                            payload: payload,
                            title: 'Confirm Cable Subscription',
                            amount: '₦${state.selectedProduct?.amount ?? 0}',
                            fields: [
                              TransactionField(
                                  label: 'TV Provider',
                                  value: state.selectedProvider?.name ?? 'N/A'),
                              TransactionField(
                                  label: 'Account Number',
                                  value: state.accountNumber),
                              TransactionField(
                                  label: 'Package',
                                  value: state.selectedProduct?.name ?? 'N/A'),
                              TransactionField(
                                  label: 'Amount',
                                  value:
                                      '₦${state.selectedProduct?.amount ?? 0}',
                                  isHighlighted: true),
                            ],
                          );
                        }
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    fixedSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: transactionState.step ==
                          TransactionFlowStep.processing
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
                          'Next',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
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
