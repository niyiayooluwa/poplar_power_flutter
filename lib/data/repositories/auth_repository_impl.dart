import 'package:poplar_power/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:poplar_power/data/models/auth/login_request_dto.dart';
import 'package:poplar_power/data/models/auth/signup_request_dto.dart';
import 'package:poplar_power/data/storage/token_storage.dart';
import 'package:poplar_power/domain/entities/user.dart';
import 'package:poplar_power/domain/repositories/auth_repository.dart';

/// `AuthRepositoryImpl` is an implementation of the `AuthRepository` interface.
/// It handles authentication-related operations by interacting with a remote data source
/// and managing token storage.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  /// Logs in a user with the provided `email` and `password`.
  ///
  /// This method creates a `LoginRequestDto` and sends it to the `remoteDataSource`.
  /// If the login is successful, it saves the authentication token using `TokenStorage`
  /// and returns the `User` entity.
  ///
  /// Throws an exception if the login fails.
  @override
  Future<User> login(String email, String password) async {
    try {
      final requestDto = LoginRequestDto(username: email, password: password);
      final authResponseDto = await remoteDataSource.login(requestDto);

      if (authResponseDto.success && authResponseDto.token != null && authResponseDto.user != null) {
        await TokenStorage.saveToken(authResponseDto.token!);
        return authResponseDto.user!.toEntity();
      } else {
        throw Exception(authResponseDto.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Registers a new user with the provided details.
  ///
  /// This method creates a `SignupRequestDto` and sends it to the `remoteDataSource`.
  /// If the registration is successful, it saves the authentication token using `TokenStorage`
  /// and returns the `User` entity.
  ///
  /// The `customRef` parameter is optional.
  ///
  /// Throws an exception if the registration fails.
  @override
  Future<User> register(
    String email,
    String password,
    String phone,
    String fullName,
    String? customRef,
  ) async {
    try {
      final requestDto = SignupRequestDto(
        email: email,
        password: password,
        phone: phone,
        fullName: fullName,
        customRef: customRef,
      );
      final authResponseDto = await remoteDataSource.register(requestDto);

      if (authResponseDto.success && authResponseDto.token != null && authResponseDto.user != null) {
        await TokenStorage.saveToken(authResponseDto.token!);
        return authResponseDto.user!.toEntity();
      } else {
        throw Exception(authResponseDto.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Logs out the currently authenticated user.
  ///
  /// This method deletes the stored authentication token.
  /// TODO: Implement any additional logout logic (e.g., notifying the server).
  @override
  Future<void> logout() async {
    await TokenStorage.deleteToken();
  }

  /// Checks if an authentication token exists.
  ///
  /// Returns `true` if a non-empty token is found, `false` otherwise.
  @override
  Future<bool> hasToken() async {
    final token = await TokenStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  /// Retrieves the currently authenticated user's details.
  ///
  /// This method calls the `remoteDataSource` to get the authenticated user's information
  /// and converts the response DTO to a `User` entity.
  ///
  /// Throws an exception if the request fails or if the user is not authenticated.
  @override
  Future<User> getAuthenticatedUser() async {
    try {
      final userDto = await remoteDataSource.getAuthenticatedUser();
      return userDto.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
