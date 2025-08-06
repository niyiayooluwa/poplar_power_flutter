import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../data/model/transaction_class.dart';
import '../../../../data/services/confirm_transaction_service.dart';
import '../../../core/widgets/pin_input.dart';
import '../../../core/widgets/smart_input_field.dart';
import '../viewmodel/buy_data_provider.dart';

/// [InternetScreen] is a widget that allows users to purchase internet data bundles.
///
/// It uses a [HookConsumerWidget] to manage state and interact with the [buyDataViewModelProvider].
class InternetScreen extends HookConsumerWidget {
  /// Creates an [InternetScreen] widget.
  const InternetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Text editing controllers for input fields
    final ispController = useTextEditingController();
    final bundleController = useTextEditingController();
    final priceController = useTextEditingController();
    final phoneController = useTextEditingController();

    // Access the view model and state
    final viewModel = ref.read(buyDataViewModelProvider.notifier);
    final state = ref.watch(buyDataViewModelProvider);

    // Get the currently selected ISP and bundle, and the available bundles for the selected ISP
    final selectedISP = state.selectedISP;
    final selectedBundle = state.selectedBundle;
    final bundles = selectedISP?.bundles ?? [];

    final isProcessing = useState(false);

    /// Resets the buy data flow by clearing all input fields and resetting the view model state.
    void resetBuyDataFlow() {
      ispController.clear();
      bundleController.clear();
      priceController.clear();
      phoneController.clear();
      viewModel.reset(); // Reset the view model state
    }

    void showDataConfirmation(BuildContext context) {
      TransactionSheetService.showConfirmation(
        context,
        title: 'Confirm Data\nPurchase',
        amount: '₦${selectedBundle?.price}',
        description: 'Data Purchase of ${selectedBundle?.name} for ${selectedBundle?.validity}',
        transactionConfig: TransactionSheetService.dataConfig,
        fields: TransactionSheetService.createDataFields(
          phoneNumber: phoneController.text,
          network: selectedISP!.name,
          amount: '₦${selectedBundle?.price}',
          plan: '${selectedBundle?.name}',
        ),

        onConfirm: () async {
          context.pop(); // Dismiss the bottom sheet
          await Future.delayed(Duration(milliseconds: 500)); // Simulate API call
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

            await Future.delayed(Duration(seconds: 1)); // Simulate API call

            isProcessing.value = false; // Optional slight delay
            context.replace(
              '/transaction-detail',
              extra: Transaction(
                title: 'Data Purchase',
                amount: -selectedBundle!.price,
                date: DateTime.timestamp(),
                status: TransactionStatus.success,
                icon: Icons.wifi,
              ),
            );
          }
        }
      );
    }

    // Effect hook to reset the buy data flow when the widget is disposed
    /// This ensures that the state is clean when the user navigates away from the screen.
    useEffect(() {
      // Return a function that calls resetBuyDataFlow when the widget is disposed
      return () {
        resetBuyDataFlow();
      };
    }, const []);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: BackButton(
          // When the back button is pressed, reset the flow and pop the current route
          onPressed: () async {
            resetBuyDataFlow();
            context.pop();
          },
        ),
        title: const Text('Internet'), // Title of the app bar
        //centerTitle: true, // Center the title
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              /// ISP Selection
              SmartInputField(
                label: 'Select ISP',
                controller: ispController,
                readOnly: true,
                options: state.isps.map((isp) => isp.name).toList(),
                // When an ISP is selected, update the controller and view model
                onSelected: (name) {
                  ispController.text = name;
                  bundleController.clear();
                  priceController.clear();
                  viewModel.selectISP(
                    name,
                  ); // Update the selected ISP in the view model
                },
              ),

              const SizedBox(height: 16),

              ///Phone Number
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

              /// Bundle Selection
              if (selectedISP != null)
                // Show bundle picker
                SmartInputField(
                  label: 'Select Bundle',
                  controller: bundleController,
                  readOnly: true,
                  options: bundles.map((b) => b.name).toList(),
                  // When a bundle is selected, update the controller, view model, and price
                  onSelected: (name) {
                    bundleController.text = name;
                    viewModel.selectBundle(
                      name,
                    ); // Update the selected bundle in the view model

                    final bundle = bundles.firstWhere((b) => b.name == name);
                    // Display the price of the selected bundle
                    priceController.text = '₦${bundle.price}';
                  },
                ),

              const SizedBox(height: 16),

              /// Price Display
              if (selectedBundle != null)
                // Show bundle price if a bundle is selected
                SmartInputField(
                  label: 'Price',
                  controller: priceController,
                  readOnly: true,
                ),

              Spacer(),

              /// Buy Button
              /// When the buy button is pressed, it navigates to the payment screen
              /// with the selected ISP, bundle, and phone number having been set in the view model.
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: viewModel.isFormValid
                      ? () => showDataConfirmation(context)//context.push('/confirm-details')
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
