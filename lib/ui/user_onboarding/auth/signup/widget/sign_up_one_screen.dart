// lib/ui/auth/widgets/signup_step1_screen.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../viewmodel/signup_view_model.dart';

/// Step 1 of the Signup process
///
/// Collects:
/// - First name
/// - Last name
/// - Email address
///
/// Validation is handled by the [SignupViewModel].
class SignupStep1Screen extends HookConsumerWidget {
  const SignupStep1Screen({super.key});

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

    // Form controllers
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final emailController = useTextEditingController();

    // Holds validation errors for each field
    final errors = useState<Map<String, String>>({});

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
                      // Main heading
                      Text(
                        "Create your account",
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Subheading
                      Text(
                        "Start by telling us who you are",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.textTheme.titleMedium?.color?.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  //Input fields
                  Column(
                    children: [
                      // First Name field
                      TextField(
                        controller: firstNameController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          errorText: errors.value['firstName'],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),

                      const SizedBox(height: 20),

                      // Last Name field
                      TextField(
                        controller: lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          errorText: errors.value['lastName'],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),

                      const SizedBox(height: 20),

                      // Email field
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          errorText: errors.value['email'],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // "Next" button
                  FilledButton(
                    onPressed: () {
                      final validationErrors = ref
                          .read(signupViewModelProvider.notifier)
                          .validateAndSaveStep1(
                            firstName: firstNameController.text.trim(),
                            lastName: lastNameController.text.trim(),
                            email: emailController.text.trim(),
                          );

                      if (validationErrors != null) {
                        errors.value = validationErrors;
                      } else {
                        errors.value = {}; // Clear errors
                        context.push('/signup-two');
                      }
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
                      style: theme.textTheme.bodyMedium, // Default text style for the sentence
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
}