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
    final customRefController = useTextEditingController();

    final passwordVisible = useState(false);
    final confirmPasswordVisible = useState(false);

    // Holds the current password validation error
    final passwordError = useState<String?>(null);

    // Listen to the signup state for errors or loading
    final signupState = ref.watch(signupViewModelProvider);

    ref.listen<AsyncValue<void>>(signupViewModelProvider, (_, state) {
      if (state is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error.toString())),
        );
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
                child: Image.asset(
                  asset,
                  fit: BoxFit.cover,
                )
            ),
          ),

          Container(color: overlayColor),

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
                            color: theme.textTheme.titleMedium?.color?.withValues(alpha: 0.7),
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
                        onChanged: (value) {
                          // Clear error on change
                          passwordError.value = null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          errorText: passwordError.value,
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
                        padding: const EdgeInsets.only(left: 8),
                        child: PasswordStrengthIndicator(password: useValueListenable(passwordController).text),
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
                    onPressed: signupState.isLoading ? null : () {
                      final password = passwordController.text;
                      final confirm = confirmPasswordController.text;
                      final customRef = customRefController.text.trim();

                      // Perform validation and signup
                      ref.read(signupViewModelProvider.notifier).signup(
                        password: password,
                        confirmPassword: confirm,
                        customRef: customRef,
                        onSuccess: () {
                          // Navigate on success
                          context.go('/home');
                        },
                      );
                    },
                    style: FilledButton.styleFrom(
                      fixedSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: signupState.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      "Sign Up",
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
                      children: <TextSpan> [
                        const TextSpan(text: "Already have an account? "),
                        TextSpan(
                          text: 'Login here',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {context.go('/login');},
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
        ]
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
        _buildPasswordRequirement(
          "1 uppercase letter",
          password.contains(RegExp(r'[A-Z]')),
          context,
        ),
        _buildPasswordRequirement(
          "1 number",
          password.contains(RegExp(r'[0-9]')),
          context,
        ),
        _buildPasswordRequirement(
          "1 special character",
          password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]')),
          context,
        ),
      ],
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
