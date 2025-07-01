import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../viewmodel/signup_view_model.dart';

class SignupStep2Screen extends HookConsumerWidget {
  const SignupStep2Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final customRefController = useTextEditingController();

    final passwordVisible = useState(false);
    final confirmPasswordVisible = useState(false);

    final passwordError = useState<String?>(null);
    final confirmError = useState<String?>(null);

    // Tracks which password rules are met
    final hasMinLength = useState(false);
    final hasUppercase = useState(false);
    final hasNumber = useState(false);
    final hasSpecial = useState(false);

    // Regex helpers
    bool hasUpper(String s) => RegExp(r'[A-Z]').hasMatch(s);
    bool hasNum(String s) => RegExp(r'[0-9]').hasMatch(s);
    bool hasSpecialChar(String s) => RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(s);

    void validatePassword(String value) {
      hasMinLength.value = value.length >= 8;
      hasUppercase.value = hasUpper(value);
      hasNumber.value = hasNum(value);
      hasSpecial.value = hasSpecialChar(value);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
                opacity: 0.4,
                child: Image.asset(
                  'assets/login_screen_bg.png',
                  fit: BoxFit.cover,
                )
            ),
          ),

          Container(color: Colors.white.withOpacity(0.3),),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //Upper section
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 80),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: FlutterLogo(size: 50),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Secure your account",
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Enter a strong password and custom ref",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.textTheme.titleMedium?.color?.withOpacity(0.7),
                          ),
                        ),
                      ]
                  ),

                  const SizedBox(height: 32),

                  //Input Fields
                  Column(
                    children: [
                      // Password input
                      TextField(
                        controller: passwordController,
                        obscureText: !passwordVisible.value,
                        onChanged: validatePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible.value ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () => passwordVisible.value = !passwordVisible.value,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Password strength rules
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPasswordRequirement("At least 8 characters", hasMinLength.value, context),
                            _buildPasswordRequirement("1 uppercase letter", hasUppercase.value, context),
                            _buildPasswordRequirement("1 number", hasNumber.value, context),
                            _buildPasswordRequirement("1 special character", hasSpecial.value, context),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Confirm password
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: !confirmPasswordVisible.value,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              confirmPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () => confirmPasswordVisible.value = !confirmPasswordVisible.value,
                          ),
                        ),
                      ),

                      if (confirmError.value != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            confirmError.value!,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Custom Ref (optional or required based on backend)
                      TextField(
                        controller: customRefController,
                        decoration: const InputDecoration(
                          labelText: 'Custom Ref (optional)',
                          border: OutlineInputBorder(),
                        ),
                      )
                    ]
                  ),

                  const Spacer(),

                  // Submit button
                  FilledButton(
                    onPressed: () {
                      final password = passwordController.text;
                      final confirm = confirmPasswordController.text;

                      // Validate password rules
                      if (!(hasMinLength.value &&
                          hasUppercase.value &&
                          hasNumber.value &&
                          hasSpecial.value)) {
                        passwordError.value = "Weak password.";
                        return;
                      }

                      // Check match
                      if (password != confirm) {
                        confirmError.value = "Passwords do not match";
                        Timer(const Duration(seconds: 2), () {
                          confirmError.value = null;
                        });
                        return;
                      }

                      // Send to mock ViewModel
                      ref.read(signupViewModelProvider.notifier).signup(
                        password: password,
                        confirmPassword: confirm,
                        customRef: customRefController.text.trim(),
                        onSuccess: () {context.go('/home');},
                      );

                      // Go to home screen
                      context.go('/home');
                    },
                    style: FilledButton.styleFrom(
                      fixedSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Sign Up"),
                  ),

                  const SizedBox(height: 16),

                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                      ), // Default text style for the sentence
                      children: <TextSpan> [
                        const TextSpan(text: "Already have an account? "),
                        TextSpan(
                          text: 'Login here',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline, // Optional: underline it
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {context.go('/login');},
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center, // Optional: if you want the whole text centered
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ]
      ),
    );
  }

  /// Utility for building a password requirement checklist item
  Widget _buildPasswordRequirement(String label, bool fulfilled, BuildContext context) {
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
