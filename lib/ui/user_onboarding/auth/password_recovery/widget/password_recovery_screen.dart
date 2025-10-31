import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:poplar_power/ui/user_onboarding/auth/password_recovery/viewmodel/password_recovery_view_model.dart';
import 'package:poplar_power/ui/user_onboarding/auth/signup/widget/progressBar.dart';
import 'package:poplar_power/ui/user_onboarding/auth/signup/widget/sign_up_two_screen.dart';
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

    final passwordVisible = useState(false);
    final confirmPasswordVisible = useState(false);

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
      if (next.passwordResetSuccess) {
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
            "Recover your Account",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Enter the email linked to your account. We’ll send you a code to reset your password.",
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
                    vm.goToNextStep();
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
                    "Send code",
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
            "Verify your identity",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Enter the 6-digit code we sent to your email.",
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.textTheme.titleMedium?.color?.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),

          PinCodeTextField(
            appContext: context,
            length: 6,
            obscureText: true,
            obscuringCharacter: '●',
            animationType: AnimationType.fade,
            controller: otpController,
            keyboardType: TextInputType.number,
            textStyle: theme.textTheme.headlineMedium,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(8),
              fieldHeight: 60,
              fieldWidth: 52,
              activeFillColor: Colors.white,
              inactiveFillColor: isDarkTheme
                  ? Colors.grey[800]!
                  : Colors.grey[200]!,
              selectedFillColor: Colors.blue.shade50,
              activeColor: Colors.blue,
              inactiveColor: Colors.grey,
              selectedColor: Colors.blue,
            ),
            animationDuration: const Duration(milliseconds: 300),
            enableActiveFill: true,
            onChanged: (value) {
              otpError.value = null;
            },
            errorTextSpace: 30,
          ),

          const SizedBox(height: 24),

          FilledButton(
            onPressed: state.status is AsyncLoading
                ? null
                : () {
                    final otp = otpController.text.trim();

                    if (otp.isEmpty) {
                      otpError.value = 'PIN is required';
                      return;
                    }

                    if (otp.length != 6) {
                      otpError.value = 'OTP must be 6 digits';
                      return;
                    }
                    // Move to next step (new password input)
                    vm.goToNextStep();
                    vm.verifyOtp(otp);
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
                    "Verify",
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
            "Choose a strong password you haven’t used before.",
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.textTheme.titleMedium?.color?.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),

          TextField(
            controller: newPasswordController,
            onChanged: (value) => newPasswordError.value = null,
            obscureText: !passwordVisible.value,
            decoration: InputDecoration(
              labelText: 'New Password',
              errorText: newPasswordError.value,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  passwordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () => passwordVisible.value = !passwordVisible.value,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: PasswordStrengthIndicator(
              password: useValueListenable(newPasswordController).text,
            ),
          ),

          const SizedBox(height: 24),

          TextField(
            controller: confirmPasswordController,
            onChanged: (value) => confirmPasswordError.value = null,
            obscureText: !confirmPasswordVisible.value,
            decoration: InputDecoration(
              labelText: 'Confirm New Password',
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
                onPressed: () => confirmPasswordVisible.value =
                    !confirmPasswordVisible.value,
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

                    final validation = validatePassword(newPassword);
                    if (validation != null) {
                      newPasswordError.value = validation;
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

                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 24),
                            onPressed: () {
                              if (state.step ==
                                  PasswordRecoveryStep.enterEmail) {
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
                                PasswordRecoveryStep.enterOtp =>
                                  buildOtpInput(),
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
