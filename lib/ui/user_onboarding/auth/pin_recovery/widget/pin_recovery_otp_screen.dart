import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:poplar_power/ui/user_onboarding/auth/pin_recovery/viewmodel/pin_recovery_view_model.dart';
import 'package:poplar_power/ui/user_onboarding/auth/signup/widget/progressBar.dart';

class PinRecoveryScreen extends HookConsumerWidget {
  final String? initialAccountNo;

  const PinRecoveryScreen({super.key, this.initialAccountNo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

    final asset = isDarkTheme
        ? 'assets/dark_variant.png'
        : 'assets/login_screen_bg.png';

    final overlayColor = isDarkTheme
        ? const Color(0xFF1E293B).withValues(alpha:0.98)
        : Colors.white.withValues(alpha:0.3);

    final otpController = useTextEditingController();
    final otpError = useState<String?>(null);

    final vm = ref.read(pinRecoveryViewModelProvider.notifier);
    final state = ref.watch(pinRecoveryViewModelProvider);

    useEffect(() {
      Future(() => vm.initializeAccount(initialAccountNo));
      return null;
    }, [initialAccountNo]);

    ref.listen<PinRecoveryState>(pinRecoveryViewModelProvider, (
      previous,
      next,
    ) {
      if (next.errorMessage != null && next.status is! AsyncLoading) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
        vm.setError(null);
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
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 24),
                            onPressed: () {
                              context.go('/profile');
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
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
                            color: theme.textTheme.titleMedium?.color
                                ?.withValues(alpha:0.7),
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
                                  vm.saveOtpAndContinue(otp);
                                  vm.goToNextStep();
                                  context.push('/pin-recovery-new-pin');
                                },
                          style: FilledButton.styleFrom(
                            fixedSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: state.status is AsyncLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
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
                                  if (state.accountNo != null) {
                                    vm.sendOtp(state.accountNo!);
                                  } else {
                                    otpError.value =
                                        'Account not found to send OTP.';
                                  }
                                },
                          child: const Text("Resend OTP"),
                        ),
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
