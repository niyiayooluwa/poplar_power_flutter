import 'dart:ui';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:poplar_power/data/repositories/auth_repository_impl.dart';
import 'package:poplar_power/domain/use_cases/auth/register_use_case.dart';
import 'package:poplar_power/utils/validators.dart';

/// ViewModel for signup flow.
///
/// Manages user input between steps and handles submission to service.
class SignupViewModel extends AsyncNotifier<void> {
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phoneNumber;

  final RegisterUseCase _registerUseCase;

  SignupViewModel(this._registerUseCase);

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
    required String phoneNumber,
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

    final phoneNumberError = validatePhoneNumber(phoneNumber);
    if (phoneNumberError != null) {
      errors['phoneNumber'] = phoneNumberError;
    }

    if (errors.isNotEmpty) {
      return errors;
    }

    // If valid, save the data
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _phoneNumber = phoneNumber;

    return null;
  }

  /// Final signup submission
  Future<void> signup({
    required String password,
    required String confirmPassword,
    required String? customRef,
    required VoidCallback onSuccess,
    required Function(String email) onOtpRequired,
  }) async {
    state = const AsyncLoading();

    final result = await _registerUseCase.execute(
      _email ?? '',
      password,
      '234$_phoneNumber',
      '$_firstName $_lastName',
      customRef,
    );

    result.fold(
      ifLeft: (failure) =>
          state = AsyncError(failure.message, StackTrace.current),
      ifRight: (user) {
        if (!user.verified) {
          onOtpRequired(user.email);
        } else {
          onSuccess();
        }
        state = const AsyncData(null);
      },
    );
  }
}

/// Riverpod provider for the [SignupViewModel]
final signupViewModelProvider = AsyncNotifierProvider<SignupViewModel, void>(
  () {
    return SignupViewModel(
      RegisterUseCase(
        AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSourceImpl()),
      ),
    );
  },
);
