// lib/ui/auth/widgets/signup_step1_screen.dart

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../viewmodel/signup_view_model.dart';

/// Regex pattern to validate standard email formats.
final _emailRegex = RegExp(
  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
);

/// Step 1 of the Signup process
///
/// Collects:
/// - First name
/// - Last name
/// - Email address
///
/// If email is invalid on submit:
/// - Red border is applied
/// - Field shakes slightly
/// - Message disappears after 2 seconds
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
        ? Color(0xFF1E293B).withOpacity(0.98)
        : Colors.white.withOpacity(0.3);

    // Form controllers
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final emailController = useTextEditingController();

    // Controls for email validation animation and message
    final emailError = useState<String?>(null);
    final animateError = useState(false);

    // Controls name validation
    final firstNameError = useState<String?>(null);
    final lastNameError = useState<String?>(null);

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
                          color: theme.textTheme.titleMedium?.color?.withOpacity(0.7),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: firstNameError.value != null ? Colors.red : Colors.black26,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: firstNameError.value != null ? Colors.red : Colors.black26,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: firstNameError.value != null ? Colors.red : theme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                      if (firstNameError.value != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              firstNameError.value!,
                              style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ),


                      const SizedBox(height: 20),


                      // Last Name field
                      TextField(
                        controller: lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: lastNameError.value != null ? Colors.red : Colors.black26,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: lastNameError.value != null ? Colors.red : Colors.black26,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: lastNameError.value != null ? Colors.red : theme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                      if (lastNameError.value != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              lastNameError.value!,
                              style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ),


                      const SizedBox(height: 20),


                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        transform: animateError.value
                            ? Matrix4.translationValues(6, 0, 0)
                            : Matrix4.identity(),
                        curve: Curves.elasticIn,

                        child: TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            // Show red border if error exists
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: emailError.value != null
                                    ? Colors.red
                                    : Colors.black26,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: emailError.value != null
                                    ? Colors.red
                                    : Colors.black26,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: emailError.value != null
                                    ? Colors.red
                                    : theme.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Error message (if any)
                      if (emailError.value != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              emailError.value!,
                              style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const Spacer(),

                  // "Next" button
                  FilledButton(
                    onPressed: () {
                      final email = emailController.text.trim();
                      final firstName = firstNameController.text.trim();
                      final lastName = lastNameController.text.trim();

                      bool hasError = false;

                      // First Name validation
                      if (firstName.isEmpty) {
                        firstNameError.value = "First name is required";
                        hasError = true;
                      } else {
                        firstNameError.value = null;
                      }

                      // Last Name validation
                      if (lastName.isEmpty) {
                        lastNameError.value = "Last name is required";
                        hasError = true;
                      } else {
                        lastNameError.value = null;
                      }

                      // Email format validation
                      final isValidEmail = _emailRegex.hasMatch(email);
                      if (!isValidEmail) {
                        emailError.value = "Invalid email format";
                        animateError.value = true;

                        Future.delayed(const Duration(milliseconds: 80), () {
                          animateError.value = false;
                        });

                        Timer(const Duration(seconds: 2), () {
                          emailError.value = null;
                          firstNameError.value = null;
                          lastNameError.value = null;
                        });

                        hasError = true;
                      }

                      if (hasError) return; // Don't continue if there are any field errors

                      // Save valid data to ViewModel
                      ref.read(signupViewModelProvider.notifier).saveStep1(
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                      );

                      // Go to next step
                      context.push('/signup-two');
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
}
