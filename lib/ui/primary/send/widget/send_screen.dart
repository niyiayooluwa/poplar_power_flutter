import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/ui/core/widgets/smart_input_field.dart';

import '../viewmodel/send_provider.dart';
import '../viewmodel/send_state.dart';

class SendScreen extends HookConsumerWidget {
  const SendScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final bankNameController = useTextEditingController();
    final accountNumberController = useTextEditingController();

    //Access the viewmodel and state
    final viewModel = ref.read(sendViewModelProvider.notifier);
    final state = ref.watch(sendViewModelProvider);

    //State
    final selectedBank = state.selectedBank;

    void resetControllers() {
      bankNameController.clear();
      accountNumberController.clear();
    }

    // Debounced async validation
    useEffect(() {
      Timer? timer;

      void handleTyping() {
        timer?.cancel();
        timer = Timer(const Duration(milliseconds: 800), () {
          final text = accountNumberController.text;
          if (text.length == 10 && selectedBank != null) {
            viewModel.verifyAccountNumber(text);
          }
        });
      }

      accountNumberController.addListener(handleTyping);

      return () {
        timer?.cancel();
        accountNumberController.removeListener(handleTyping);
      };
    }, [accountNumberController, selectedBank]);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Send Money'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SmartInputField(
                label: 'Bank Account',
                controller: bankNameController,
                readOnly: true,
                options: state.bank.map((bank) => bank.name).toList(),
                keyboardType: TextInputType.text,
                errorMessage: 'You haven’t selected a bank account yet',
                enableSearch: true,
                onChanged: (value) {
                  viewModel.setSelectedBank(value);
                },
                hintText: 'Select a bank account',
              ),

              const SizedBox(height: 16),

              SmartInputField(
                label: 'Account Number',
                controller: accountNumberController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                errorMessage: 'You haven’t selected an account number yet',
                hintText: 'Select an account number',
              ),

              const SizedBox(height: 8),
              SizedBox(
                height: 20,
                child: switch (state.validationStatus) {
                  AccountValidationStatus.initial => const SizedBox.shrink(),
                  AccountValidationStatus.loading => const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  ),
                  AccountValidationStatus.success => Text(
                    state.accountName ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.green,
                    ),
                  ),
                  AccountValidationStatus.error => Text(
                    state.errorMessage ?? 'An error occurred',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.red,
                    ),
                  ),
                },
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed:
                      state.validationStatus == AccountValidationStatus.success
                      ? () {
                          viewModel.setAccountNumber(
                            accountNumberController.text,
                          );
                          resetControllers();
                          context.push('/send2');
                        }
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
