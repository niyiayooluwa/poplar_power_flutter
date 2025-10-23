import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/use_cases/auth/resend_otp_use_case.dart';
import 'package:poplar_power/domain/use_cases/auth/password_recovery_use_case.dart';

/// Enum to represent the different steps of the password recovery flow.
enum PasswordRecoveryStep {
  enterEmail,
  enterOtp,
  enterNewPassword,
}

/// State class for PasswordRecoveryViewModel.
class PasswordRecoveryState {
  final PasswordRecoveryStep step;
  final AsyncValue<void> status;
  final String? errorMessage;
  final String? email;

  PasswordRecoveryState({
    this.step = PasswordRecoveryStep.enterEmail,
    this.status = const AsyncData(null),
    this.errorMessage,
    this.email,
  });

  PasswordRecoveryState copyWith({
    PasswordRecoveryStep? step,
    AsyncValue<void>? status,
    String? errorMessage,
    String? email,
  }) {
    return PasswordRecoveryState(
      step: step ?? this.step,
      status: status ?? this.status,
      errorMessage: errorMessage,
      email: email ?? this.email,
    );
  }
}

class PasswordRecoveryViewModel extends StateNotifier<PasswordRecoveryState> {
  final ResendOtpUseCase _resendOtpUseCase;
  final PasswordRecoveryUseCase _passwordRecoveryUseCase;

  PasswordRecoveryViewModel(
    this._resendOtpUseCase,
    this._passwordRecoveryUseCase,
  ) : super(PasswordRecoveryState());

  /// Sets the initial email if provided (for 'Change Password' flow).
  void initializeEmail(String? email) {
    if (email != null) {
      state = state.copyWith(email: email, step: PasswordRecoveryStep.enterOtp);
      // Automatically send OTP if email is pre-filled
      sendOtp(email);
    }
  }

  /// Requests an OTP to be sent to the provided email.
  Future<void> sendOtp(String email) async {
    state = state.copyWith(status: const AsyncLoading(), email: email);
    final result = await _resendOtpUseCase.execute(email);
    result.fold(
      ifLeft: (failure) => state = state.copyWith(
        status: AsyncError(failure.message, StackTrace.current),
        errorMessage: failure.message,
      ),
      ifRight: (_) => state = state.copyWith(
        status: const AsyncData(null),
        step: PasswordRecoveryStep.enterOtp,
        errorMessage: null,
      ),
    );
  }

  /// Verifies the OTP and resets the password.
  Future<void> resetPassword({
    required String otp,
    required String newPassword,
  }) async {
    if (state.email == null) {
      state = state.copyWith(
        status: AsyncError('Email not found.', StackTrace.current),
        errorMessage: 'Email not found.',
      );
      return;
    }

    state = state.copyWith(status: const AsyncLoading());
    final failure = await _passwordRecoveryUseCase.execute(
      state.email!,
      otp,
      newPassword,
    );

    if (failure != null) {
      state = state.copyWith(
        status: AsyncError(failure.message, StackTrace.current),
        errorMessage: failure.message,
      );
    } else {
      state = state.copyWith(
        status: const AsyncData(null),
        step: PasswordRecoveryStep.enterNewPassword, // This step is actually the final success state
        errorMessage: null,
      );
    }  }

  /// Moves to the next step in the flow.
  void nextStep() {
    if (state.step == PasswordRecoveryStep.enterEmail) {
      state = state.copyWith(step: PasswordRecoveryStep.enterOtp);
    } else if (state.step == PasswordRecoveryStep.enterOtp) {
      state = state.copyWith(step: PasswordRecoveryStep.enterNewPassword);
    }
  }

  /// Resets the state to the initial email entry step.
  void resetFlow() {
    state = PasswordRecoveryState();
  }

  /// Sets an error message.
  void setError(String? message) {
    state = state.copyWith(errorMessage: message);
  }
}

final passwordRecoveryViewModelProvider = StateNotifierProvider.autoDispose<
    PasswordRecoveryViewModel, PasswordRecoveryState>((ref) {
  final resendOtpUseCase = ref.watch(resendOtpUseCaseProvider);
  final passwordRecoveryUseCase = ref.watch(passwordRecoveryUseCaseProvider);
  return PasswordRecoveryViewModel(resendOtpUseCase, passwordRecoveryUseCase);
});
