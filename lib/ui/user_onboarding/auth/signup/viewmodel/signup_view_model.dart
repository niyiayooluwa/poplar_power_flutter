// Refactored ViewModel
import 'dart:ui';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/use_cases/auth/register_use_case.dart';
import 'package:poplar_power/ui/user_onboarding/auth/signup/viewmodel/signup_state.dart';
import 'package:poplar_power/utils/validators.dart';

class SignupViewModel extends StateNotifier<SignupState> {
  final RegisterUseCase _registerUseCase;

  // Initialize with the default state
  SignupViewModel(this._registerUseCase) : super(const SignupState());

  void goToNextStep() {
    if (state.currentStep < 4) {
      // Update state immutably
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void goToPreviousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void resetFlow() {
    state = const SignupState(); // Simply reset to the initial state
  }

  // Validation logic remains the same, but now it updates the state
  Map<String, String>? validateAndSaveStep1({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String customRef,
  }) {
    final errors = <String, String>{};
    // ... (all your validation logic is still valid here) ...
    final firstNameError = validateName(firstName);
    if (firstNameError != null) errors['firstName'] = firstNameError;

    final lastNameError = validateName(lastName);
    if (lastNameError != null) errors['lastName'] = lastNameError;

    final emailError = validateEmail(email);
    if (emailError != null) errors['email'] = emailError;

    final phoneNumberError = validatePhoneNumber(phoneNumber);
    if (phoneNumberError != null) errors['phoneNumber'] = phoneNumberError;

    if (errors.isNotEmpty) {
      return errors;
    }

    // If valid, update the state immutably
    state = state.copyWith(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      customRef: customRef,
    );

    return null; // Success
  }

  void savePasswordAndContinue({required String password}) {
    state = state.copyWith(password: password);
  }

  void savePinAndContinue({required int pin}) {
    state = state.copyWith(pin: pin);
  }

  Future<void> signup({
    required VoidCallback onSuccess,
    required Function(String email) onOtpRequired,
  }) async {
    // Update the specific submission status part of the state
    state = state.copyWith(submissionStatus: const AsyncLoading());

    final result = await _registerUseCase.execute(
      state.email,
      state.password,
      '234${state.phoneNumber}',
      state.fullName,
      state.customRef,
      state.pin!
    );

    result.fold(
      ifLeft: (failure) => state = state.copyWith(
        submissionStatus: AsyncError(failure.message, StackTrace.current),
      ),
      ifRight: (user) {
        if (!user.verified) {
          onOtpRequired(user.email);
        } else {
          onSuccess();
        }
        state = state.copyWith(submissionStatus: const AsyncData(null));
      },
    );
  }
}

/// Riverpod provider for the [SignupViewModel]
final signupViewModelProvider =
StateNotifierProvider<SignupViewModel, SignupState>((ref) {
  final registerUseCase = ref.watch(registerUseCaseProvider);
  return SignupViewModel(registerUseCase);
});
