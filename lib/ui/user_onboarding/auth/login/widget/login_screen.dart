// lib/ui/auth/widgets/login_screen.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../viewmodel/login_view_model.dart';

/// Login screen with mocked authentication logic using [LoginViewModel].
///
/// Provides:
/// - Email & password fields
/// - Login button with loading state
/// - Error display if credentials are wrong
class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Text editing controllers
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    // State for obscuring password field
    final obscurePassword = useState(true);

    // Watch the auth state
    final authState = ref.watch(loginViewModelProvider);

    // Listen for navigation side-effects
    ref.listen<AsyncValue<void>>(loginViewModelProvider, (_, state) {
      if (state is AsyncData && !state.hasError) {
        context.go('/home');
      }
      if (state is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error.toString())),
        );
      }
    });

    //Theme
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;
    final asset = isDarkTheme
        ? 'assets/dark_variant.png'
        : 'assets/login_screen_bg.png';
    final overlayColor = isDarkTheme
        ? const Color(0xFF1E293B).withValues(alpha: 0.98)
        : Colors.white.withValues(alpha: 0.3);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(asset, fit: BoxFit.cover),
            ),
          ),

          Container(color: overlayColor),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 80),
                  const _TopSection(),
                  const SizedBox(height: 48),

                  //Input Fields
                  Column(
                    children: [
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password field with visibility toggle
                      TextField(
                        controller: passwordController,
                        obscureText: obscurePassword.value,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () => obscurePassword.value =
                                !obscurePassword.value,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            // TODO: Implement forgot password
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  //Login Button
                  FilledButton(
                    onPressed: authState.isLoading
                        ? null
                        : () {
                            ref.read(loginViewModelProvider.notifier).login(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );
                          },
                    style: FilledButton.styleFrom(
                      fixedSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: authState.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Login',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),

                  const Spacer(),

                  //Don't have an account?
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: <TextSpan>[
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: 'Create one here',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.go('/signup');
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
        ],
      ),
    );
  }
}

class _TopSection extends StatelessWidget {
  const _TopSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FlutterLogo(size: 50),

        const SizedBox(height: 20),

        Text(
          "Good to see you again 👋",
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "Continue with smarter payments, fewer delays,\nand total control",
          textAlign: TextAlign.start,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}