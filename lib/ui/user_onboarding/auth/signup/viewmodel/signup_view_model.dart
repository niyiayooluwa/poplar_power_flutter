// lib/ui/auth/viewmodel/signup_view_model.dart

import 'dart:ui';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../data/mock/mock_service/mock_auth_service.dart';
import '../../../../../utils/validators.dart';

/// Model class to hold signup data across steps.
class SignupFormData {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String customRef;

  const SignupFormData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.customRef,
  });
}

/// ViewModel for signup flow.
///
/// Manages user input between steps and handles submission to service.
class SignupViewModel extends AsyncNotifier<void> {
  String? _firstName;
  String? _lastName;
  String? _email;

  final _service = MockSignupService();

  @override
  Future<void> build() async {
    // no initialization needed
  }

  /// Validates and saves data from Step 1.
  /// Returns a map of field errors, or null if valid.
  Map<String, String>? validateAndSaveStep1({
    required String firstName,
    required String lastName,
    required String email,
  }) {
    final errors = <String, String>{};

    final firstNameError = validateName(firstName);
    if (firstNameError != null) {
      errors['firstName'] = firstNameError;
    }

    final lastNameError = validateName(lastName);
    if (lastNameError != null) {
      errors['lastName'] = lastNameError;
    }

    final emailError = validateEmail(email);
    if (emailError != null) {
      errors['email'] = emailError;
    }

    if (errors.isNotEmpty) {
      return errors;
    }

    // If valid, save the data
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    return null;
  }

  /// Final signup submission
  Future<void> signup({
    required String password,
    required String confirmPassword,
    required String customRef,
    required VoidCallback onSuccess,
  }) async {
    state = const AsyncLoading();

    // Password validation
    final passwordError = validatePassword(password);
    if (passwordError != null) {
      state = AsyncError(passwordError, StackTrace.current);
      return;
    }

    if (password != confirmPassword) {
      state = AsyncError("Passwords do not match", StackTrace.current);
      return;
    }

    final user = SignupFormData(
      firstName: _firstName ?? '',
      lastName: _lastName ?? '',
      email: _email ?? '',
      password: password,
      customRef: customRef,
    );

    try {
      await _service.registerUser(user);
      state = const AsyncData(null);
      onSuccess();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

/// Riverpod provider for the [SignupViewModel]
final signupViewModelProvider = AsyncNotifierProvider<SignupViewModel, void>(() {
  return SignupViewModel();
});
