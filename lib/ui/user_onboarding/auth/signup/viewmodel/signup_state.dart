// 1. Define a state class
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignupState {
  const SignupState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phoneNumber = '',
    this.pin,
    this.password = '',
    this.customRef,
    this.currentStep = 1,
    this.submissionStatus = const AsyncData(null),
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final int? pin;
  final String? customRef;
  final String password;
  final int currentStep;
  final AsyncValue<void> submissionStatus;

  // 2. Add a copyWith method for easy, immutable updates
  SignupState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? password,
    int? pin,
    int? currentStep,
    AsyncValue<void>? submissionStatus,
    String? customRef,
  }) {
    return SignupState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      pin: pin ?? this.pin,
      password: password ?? this.password,
      currentStep: currentStep ?? this.currentStep,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      customRef: customRef ?? this.customRef,
    );
  }

  // 3. Add getters for computed properties
  double get progress => currentStep / 4.0;

  String get fullName => '$firstName $lastName';
}
