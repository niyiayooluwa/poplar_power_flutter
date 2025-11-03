import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/use_cases/auth/password_recovery_use_case.dart';
import 'package:poplar_power/domain/use_cases/auth/resend_user_otp_use_case.dart';

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
  final bool passwordResetSuccess;
  final int currentStep;

  PasswordRecoveryState({
    this.step = PasswordRecoveryStep.enterEmail,
    this.status = const AsyncData(null),
    this.errorMessage,
    this.email,
    this.currentStep = 1,
    this.passwordResetSuccess = false,
  });

  PasswordRecoveryState copyWith({
    PasswordRecoveryStep? step,
    AsyncValue<void>? status,
    String? errorMessage,
    String? email,
    bool? passwordResetSuccess,
    int? currentStep,
  }) {
    return PasswordRecoveryState(
      step: step ?? this.step,
      status: status ?? this.status,
      errorMessage: errorMessage,
      email: email ?? this.email,
      currentStep: currentStep ?? this.currentStep,
      passwordResetSuccess: passwordResetSuccess ?? this.passwordResetSuccess,
    );
  }

  double get progress => currentStep / 3.0;
}

class PasswordRecoveryViewModel extends StateNotifier<PasswordRecoveryState> {
  final ResendUserOtpUseCase _resendUserOtpUseCase;
  final PasswordRecoveryUseCase _passwordRecoveryUseCase;

  PasswordRecoveryViewModel(
    this._resendUserOtpUseCase,
    this._passwordRecoveryUseCase,
  ) : super(PasswordRecoveryState());

  void goToNextStep() {
    if (state.currentStep < 3) {
      // Update state immutably
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void goToPreviousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

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
    final result = await _resendUserOtpUseCase.execute(email);
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
  })
  async {
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
        errorMessage: null,
        passwordResetSuccess: true,
      );
    }  }

  /// Verifies the OTP.
  void verifyOtp(String otp) {
    state = state.copyWith(step: PasswordRecoveryStep.enterNewPassword);
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
  final resendUserOtpUseCase = ref.watch(resendUserOtpUseCaseProvider);
  final passwordRecoveryUseCase = ref.watch(passwordRecoveryUseCaseProvider);
  return PasswordRecoveryViewModel(resendUserOtpUseCase, passwordRecoveryUseCase);
});
