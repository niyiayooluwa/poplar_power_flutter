import 'dart:async';

import '../../ui/user_onboarding/auth/signup/viewmodel/signup_view_model.dart';


/// Simulates authentication service. Replace with real implementation later.
class MockAuthService {
  /// Mocks a login attempt with fake delay and response.
  /// Throws [Exception] if email or password are empty.
  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2)); // fake network delay

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password cannot be empty.');
    }

    if (email != 'test@example.com' || password != 'password123') {
      throw Exception('Invalid credentials.');
    }

    // Otherwise, success (mocked)
    return;
  }
}

/// Mock service to simulate signup logic.
///
/// This class represents a temporary stand-in for a real backend API call.
class MockSignupService {
  /// Simulates a network delay and "registers" the user.
  Future<void> registerUser(SignupFormData data) async {
    await Future.delayed(const Duration(seconds: 2));

    if (data.email == "fail@test.com") {
      throw Exception("This email is already in use.");
    }

    // Pretend the user was successfully registered.
    return;
  }
}

