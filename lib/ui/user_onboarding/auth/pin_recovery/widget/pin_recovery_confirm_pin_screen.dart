import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:poplar_power/ui/user_onboarding/auth/pin_recovery/viewmodel/pin_recovery_view_model.dart';
import 'package:poplar_power/ui/user_onboarding/auth/signup/widget/progressBar.dart';

class PinRecoveryConfirmPinScreen extends HookConsumerWidget {
  const PinRecoveryConfirmPinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

    final asset = isDarkTheme
        ? 'assets/dark_variant.png'
        : 'assets/login_screen_bg.png';

    final overlayColor = isDarkTheme
        ? const Color(0xFF1E293B).withValues(alpha: 0.98)
        : Colors.white.withValues(alpha:0.3);

    final confirmPinController = useTextEditingController();
    final confirmPinError = useState<String?>(null);

    final vm = ref.read(pinRecoveryViewModelProvider.notifier);
    final state = ref.watch(pinRecoveryViewModelProvider);

    ref.listen<PinRecoveryState>(pinRecoveryViewModelProvider, (
      previous,
      next,
    ) {
      if (next.errorMessage != null && next.status is! AsyncLoading) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
        vm.setError(null);
      }
      if (next.pinResetSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pin reset successful! Please log in.')),
        );
        context.go('/home');
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(asset, fit: BoxFit.cover),
            ),
          ),
          Container(color: overlayColor),
          Column(
            children: [
              ProgressBar(progress: state.progress),
              Flexible(
                fit: FlexFit.loose,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 24),
                            onPressed: () {
                              vm.goToPreviousStep();
                              context.pop();
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Confirm your PIN 🔐",
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Re-enter your 4-digit PIN to make sure it's correct.",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color:
                                theme.textTheme.titleMedium?.color?.withValues(alpha:0.7),
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: 300,
                          child: PinCodeTextField(
                            appContext: context,
                            length: 4,
                            obscureText: true,
                            obscuringCharacter: '●',
                            animationType: AnimationType.fade,
                            controller: confirmPinController,
                            keyboardType: TextInputType.number,
                            textStyle: theme.textTheme.headlineMedium,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(8),
                              fieldHeight: 60,
                              fieldWidth: 60,
                              activeFillColor: Colors.white,
                              inactiveFillColor:
                                  isDarkTheme ? Colors.grey[800]! : Colors.grey[200]!,
                              selectedFillColor: Colors.blue.shade50,
                              activeColor: Colors.blue,
                              inactiveColor: Colors.grey,
                              selectedColor: Colors.blue,
                            ),
                            animationDuration: const Duration(milliseconds: 300),
                            enableActiveFill: true,
                            onChanged: (value) {
                              confirmPinError.value = null;
                            },
                            errorTextSpace: 30,
                          ),
                        ),
                        if (confirmPinError.value != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            confirmPinError.value!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDarkTheme
                                ? Colors.blue.shade900.withValues(alpha:0.2)
                                : Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "Keep it private — don't reuse your ATM or phone PIN or old PIN.",
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: state.status is AsyncLoading
                              ? null
                              : () {
                                  final confirmPin = confirmPinController.text.trim();
                                  if (confirmPin.isEmpty) {
                                    confirmPinError.value = 'PIN is required';
                                    return;
                                  }
                                  if (confirmPin.length != 4) {
                                    confirmPinError.value = 'PIN must be 4 digits';
                                    return;
                                  }
                                  if (state.newPin == null) {
                                    confirmPinError.value = 'Error: New PIN not found';
                                    return;
                                  }
                                  if (int.parse(confirmPin) != int.parse(state.newPin!)) {
                                    confirmPinError.value = 'PINs do not match';
                                    return;
                                  }
                                  vm.resetPin(
                                    accountNo: state.accountNo!,
                                  );
                                },
                          style: FilledButton.styleFrom(
                            fixedSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: state.status is AsyncLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  "Next",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
