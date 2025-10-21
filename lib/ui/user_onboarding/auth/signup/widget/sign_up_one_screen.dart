import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/ui/user_onboarding/auth/signup/widget/progressBar.dart';

import '../viewmodel/signup_view_model.dart';

/// Step 1 of the Signup process
///
/// Collects:
/// - First name
/// - Last name
/// - Email address
/// - Phone number
/// - Custom ref
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
    final phoneController = useTextEditingController();
    final customRefController = useTextEditingController();

    // Holds validation errors for each field
    final errors = useState<Map<String, String>>({});

    // Watch the signup state for progress
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
                            onPressed: () => context.go('/get-started'),
                          ),
                        ),

                        //Upper section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            // Main heading
                            Text(
                              "Welcome — let's set you up",
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Subheading
                            Text(
                              "Tell us who you are and we'll do the rest",
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.textTheme.titleMedium?.color
                                    ?.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        //Input fields
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
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

                                const SizedBox(height: 16),

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

                                const SizedBox(height: 16),

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

                                const SizedBox(height: 16),

                                // Phone number field
                                TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 11,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number',
                                    errorText: errors.value['phoneNumber'],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                const Divider(),

                                const SizedBox(height: 24),

                                // Custom Ref field
                                TextField(
                                  controller: customRefController,
                                  decoration: InputDecoration(
                                    labelText: 'Referral Code (Optional)',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // "Next" button
                        FilledButton(
                          onPressed: () {
                            final validationErrors = vm.validateAndSaveStep1(
                              firstName: firstNameController.text.trim(),
                              lastName: lastNameController.text.trim(),
                              email: emailController.text.trim(),
                              phoneNumber: phoneController.text.trim(),
                              customRef: customRefController.text.trim(),
                            );

                            if (validationErrors != null) {
                              errors.value = validationErrors;
                            } else {
                              errors.value = {}; // Clear errors
                              vm.goToNextStep();
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
