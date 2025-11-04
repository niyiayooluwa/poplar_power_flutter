import 'package:dart_either/dart_either.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:poplar_power/data/models/auth/login_request_dto.dart';
import 'package:poplar_power/data/models/auth/resend_otp_request_dto.dart';
import 'package:poplar_power/data/models/auth/signup_request_dto.dart';
import 'package:poplar_power/data/models/auth/verify_otp_request_dto.dart';
import 'package:poplar_power/data/storage/token_storage.dart';
import 'package:poplar_power/data/storage/user_profile_storage.dart';
import 'package:poplar_power/domain/entities/user.dart';
import 'package:poplar_power/domain/failures/auth_failure.dart';
import 'package:poplar_power/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final UserProfileStorage _userProfileStorage = UserProfileStorage();

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<AuthFailure, User>> login(String email, String password) async {
    try {
      final requestDto = LoginRequestDto(username: email, password: password);
      final authResponseDto = await remoteDataSource.login(requestDto);

      if (authResponseDto.success &&
          authResponseDto.token != null &&
          authResponseDto.user != null) {
        await TokenStorage.saveToken(authResponseDto.token!);
        if (authResponseDto.poplarToken != null) {
          await TokenStorage.savePoplarToken(authResponseDto.poplarToken!);
        }
        final user = authResponseDto.user!.toEntity();
        await _userProfileStorage.saveUser(user);
        return Right(user);
      } else {
        final failureType = _getAuthFailureType(authResponseDto.message);
        return Left(failureType);
      }
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(AuthFailure.unknown());
    }
  }

  @override
  Future<Either<AuthFailure, User>> register(
    String email,
    String password,
    String phone,
    String fullName,
    String? customRef,
    int pin,
  ) async {
    try {
      final requestDto = SignupRequestDto(
        email: email,
        password: password,
        phone: phone,
        fullName: fullName,
        customRef: customRef,
        pin: pin,
      );
      final userDto = await remoteDataSource.register(requestDto);
      return Right(userDto.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(AuthFailure.unknown());
    }
  }

  @override
  Future<void> logout() async {
    await TokenStorage.deleteToken();
    await TokenStorage.deletePoplarToken();
    await _userProfileStorage.deleteUser();
  }

  @override
  Future<bool> hasToken() async {
    final token = await TokenStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<Either<AuthFailure, User>> getAuthenticatedUser() async {
    try {
      final localUser = await _userProfileStorage.loadUser();

      // Fetch user from API (auth/me endpoint)
      final userDto = await remoteDataSource.getAuthenticatedUser();
      User fetchedUser = userDto.toEntity();

      // If a local user exists, merge the fetched data with local data
      // prioritizing walletAccountNo from localUser if it exists.
      // This is crucial because the /auth/me endpoint does not return wallet information.
      if (localUser != null) {
        fetchedUser = fetchedUser.copyWith(
          walletAccountNo:
              localUser.walletAccountNo ?? fetchedUser.walletAccountNo,
          // Add other fields from localUser that might be missing in fetchedUser if necessary
          // For example, if auth/me doesn't return customRef, but localUser has it:
          // customRef: localUser.customRef ?? fetchedUser.customRef,
        );
      }

      // Save the (potentially merged) user to local storage
      await _userProfileStorage.saveUser(fetchedUser);
      return Right(fetchedUser);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(AuthFailure.unknown());
    }
  }

  @override
  Future<Either<AuthFailure, User>> verifyOtp(
    String email,
    String password,
    String otp,
  ) async {
    try {
      final requestDto = VerifyOtpRequestDto(
        email: email,
        password: password,
        otp: otp,
      );
      final otpResponse = await remoteDataSource.verifyOtp(requestDto);

      if (otpResponse['success'] == true) {
        // If OTP verification is successful, attempt to log in the user.
        // This assumes the account is now verified and can be logged into.
        final loginResult = await login(email, password);
        return loginResult;
      } else {
        final message =
            otpResponse['message'] as String? ?? 'OTP verification failed.';
        return Left(AuthFailure.serverError(message));
      }
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(AuthFailure.unknown());
    }
  }

  @override
  Future<Either<AuthFailure, void>> resendOtp(String email) async {
    try {
      final requestDto = ResendOtpRequestDto(email: email);
      await remoteDataSource.resendOtp(requestDto);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(AuthFailure.unknown());
    }
  }

  @override
  Future<Either<AuthFailure, void>> resendUserOtp(String email) async {
    try {
      await remoteDataSource.resendUserOtp(email);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(AuthFailure.unknown());
    }
  }

  AuthFailure _getAuthFailureType(String message) {
    // Check for locked account
    if (message.contains('Account is locked') ||
        message.contains('locked due to multiple failed login attempts')) {
      return AuthFailure.accountLocked(
        'Account is locked due to multiple failed login attempts. Please try again later.',
      );
    }

    // Check for invalid credentials
    if (message.contains('Email or password is not correct') ||
        message.contains('Email or password is incorrect')) {
      return AuthFailure.invalidCredentials();
    }

    // Generic server error fallback
    return AuthFailure.serverError(message);
  }

  @override
  Future<AuthFailure?> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    try {
      await remoteDataSource.verifyOtpAndResetPassword(email, otp, newPassword);
      return null; // Return null for success
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return AuthFailure.unknown();
    }
  }

  AuthFailure _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return AuthFailure.network();

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;

        String? message;
        if (data is Map<String, dynamic>) {
          message = data['message']?.toString();
        }

        // Handle specific status codes
        if (statusCode == 400 || statusCode == 401) {
          if (message != null) {
            final msg = message.toLowerCase();

            if (msg.contains('already exists') || msg.contains('email')) {
              return AuthFailure.emailInUse();
            }

            if (msg.contains('invalid email')) {
              return AuthFailure.invalidEmail();
            }

            if (msg.contains('user not found')) {
              return AuthFailure.userNotFound();
            }

            if (msg.contains('incorrect password') ||
                msg.contains('wrong password') ||
                msg.contains('invalid credentials')) {
              return AuthFailure.invalidCredentials();
            }

            if (msg.contains('locked')) {
              return AuthFailure.accountLocked(message);
            }

            // Fallback: known server-side message
            return AuthFailure.serverError(message);
          }

          // No message? still a client error
          return AuthFailure.serverError('Bad request: $statusCode');
        }

        // Catch-all for other 4xx/5xx
        return AuthFailure.serverError(
          message ?? 'Unexpected server response: $statusCode',
        );

      default:
        return AuthFailure.unknown();
    }
  }
}

// Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource: remoteDataSource);
});
