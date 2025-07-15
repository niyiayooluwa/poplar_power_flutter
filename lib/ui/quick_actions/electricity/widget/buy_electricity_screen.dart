import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/ui/quick_actions/electricity/viewmodel/buy_electricity_provider.dart';

import '../../../../data/model/transaction_class.dart';
import '../../../../data/services/confirm_transaction_service.dart';
import '../../../core/widgets/pin_input.dart';
import '../../../core/widgets/smart_input_field.dart';

/// A screen widget for buying electricity.
class ElectricityScreen extends HookConsumerWidget {
  /// Creates an [ElectricityScreen].
  const ElectricityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Text Editing Controllers for the input fields
    final discoController = useTextEditingController();
    final meterNumberController = useTextEditingController();
    final priceController = useTextEditingController();
    final productController = useTextEditingController();

    //Access the view model and state
    final viewModel = ref.read(buyElectricityViewModelProvider.notifier);
    final state = ref.watch(buyElectricityViewModelProvider);

    //Get the currently selected biller and product, and the available products
    // for the selected biller
    final selectedDisco = state.selectedDisco;
    final selectedProduct = state.selectedProduct;
    // Get the products for the selected disco, or an empty list if no disco is selected.
    final products = selectedDisco?.products ?? [];
    final price = priceController.text;

    // State to track if a transaction is being processed.
    final isProcessing = useState(false);

    useEffect(() {
      //Listener to update the meter number in the view model
      meterNumberController.addListener(() {
        ref
            .read(buyElectricityViewModelProvider.notifier)
            .setMeterNumber(meterNumberController.text);
      });
      //Return null as there's no cleanup needed for this effect
      return null;
    }, const[]);

    // Effect to listen for changes in the price input field and update the view model.
    useEffect(() {
      priceController.addListener(() {
        ref
            .read(buyElectricityViewModelProvider.notifier)
            .setPrice(priceController.text);
      });
      return null;
    }, const []);

    /// Shows a confirmation bottom sheet for the electricity purchase.
    ///
    /// After confirmation, it prompts for PIN entry.
    /// If the PIN is correct, it simulates an API call and navigates
    /// to the transaction detail screen.
    void showElectricityConfirmation(BuildContext context) {
      TransactionSheetService.showConfirmation(
          context,
          title: 'Confirm Data Purchase',
          amount: '₦$price',
          description: 'Data Purchase',
          transactionConfig: TransactionSheetService.dataConfig,
          paymentMethod: TransactionSheetService.walletConfig,
          fields: TransactionSheetService.createElectricityFields(
            disco: selectedDisco!.name,
            meterNumber: meterNumberController.text,
            customerName: 'customerName',
            fee: '₦$price',
            total: '₦$price',
          ),
          onConfirm: () async {
            context.pop(); // Dismiss the bottom sheet
            // Simulate a slight delay before showing the PIN entry.
            await Future.delayed(const Duration(milliseconds: 500));
            // Show the bottom sheet and wait for the result (PIN)
            final pin = await PinEntryService.showPinEntryWithRetry(
              context,
              title: 'Authentication Required',
              validator: (pin) => pin == '1234', // TODO: Replace with actual PIN validation logic
              maxAttempts: 3, // Allow up to 3 PIN entry attempts.
            );

            // If user completed PIN entry
            if (pin != null) {
              isProcessing.value = true;

              await Future.delayed(Duration(seconds: 1)); // Simulate API call
              // TODO: Replace with actual API call to process the electricity purchase.

              isProcessing.value = false;
              context.replace( // Navigate to the transaction detail screen upon successful purchase.
                '/transaction-detail',
                extra: Transaction(
                  title: 'Data Purchase',
                  amount: -int.parse(price).toDouble(),
                  date: DateTime.timestamp(),
                  status: TransactionStatus.success,
                  icon: Icons.wifi,
                ),
              );
            }
          }
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Buy Electricity')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
              children: [
                //Disco selection
                SmartInputField(
                  label: 'Select Biiler',
                  controller: discoController,
                  enableSearch: true,
                  readOnly: true,
                  options: state.electricityDiscos.map((d) => d.name).toList(),
                  // When a disco is selected, update the controller and view model
                  // and clear other input fields.
                  onSelected: (name) {
                    discoController.text = name;
                    viewModel.selectElectricityDisco(name);
                    meterNumberController.clear();
                    priceController.clear();
                    productController.clear();
                  },
                ),

                const SizedBox(height: 16),
                //Meter Number
                SmartInputField(
                  label: 'Meter Number',
                  controller: meterNumberController,
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 16),
                if (selectedDisco != null)
                //Show product picker
                  SmartInputField(
                    label: 'Select Product',
                    controller: productController,
                    readOnly: true,
                    options: products.map((p) => p.name).toList(),
                    onSelected: (name) {
                      // When a product is selected, update the controller, view model,
                      // and set the price based on the selected product.
                      productController.text = name;
                      viewModel.selectProduct(name);
                      final product = products.firstWhere((p) =>
                      p.name == name);
                      priceController.text = product.price as String;
                    },
                  ),

                const SizedBox(height: 16),
                //Price Display
                if (selectedProduct != null)
                  SmartInputField(
                    label: 'Price',
                    controller: priceController,
                    keyboardType: TextInputType.number,
                  ),

                const Spacer(), // Pushes the button to the bottom of the screen.

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: viewModel.isFormValid
                        ? () => showElectricityConfirmation(context)
                        // If the form is not valid, disable the button.
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                      fixedSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Next',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}
