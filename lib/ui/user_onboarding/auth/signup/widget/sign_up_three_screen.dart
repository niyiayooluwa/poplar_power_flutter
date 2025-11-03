import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:poplar_power/ui/user_onboarding/auth/signup/widget/progressBar.dart';

import '../viewmodel/signup_view_model.dart';

class SignupStep3Screen extends HookConsumerWidget {
  const SignupStep3Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Theme
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;
    final asset = isDarkTheme
        ? 'assets/dark_variant.png'
        : 'assets/login_screen_bg.png';
    final overlayColor = isDarkTheme
        ? const Color(0xFF1E293B).withValues(alpha: 0.98)
        : Colors.white.withValues(alpha: 0.3);

    final pinController = useTextEditingController();
    final pinError = useState<String?>(null);

    // Watch the signup state
    final state = ref.watch(signupViewModelProvider);
    final vm = ref.read(signupViewModelProvider.notifier);

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
                        SizedBox(height: 16),

                        // Back button
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

                        //Upper section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),

                            Text(
                              "Secure your wallet 🔐",
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "Choose a 4-digit PIN you'll use for every transaction.",
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.textTheme.titleMedium?.color
                                    ?.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        //Input Fields
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // PIN Input
                                SizedBox(
                                  width: 300,
                                  child: PinCodeTextField(
                                    appContext: context,
                                    length: 4,
                                    obscureText: true,
                                    obscuringCharacter: '●',
                                    animationType: AnimationType.fade,
                                    controller: pinController,
                                    keyboardType: TextInputType.number,
                                    textStyle: theme.textTheme.headlineMedium,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(8),
                                      fieldHeight: 60,
                                      fieldWidth: 60,
                                      activeFillColor: Colors.white,
                                      inactiveFillColor: isDarkTheme
                                          ? Colors.grey[800]!
                                          : Colors.grey[200]!,
                                      selectedFillColor: Colors.blue.shade50,
                                      activeColor: Colors.blue,
                                      inactiveColor: Colors.grey,
                                      selectedColor: Colors.blue,
                                    ),
                                    animationDuration: const Duration(
                                      milliseconds: 300,
                                    ),
                                    enableActiveFill: true,
                                    onChanged: (value) {
                                      pinError.value = null;
                                    },
                                    errorTextSpace: 30,
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Info message
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isDarkTheme
                                        ? Colors.blue.shade900.withValues(
                                            alpha: 0.2,
                                          )
                                        : Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,

                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.blue.shade600,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          "Keep it private — don't reuse your ATM or phone PIN.",
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Next button
                        FilledButton(
                          onPressed: () {
                            final pin = pinController.text.trim();

                            if (pin.isEmpty) {
                              pinError.value = 'PIN is required';
                              return;
                            }

                            if (pin.length != 4) {
                              pinError.value = 'PIN must be 4 digits';
                              return;
                            }

                            // Save PIN to state and move to next step
                            vm.savePinAndContinue(pin: int.parse(pin));
                            vm.goToNextStep();
                            context.push('/signup-four');
                          },
                          style: FilledButton.styleFrom(
                            fixedSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Next",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodyMedium,
                            children: <TextSpan>[
                              const TextSpan(text: "Already have an account? "),
                              TextSpan(
                                text: 'Login here',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.push('/login');
                                  },
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 24),
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
