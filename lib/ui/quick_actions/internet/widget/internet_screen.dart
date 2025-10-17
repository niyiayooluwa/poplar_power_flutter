import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/models/transaction_field.dart';
import 'package:poplar_power/ui/core/models/transaction_payload.dart';
import 'package:poplar_power/ui/core/viewmodels/transaction_flow_viewmodel.dart';
import 'package:poplar_power/ui/core/widgets/async_selectable_field.dart';
import 'package:poplar_power/ui/core/widgets/smart_input_field.dart';
import 'package:poplar_power/ui/quick_actions/internet/viewmodel/buy_data_view_model.dart';

class InternetScreen extends HookConsumerWidget {
  const InternetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ispController = useTextEditingController();
    final productController = useTextEditingController();
    final priceController = useTextEditingController();
    final phoneController = useTextEditingController();

    final viewModel = ref.read(buyDataViewModelProvider.notifier);
    final state = ref.watch(buyDataViewModelProvider);
    final transactionFlow = ref.read(transactionFlowProvider.notifier);
    final transactionState = ref.watch(transactionFlowProvider);

    void resetFlow() {
      ispController.clear();
      productController.clear();
      priceController.clear();
      phoneController.clear();
      viewModel.reset();
    }

    useEffect(() {
      final newText = state.selectedIsp?.name ?? '';
      if (ispController.text != newText) {
        ispController.text = newText;
      }
      return null;
    }, [state.selectedIsp]);

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
      final newText = state.phoneNumber;
      if (phoneController.text != newText) {
        phoneController.text = newText;
      }
      return null;
    }, [state.phoneNumber]);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            resetFlow();
            context.pop();
          },
        ),
        title: const Text('Airtime/Data'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              AsyncSelectableField(
                label: 'Select ISP',
                controller: ispController,
                optionsProvider: mappedIspProvider,
                onTap: () async {
                  if (!state.isps.isLoading &&
                      (state.isps.valueOrNull?.isEmpty ?? true)) {
                    viewModel.fetchISPs();
                  }
                },
                onSelected: viewModel.selectISPByOption,
                fallbackIcon: const Icon(Icons.wifi, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              SmartInputField(
                label: 'Phone Number',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 11,
                onChanged: (value) {
                  viewModel.setPhoneNumber(value);
                },
              ),
              const SizedBox(height: 16),
              if (state.selectedIsp != null)

                AsyncSelectableField(
                  label: 'Select Bundle',
                  controller: productController,
                  optionsProvider: mappedProductsProvider,
                  onTap: () async {
                    if (!state.products.isLoading &&
                        (state.products.valueOrNull?.isEmpty ?? true)) {
                      viewModel.fetchProducts(state.selectedIsp!.alias);
                    }
                  },
                  onSelected: viewModel.selectProductByOption,
                  fallbackIcon: const Icon(
                    Icons.wifi_tethering,
                    color: Colors.grey,
                  ),
                ),
              if (state.selectedIsp != null) const SizedBox(height: 16),

              if (state.selectedProduct != null)
                SmartInputField(
                  label: state.selectedProduct?.amount != 0
                      ? 'Price'
                      : 'Amount',
                  controller: priceController,
                  readOnly: state.selectedProduct?.amount != 0 ? true : false,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    viewModel.setPrice(value);
                  },
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: state.isFormValid
                      ? () {
                    final int transactionAmount;
                    if (state.selectedProduct?.amount != 0 && state.selectedProduct?.amount != null) {
                      // If the product has a fixed price, use it.
                      transactionAmount = state.selectedProduct!.amount!;
                    } else {
                      // Otherwise, parse the user-entered amount, defaulting to 0 if invalid.
                      transactionAmount = int.tryParse(state.price) ?? 0;
                    }
                          final payload = TransactionPayload(
                            customerIdentifier: state.phoneNumber,
                            amount: transactionAmount,
                            categoryGroup: 'AIRTIME_AND_DATA',
                            categoryOrBiller: state.selectedIsp!.alias,
                            billerOrProductId: state.selectedProduct!.name,
                            notificationPreference:
                                state.notificationPreference,
                          );

                          transactionFlow.startTransaction(
                            payload: payload,
                            title: 'Confirm Data Purchase',
                            amount: '₦$transactionAmount',
                            fields: [
                              TransactionField(
                                label: 'ISP',
                                value: state.selectedIsp?.name ?? 'N/A',
                              ),
                              TransactionField(
                                label: 'Phone Number',
                                value: state.phoneNumber,
                              ),
                              TransactionField(
                                label: 'Bundle',
                                value: state.selectedProduct?.name ?? 'N/A',
                              ),
                              TransactionField(
                                label: 'Amount',
                                value: '₦$transactionAmount',
                                isHighlighted: true,
                              ),
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
                  child: transactionState.step == TransactionFlowStep.processing
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
}

// Computed providers for UI-ready options
final mappedIspProvider = Provider<AsyncValue<List<SelectableOption>>>((ref) {
  final state = ref.watch(buyDataViewModelProvider);
  return state.isps.whenData(
    (list) => list
        .map(
          (isps) => SelectableOption(name: isps.name, imageUrl: isps.logoUrl),
        )
        .toList(),
  );
});

final mappedProductsProvider = Provider<AsyncValue<List<SelectableOption>>>((
  ref,
) {
  final state = ref.watch(buyDataViewModelProvider);
  return state.products.whenData(
    (list) => list.map((p) => SelectableOption(name: p.name)).toList(),
  );
});
