import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/ui/user_onboarding/auth/signup/widget/progressBar.dart';

import '../viewmodel/signup_view_model.dart';

class SignupStep2Screen extends HookConsumerWidget {
  const SignupStep2Screen({super.key});

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

    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    final passwordVisible = useState(false);
    final confirmPasswordVisible = useState(false);

    // Holds the current password validation error
    final passwordError = useState<String?>(null);
    final confirmPasswordError = useState<String?>(null);

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
                              "Set your password",
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "Choose a password you'll remember — but no one can guess",
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
                                // Password input
                                TextField(
                                  controller: passwordController,
                                  obscureText: !passwordVisible.value,
                                  onChanged: (value) {
                                    // Clear error on change
                                    passwordError.value = null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    errorText: passwordError.value,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        passwordVisible.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () => passwordVisible.value =
                                          !passwordVisible.value,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Password strength rules
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: PasswordStrengthIndicator(
                                    password: useValueListenable(
                                      passwordController,
                                    ).text,
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Confirm password
                                TextField(
                                  controller: confirmPasswordController,
                                  obscureText: !confirmPasswordVisible.value,
                                  onChanged: (value) {
                                    confirmPasswordError.value = null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                    errorText: confirmPasswordError.value,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        confirmPasswordVisible.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () =>
                                          confirmPasswordVisible.value =
                                              !confirmPasswordVisible.value,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Next button
                        FilledButton(
                          onPressed: state.validatePassword ? () {
                            final password = passwordController.text;
                            final confirm = confirmPasswordController.text;

                            if (password.isEmpty) {
                              passwordError.value = 'Password is required';
                              return;
                            }

                            if (confirm.isEmpty) {
                              confirmPasswordError.value =
                                  'Please confirm your password';
                              return;
                            }

                            if (password != confirm) {
                              confirmPasswordError.value =
                                  'Passwords do not match';
                              return;
                            }

                            // Save password to state and move to next step
                            vm.savePasswordAndContinue(password: password);
                            vm.goToNextStep();
                            context.push('/signup-three');
                          } : null,
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
                                    context.go('/login');
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

/// A widget that displays a checklist of password strength requirements.
class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPasswordRequirement(
          "At least 8 characters",
          password.length >= 8,
          context,
        ),
        const SizedBox(height: 8),
        _buildPasswordRequirement(
          "1 uppercase letter",
          password.contains(RegExp(r'[A-Z]')),
          context,
        ),
        const SizedBox(height: 8),
        _buildPasswordRequirement(
          "1 number",
          password.contains(RegExp(r'[0-9]')),
          context,
        ),
        const SizedBox(height: 8),
        _buildPasswordRequirement(
          "1 special character",
          password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]')),
          context,
        ),
      ],
    );
  }

  /// Utility for building a password requirement checklist item
  Widget _buildPasswordRequirement(
    String label,
    bool fulfilled,
    BuildContext context,
  ) {
    return Row(
      children: [
        Icon(
          fulfilled ? Icons.check_circle : Icons.radio_button_unchecked,
          color: fulfilled
              ? Theme.of(context).primaryColor
              : Theme.of(context).disabledColor,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
