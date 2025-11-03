import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/use_cases/wallet/forgot_pin_use_case.dart';
import 'package:poplar_power/domain/use_cases/wallet/reset_pin_use_case.dart';

/// Enum to represent the different steps of the password recovery flow.
enum PinRecoveryStep { enterOtp, enterNewPin, confirmNewPin }

/// State class for PinRecoveryViewModel.
class PinRecoveryState {
  final PinRecoveryStep step;
  final AsyncValue<void> status;
  final String? errorMessage;
  final String? accountNo;
  final String? otp;
  final String? newPin;
  final String? confirmPin;
  final bool pinResetSuccess;
  final int currentStep;

  PinRecoveryState({
    this.step = PinRecoveryStep.enterOtp,
    this.status = const AsyncData(null),
    this.errorMessage,
    this.accountNo,
    this.otp,
    this.newPin,
    this.confirmPin,
    this.currentStep = 1,
    this.pinResetSuccess = false,
  });

  PinRecoveryState copyWith({
    PinRecoveryStep? step,
    AsyncValue<void>? status,
    String? errorMessage,
    String? accountNo,
    String? otp,
    String? newPin,
    String? confirmPin,
    bool? pinResetSuccess,
    int? currentStep,
  }) {
    return PinRecoveryState(
      step: step ?? this.step,
      status: status ?? this.status,
      errorMessage: errorMessage,
      accountNo: accountNo ?? this.accountNo,
      otp: otp ?? this.otp,
      newPin: newPin ?? this.newPin,
      confirmPin: confirmPin ?? this.confirmPin,
      currentStep: currentStep ?? this.currentStep,
      pinResetSuccess: pinResetSuccess ?? this.pinResetSuccess,
    );
  }

  double get progress => currentStep / 3.0;
}

class PinRecoveryViewModel extends StateNotifier<PinRecoveryState> {
  final ForgotPinUseCase _forgotPinUseCase;
  final ResetPinUseCase _resetPinUseCase;

  PinRecoveryViewModel(this._forgotPinUseCase, this._resetPinUseCase)
    : super(PinRecoveryState());

  void goToNextStep() {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void goToPreviousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  double get progress => state.currentStep / 3.0;

  void initializeAccount(String? accountNo) {
    if (accountNo != null) {
      state = state.copyWith(accountNo: accountNo);
      // Automatically send OTP if accountNo is pre-filled
      sendOtp(accountNo);
    }
  }

  void saveOtpAndContinue(String otp) {
    state = state.copyWith(otp: otp);
  }

  void saveNewPinAndContinue(String newPin) {
    state = state.copyWith(newPin: newPin);
  }

  void saveConfirmPinAndContinue(String confirmPin) {
    state = state.copyWith(confirmPin: confirmPin);
  }

  /// Requests an OTP to be sent to the provided accountNo.
  Future<void> sendOtp(String accountNo) async {
    state = state.copyWith(status: const AsyncLoading(), accountNo: accountNo);
    final result = await _forgotPinUseCase.execute(accountNo);
    result.fold(
      ifLeft: (failure) => state = state.copyWith(
        status: AsyncError(failure.message, StackTrace.current),
        errorMessage: failure.message,
      ),
      ifRight: (_) => state = state.copyWith(
        status: const AsyncData(null),
        errorMessage: null,
      ),
    );
  }

  /// Verifies the OTP and resets the password.
  Future<void> resetPin({
    required String accountNo,
  }) async {
    if (state.accountNo == null || state.otp == null || state.newPin == null) {
      state = state.copyWith(
        status: AsyncError('Missing account number, OTP, or new PIN.', StackTrace.current),
        errorMessage: 'Missing account number, OTP, or new PIN.',
      );
      return;
    }

    state = state.copyWith(status: const AsyncLoading());
    final result = await _resetPinUseCase.execute(
      state.accountNo!,
      state.otp!,
      state.newPin!,
    );

    result.fold(
      ifLeft: (failure) => AsyncError(failure.message, StackTrace.current),
      ifRight: (_) => state = state.copyWith(pinResetSuccess: true),
    );
    /*state = state.copyWith(
      status: AsyncError(failure.message, StackTrace.current),
      errorMessage: failure.message,
    );*/
  }

  /// Resets the state to the initial accountNo entry step.
  void resetFlow() {
    state = PinRecoveryState();
  }

  /// Sets an error message.
  void setError(String? message) {
    state = state.copyWith(errorMessage: message);
  }
}

final pinRecoveryViewModelProvider =
    StateNotifierProvider.autoDispose<PinRecoveryViewModel, PinRecoveryState>((
      ref,
    ) {
      final forgotPinUseCase = ref.watch(forgotPinUseCaseProvider);
      final resetPinUseCase = ref.watch(resetPinUseCaseProvider);
      return PinRecoveryViewModel(forgotPinUseCase, resetPinUseCase);
    });
