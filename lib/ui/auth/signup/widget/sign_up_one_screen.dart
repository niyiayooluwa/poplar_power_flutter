// lib/ui/auth/widgets/signup_step1_screen.dart

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../viewmodel/signup_view_model.dart';

/// Signup Step 1 Screen
///
/// Collects:
/// - First name
/// - Last name
/// - Email
///
/// On success, navigates to the second step of signup.
final _emailRegex = RegExp(
  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
);

class SignupStep1Screen extends HookConsumerWidget {
  const SignupStep1Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Text controllers for the first step fields
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final emailController = useTextEditingController();

    //Local error state
    final emailError = useState<String?>(null);
    final animateError = useState(false);


    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 80),

              const Align(
                alignment: Alignment.centerLeft,
                child: FlutterLogo(size: 50),
              ),

              const SizedBox(height: 20),

              Text(
                "Create your account",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  //color: Colors.black,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Start by telling us who you are",
                style: theme.textTheme.titleMedium?.copyWith(
                  //color: Colors.black54,
                ),
              ),

              const SizedBox(height: 48),

              // First Name
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),

              const SizedBox(height: 20),

              // Last Name
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),

              // Email
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                transform: animateError.value
                    ? Matrix4.translationValues(0, -10, 0)
                    : Matrix4.identity(),
                curve: Curves.elasticIn,
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: emailError.value != null
                        ? OutlineInputBorder(borderSide: const BorderSide(color:Colors.red))
                        : const OutlineInputBorder(),
                    focusedBorder: emailError.value != null ?
                      OutlineInputBorder(
                        borderSide: const BorderSide(color:Colors.red)
                      ): null
                  ),
                ),
              ),

              const Spacer(),

              FilledButton(
                onPressed: () {
                  final email = emailController.text.trim();
                  final isValid = _emailRegex.hasMatch(email);

                  if (!isValid) {
                    emailError.value = "Invalid email format";
                    animateError.value = true;

                    Future.delayed(const Duration(milliseconds: 100), () {
                      animateError.value = false;
                    });

                    Timer(const Duration(seconds: 2), () {
                      emailError.value = null;
                    });
                    return;
                  }

                  // Save to ViewModel
                  ref.read(signupViewModelProvider.notifier).saveStep1(
                    firstName: firstNameController.text.trim(),
                    lastName: lastNameController.text.trim(),
                    email: email,
                  );

                  // Navigate to next screen
                  context.push('/signup-two');
                },
                style: FilledButton.styleFrom(
                  fixedSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Next"),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
