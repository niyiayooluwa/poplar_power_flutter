// lib/ui/auth/widgets/signup_step2_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../viewmodel/signup_view_model.dart';

/// Signup Step 2 Screen
///
/// Collects:
/// - Password
/// - Confirm Password
/// - Custom Ref (optional)
///
/// Submits to the mocked signup service.
class SignupStep2Screen extends HookConsumerWidget {
  const SignupStep2Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final customRefController = useTextEditingController();

    final obscurePassword = useState(true);
    final obscureConfirm = useState(true);

    final signupState = ref.watch(signupViewModelProvider);

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
                "Set your credentials",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Just a few more details",
                style: theme.textTheme.titleMedium
              ),

              const SizedBox(height: 48),

              TextField(
                controller: passwordController,
                obscureText: obscurePassword.value,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword.value ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => obscurePassword.value = !obscurePassword.value,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: confirmPasswordController,
                obscureText: obscureConfirm.value,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirm.value ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => obscureConfirm.value = !obscureConfirm.value,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: customRefController,
                decoration: const InputDecoration(
                  labelText: 'Custom Ref (optional)',
                  border: OutlineInputBorder(),
                ),
              ),

              const Spacer(),

              FilledButton(
                onPressed: signupState is AsyncLoading
                    ? null
                    : () {
                  // Call viewmodel signup logic
                  ref.read(signupViewModelProvider.notifier).signup(
                    password: passwordController.text.trim(),
                    confirmPassword: confirmPasswordController.text.trim(),
                    customRef: customRefController.text.trim(),
                    onSuccess: () => context.go('/home'),
                  );
                },
                style: FilledButton.styleFrom(
                  fixedSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: signupState is AsyncLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text("Sign Up"),
              ),

              const SizedBox(height: 12),

              if (signupState is AsyncError)
                Text(
                  signupState.error.toString(),
                  style: const TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
