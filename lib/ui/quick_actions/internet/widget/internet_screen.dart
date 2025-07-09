import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/widgets/smart_input_field.dart';
import '../viewmodel/buy_data_provider.dart';

/// [InternetScreen] is a widget that allows users to purchase internet data bundles.
///
/// It uses a [HookConsumerWidget] to manage state and interact with the [buyDataViewModelProvider].
class InternetScreen extends HookConsumerWidget{
  /// Creates an [InternetScreen] widget.
  const InternetScreen ({super.key});

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

    /// Resets the buy data flow by clearing all input fields and resetting the view model state.
    void resetBuyDataFlow() {
      ispController.clear();
      bundleController.clear();
      priceController.clear();
      phoneController.clear();
      viewModel.reset(); // Reset the view model state
    }

    // Effect hook to listen for changes in the phone number input field
    useEffect(() {
      // Listener to update the phone number in the view model
      phoneController.addListener(() {
        ref.read(buyDataViewModelProvider.notifier)
            .setPhoneNumber(phoneController.text);
      });
      // Return null as there's no cleanup needed for this effect
      return null;
    }, const []);

    // Effect hook to reset the buy data flow when the widget is disposed
    /// This ensures that the state is clean when the user navigates away from the screen.
    useEffect(() {
      // Return a function that calls resetBuyDataFlow when the widget is disposed
      return () {resetBuyDataFlow();};
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
        centerTitle: true, // Center the title
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
                  viewModel.selectISP(name); // Update the selected ISP in the view model
                },
              ),

              const SizedBox(height: 16),

              ///Phone Number
              SmartInputField(
                label: 'Phone Number',
                controller: phoneController,
                keyboardType: TextInputType.phone,
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
                    viewModel.selectBundle(name); // Update the selected bundle in the view model

                    final bundle = bundles.firstWhere((b) => b.name == name);
                    // Display the price of the selected bundle
                    priceController.text = '₦${bundle.price}';
                  },
                ),

              const SizedBox(height: 16),

              /// Price Display
              if(selectedBundle != null)
                // Show bundle price if a bundle is selected
                SmartInputField(
                  label: 'Price',
                  controller: priceController,
                  readOnly: true,
                ),
            ],
          ),
        ),
      ),
    );
  }
}



