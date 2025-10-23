import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/ui/user_onboarding/auth/password_recovery/viewmodel/password_recovery_view_model.dart';
import 'package:poplar_power/utils/validators.dart';

class PasswordRecoveryScreen extends HookConsumerWidget {
  final String? initialEmail;

  const PasswordRecoveryScreen({super.key, this.initialEmail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

    final asset = isDarkTheme
        ? 'assets/dark_variant.png'
        : 'assets/login_screen_bg.png';

    final overlayColor = isDarkTheme
        ? const Color(0xFF1E293B).withValues(alpha: 0.98)
        : Colors.white.withValues(alpha: 0.3);

    final emailController = useTextEditingController(text: initialEmail);
    final otpController = useTextEditingController();
    final newPasswordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    final vm = ref.read(passwordRecoveryViewModelProvider.notifier);
    final state = ref.watch(passwordRecoveryViewModelProvider);

    final emailError = useState<String?>(null);
    final otpError = useState<String?>(null);
    final newPasswordError = useState<String?>(null);
    final confirmPasswordError = useState<String?>(null);

    useEffect(() {
      // Initialize email and step if initialEmail is provided (for Change Password' flow)
      vm.initializeEmail(initialEmail);
      return null;
    }, [initialEmail]);

    // Listen for errors from the ViewModel
    ref.listen<PasswordRecoveryState>(passwordRecoveryViewModelProvider, (
      previous,
      next,
    ) {
      if (next.errorMessage != null && next.status is! AsyncLoading) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
        // Clear error message after showing
        vm.setError(null);
      }
      // If password reset is successful, navigate to login
      if (next.status is AsyncData &&
          next.step == PasswordRecoveryStep.enterNewPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset successful! Please log in.'),
          ),
        );
        context.go('/login'); // Navigate to login after successful reset
      }
    });

    Widget buildEmailInput() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 24),

          Text(
            "Reset your Password",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Type in the email associated with your account",
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.textTheme.titleMedium?.color?.withValues(alpha: 0.7),
            ),
          ),

          const SizedBox(height: 32),

          TextField(
            controller: emailController,
            onChanged: (value) => emailError.value = null,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: emailError.value,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          const SizedBox(height: 24),

          FilledButton(
            onPressed: state.status is AsyncLoading
                ? null
                : () {
                    final email = emailController.text;
                    if (email.isEmpty) {
                      emailError.value = 'Email is required';
                      return;
                    }
                    final validationError = validateEmail(email);
                    if (validationError != null) {
                      emailError.value = 'Email is not valid';
                      return;
                    }
                    vm.sendOtp(email);
                  },
            style: FilledButton.styleFrom(
              fixedSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: state.status is AsyncLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    "Next",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      );
    }

    Widget buildOtpInput() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 24),

          Text(
            "Enter OTP",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "An OTP has been sent to ${state.email ?? 'your email'}. Please enter it below.",
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.textTheme.titleMedium?.color?.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: otpController,
            onChanged: (value) => otpError.value = null,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'OTP',
              errorText: otpError.value,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: state.status is AsyncLoading
                ? null
                : () {
                    final otp = otpController.text;
                    if (otp.isEmpty) {
                      otpError.value = 'OTP is required';
                      return;
                    }
                    // Move to next step (new password input)
                    vm.nextStep();
                  },
            style: FilledButton.styleFrom(
              fixedSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: state.status is AsyncLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    "Verify OTP",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: state.status is AsyncLoading
                ? null
                : () {
                    if (state.email != null) {
                      vm.sendOtp(state.email!); // Resend OTP
                    } else {
                      // Should not happen if flow is correct, but as a fallback
                      emailError.value = 'Email not found to resend OTP.';
                    }
                  },
            child: const Text("Resend OTP"),
          ),
        ],
      );
    }

    Widget buildNewPasswordInput() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 24),

          Text(
            "Set New Password",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Enter your new password below.",
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.textTheme.titleMedium?.color?.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: newPasswordController,
            onChanged: (value) => newPasswordError.value = null,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'New Password',
              errorText: newPasswordError.value,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: confirmPasswordController,
            onChanged: (value) => confirmPasswordError.value = null,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirm New Password',
              errorText: confirmPasswordError.value,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: state.status is AsyncLoading
                ? null
                : () {
                    final newPassword = newPasswordController.text;
                    final confirmPassword = confirmPasswordController.text;

                    if (newPassword.isEmpty) {
                      newPasswordError.value = 'New password is required';
                      return;
                    }
                    if (confirmPassword.isEmpty) {
                      confirmPasswordError.value =
                          'Confirm password is required';
                      return;
                    }
                    if (newPassword != confirmPassword) {
                      confirmPasswordError.value = 'Passwords do not match';
                      return;
                    }
                    // Add more password validation if needed
                    vm.resetPassword(
                      otp: otpController.text,
                      newPassword: newPassword,
                    );
                  },
            style: FilledButton.styleFrom(
              fixedSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: state.status is AsyncLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    "Reset Password",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      );
    }

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

          Column(
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 48),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 24),
                            onPressed: () {
                              if (state.step == PasswordRecoveryStep.enterEmail) {
                                context.pop();
                              } else {
                                vm.resetFlow(); // Go back to initial state
                              }
                            },
                          ),
                        ),

                        Expanded(
                          child: SingleChildScrollView(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: switch (state.step) {
                                PasswordRecoveryStep.enterEmail =>
                                  buildEmailInput(),
                                PasswordRecoveryStep.enterOtp => buildOtpInput(),
                                PasswordRecoveryStep.enterNewPassword =>
                                  buildNewPasswordInput(),
                              },
                            ), // AnimatedSwitcher
                          ), // SingleChildScrollView
                        ),
                        const SizedBox(height: 24),
                      ],
                    ), // Column
                  ), // Padding
                ), // SafeArea
              ),
            ],
          ),
        ],
      ),
    ); // Scaffold
  }
}
