// lib/data/repositories/auth_repository_impl.dart
import 'package:poplar_power/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:poplar_power/data/model/dto/auth/login.dart';
import 'package:poplar_power/data/storage/token_storage.dart';
import 'package:poplar_power/domain/entities/user.dart';
import 'package:poplar_power/domain/repositories/auth_repository.dart';
import 'package:poplar_power/data/model/dto/auth/signup.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> login(String email, String password) async {
    try {
      final requestDto = LoginRequest(email: email, password: password);
      final authResponseDto = await remoteDataSource.login(requestDto);
      await TokenStorage.saveToken(authResponseDto.token);
      return authResponseDto.user.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> register(String email, String password, String phone, String fullName, String? customRef) async {
    try {
      final requestDto = SignupRequest(
        email: email,
        password: password,
        phone: phone,
        fullName: fullName,
        customRef: customRef,
      );
      final authResponseDto = await remoteDataSource.register(requestDto);
      await TokenStorage.saveToken(authResponseDto.token);
      return authResponseDto.user.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await TokenStorage.deleteToken();
    // TODO()
  }

  @override
  Future<bool> hasToken() async {
    final token = await TokenStorage.getToken();
    return token != null && token.isNotEmpty;
  }

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
