import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:poplar_power/ui/user_onboarding/auth/signup/widget/progressBar.dart';
import 'package:poplar_power/ui/user_onboarding/otp/viewmodel/otp_view_model.dart';
import 'package:poplar_power/ui/user_onboarding/otp/viewmodel/resend_otp_view_model.dart';

class OtpScreen extends HookConsumerWidget {
  final String email;
  final String password;

  const OtpScreen({super.key, required this.email, required this.password});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final resendOtpViewModel = ref.read(resendOtpViewModelProvider.notifier);

    final isDarkTheme = theme.brightness == Brightness.dark;

    final otpController = useTextEditingController();
    final otpError = useState<String?>(null);

    final viewModel = ref.read(otpViewModelProvider.notifier);
    final state = ref.watch(otpViewModelProvider);

    final asset = isDarkTheme
        ? 'assets/dark_variant.png'
        : 'assets/login_screen_bg.png';
    final overlayColor = isDarkTheme
        ? const Color(0xFF1E293B).withValues(alpha: 0.98)
        : Colors.white.withValues(alpha: 0.3);

    ref.listen<AsyncValue<void>>(otpViewModelProvider, (previous, next) {
      next.when(
        data: (_) {
          context.go('/home');
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
        loading: () {},
      );
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
              ProgressBar(progress: 1),

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

                        // Back Button
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 24),
                            onPressed: () {
                              context.go('/login');
                            },
                          ),
                        ),

                        //Upper section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),

                            Text(
                              "Verify your Email",
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "Enter the 6-digit code we sent to your inbox.",
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.textTheme.titleMedium?.color
                                    ?.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // PIN Input
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
                                  animationDuration: const Duration(
                                    milliseconds: 300,
                                  ),
                                  enableActiveFill: true,
                                  onChanged: (value) {
                                    otpError.value = null;
                                  },
                                  errorTextSpace: 30,
                                ),

                                //,

                                // Info message
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isDarkTheme
                                        ? Colors.blue.shade900.withValues(
                                            alpha: 0.2,
                                          )
                                        : Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,

                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.blue.shade600,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          "Not in your mailbox? Check your spam folder.",
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 24),

                                ResendOtpSection(
                                  onPressed: () {
                                    resendOtpViewModel.resendOtp(email);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        FilledButton(
                          onPressed: () {
                            state is AsyncLoading;

                            final otp = otpController.text.trim();

                            if (otp.isEmpty) {
                              otpError.value = 'OTP is required';
                              return;
                            }

                            if (otp.length != 6) {
                              otpError.value = 'OTP must be 6 digits';
                              return;
                            }

                            viewModel.verifyOtp(email, password, otp);
                          },
                          style: FilledButton.styleFrom(
                            elevation: 0,
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: ref.watch(otpViewModelProvider) is AsyncLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                )
                              : const Text("Continue"),
                        ),

                        const SizedBox(height: 24),

                        //OtpForm(email: email, password: password),
                        // const SizedBox(height: 24),
                        /*ResendOtpSection(
                          onPressed: () {
                            resendOtpViewModel.resendOtp(email);
                          },
                        ),*/
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

class ResendOtpSection extends HookConsumerWidget {
  final Function onPressed;

  const ResendOtpSection({super.key, required this.onPressed});

  static const int _initialCountdownSeconds = 5 * 60;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final resendOtpState = ref.watch(resendOtpViewModelProvider);

    ref.listen<AsyncValue<void>>(resendOtpViewModelProvider, (previous, next) {
      next.when(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('A new OTP has been sent.')),
          );
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
        loading: () {},
      );
    });

    final countdownSeconds = useState<int>(_initialCountdownSeconds);
    final canResend = useState<bool>(false);
    final timerRef = useRef<Timer?>(null);

    void startTimer() {
      canResend.value = false;
      countdownSeconds.value = _initialCountdownSeconds;
      timerRef.value?.cancel();
      timerRef.value = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (countdownSeconds.value > 0) {
          countdownSeconds.value--;
        } else {
          timer.cancel();
          canResend.value = true;
        }
      });
    }

    useEffect(() {
      startTimer(); // Start the timer when the widget is first built

      // Return a cleanup function that cancels the timer when the widget is disposed
      return () {
        timerRef.value?.cancel();
      };
    }, const []);

    String getFormattedTime() {
      final minutes = (countdownSeconds.value ~/ 60).toString().padLeft(2, '0');
      final seconds = (countdownSeconds.value % 60).toString().padLeft(2, '0');
      return "$minutes:$seconds";
    }

    void handleResendOtp() {
      onPressed();
      startTimer();
    }

    return Row(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            canResend.value
                ? "Didn't receive the code?"
                : "The code expires in ${getFormattedTime()}",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (canResend.value)
          resendOtpState is AsyncLoading
              ? const CircularProgressIndicator()
              : InkWell(
                  onTap: canResend.value ? handleResendOtp : null,
                  child: Text(
                    "Request new code",
                    style: TextStyle(
                      color: canResend.value
                          ? theme.colorScheme.primary
                          : theme.disabledColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
      ],
    );
  }
}
