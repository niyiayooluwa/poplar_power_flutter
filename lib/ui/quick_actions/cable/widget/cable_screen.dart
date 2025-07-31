import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../../data/model/transaction_class.dart';
import '../../../../../../data/services/confirm_transaction_service.dart';
import '../../../core/widgets/pin_input.dart';
import '../../../core/widgets/smart_input_field.dart';
import '../viewmodel/buy_cable_provider.dart';

/// [CableScreen] is a widget that allows users to purchase Cable TV subscriptions.
///
/// It uses a [HookConsumerWidget] to manage state and interact with the [buyCableViewModelProvider].
class CableScreen extends HookConsumerWidget {
  /// Creates an [CableScreen] widget.
  const CableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Text editing controllers for input fields
    final cableController = useTextEditingController();
    final packageController = useTextEditingController();
    final priceController = useTextEditingController();
    final accountNumberController = useTextEditingController();

    // Access the view model and state
    final viewModel = ref.read(buyCableViewModelProvider.notifier);
    final state = ref.watch(buyCableViewModelProvider);

    // Get the currently selected ISP and bundle, and the available bundles for the selected ISP
    final selectedProvider = state.selectedProvider;
    final selectedPackage = state.selectedPackage;
    final bundles = selectedProvider?.packages ?? [];

    final isProcessing = useState(false);

    /// Resets the buy cable flow by clearing all input fields and resetting the view model state.
    void resetBuyDataFlow() {
      cableController.clear();
      packageController.clear();
      priceController.clear();
      accountNumberController.clear();
      viewModel.reset(); // Reset the view model state
    }

    void showCableConfirmation(BuildContext context) {
      TransactionSheetService.showConfirmation(
        context,
        title: 'Confirm Cable Subscription',
        amount: '₦${selectedPackage?.price}',
        description: 'Cable Subscription',
        transactionConfig: TransactionSheetService.billConfig,
        paymentMethod: TransactionSheetService.walletConfig,
        fields: TransactionSheetService.createBillFields(
          service: cableController.text,
          accountNumber: accountNumberController.text,
          package: packageController.text,
          fee: priceController.text,
          total: priceController.text,
        ),
        onConfirm: () async {
          context.pop(); // Dismiss the bottom sheet
          await Future.delayed(
            Duration(milliseconds: 500),
          ); // Simulate API call
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
                title: 'Cable Subscription',
                amount: -selectedPackage!.price,
                date: DateTime.timestamp(),
                status: TransactionStatus.success,
                icon: Icons.wifi,
              ),
            );
          }
        },
      );
    }

    // Effect hook to listen for changes in the account number input field
    useEffect(() {
      // Listener to update the account number in the view model
      accountNumberController.addListener(() {
        ref
            .read(buyCableViewModelProvider.notifier)
            .setAccountNumber(accountNumberController.text);
      });
      // Return null as there's no cleanup needed for this effect
      return null;
    }, const []);

    // Effect hook to reset the buy cable flow when the widget is disposed
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
        title: const Text('Cable'), // Title of the app bar
        //centerTitle: true, // Center the title
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              /// Cable Provider Selection
              SmartInputField(
                label: 'Select Cable Provider',
                controller: cableController,
                readOnly: true,
                options: state.cableProviders.map((isp) => isp.name).toList(),
                // When a Cable Provider is selected, update the controller and view model
                onSelected: (name) {
                  cableController.text = name;
                  packageController.clear();
                  priceController.clear();
                  viewModel.selectCableProvider(
                    name,
                  ); // Update the selected ISP in the view model
                },
              ),

              const SizedBox(height: 16),

              /// Account Number
              SmartInputField(
                label: 'Account Number',
                controller: accountNumberController,
                keyboardType: TextInputType.number,
                maxLength: 10,
              ),

              const SizedBox(height: 16),

              /// Package Selection
              if (selectedProvider != null)
                // Show package picker
                SmartInputField(
                  label: 'Select Bundle',
                  controller: packageController,
                  readOnly: true,
                  options: bundles.map((b) => b.name).toList(),
                  // When a bundle is selected, update the controller, view model, and price
                  onSelected: (name) {
                    packageController.text = name;
                    viewModel.selectCablePackage(
                      name,
                    ); // Update the selected bundle in the view model

                    final bundle = bundles.firstWhere((b) => b.name == name);
                    // Display the price of the selected bundle
                    priceController.text = '₦${bundle.price}';
                  },
                ),

              const SizedBox(height: 16),

              /// Price Display
              if (selectedPackage != null)
                // Show bundle price if a bundle is selected
                SmartInputField(
                  label: 'Price',
                  controller: priceController,
                  readOnly: true,
                ),

              Spacer(),

              /// Buy Button
              /// When the buy button is pressed, it shows the confirmation bottom sheet
              /// with the selected Cable Provider, package, and account number having been set in the view model.
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: viewModel.isFormValid
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
