import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            context.go('/login');
          },
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: const Text(''),
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                "OTP Verification",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Enter the OTP we sent to $email",
                textAlign: TextAlign.start,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              OtpForm(email: email, password: password),
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
    );
  }
}

class OtpForm extends HookConsumerWidget {
  final String email;
  final String password;

  const OtpForm({super.key, required this.email, required this.password});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final otpFields = useMemoized(
      () => List.generate(6, (index) => FocusNode()),
    );
    final otpValues = useState(List.generate(6, (index) => ''));

    final viewModel = ref.read(otpViewModelProvider.notifier);
    final state = ref.watch(otpViewModelProvider);

    void onOtpChanged(String value, int index) {
      otpValues.value[index] = value;
      if (value.isNotEmpty && index < 5) {
        FocusScope.of(context).requestFocus(otpFields[index + 1]);
      } else if (value.isEmpty && index > 0) {
        FocusScope.of(context).requestFocus(otpFields[index - 1]);
      }
    }

    return Form(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              6,
              (index) => SizedBox(
                height: 64,
                width: 48,
                child: TextFormField(
                  focusNode: otpFields[index],
                  onChanged: (value) => onOtpChanged(value, index),
                  textInputAction: index == 5
                      ? TextInputAction.done
                      : TextInputAction.next,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "0",
                    hintStyle: TextStyle(
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.primary),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: state is AsyncLoading
                ? null
                : () {
                    final otp = otpValues.value.join();
                    if (otp.length == 6) {
                      viewModel.verifyOtp(email, password, otp);
                    }
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
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  )
                : const Text("Continue"),
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
