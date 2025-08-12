import 'package:dart_either/dart_either.dart';
import 'package:dio/dio.dart';
import 'package:poplar_power/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:poplar_power/data/models/auth/login_request_dto.dart';
import 'package:poplar_power/data/models/auth/signup_request_dto.dart';
import 'package:poplar_power/data/storage/token_storage.dart';
import 'package:poplar_power/domain/entities/user.dart';
import 'package:poplar_power/domain/failures/auth_failure.dart';
import 'package:poplar_power/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<AuthFailure, User>> login(String email, String password) async {
    try {
      final requestDto = LoginRequestDto(username: email, password: password);
      final authResponseDto = await remoteDataSource.login(requestDto);

      if (authResponseDto.success && authResponseDto.token != null && authResponseDto.user != null) {
        await TokenStorage.saveToken(authResponseDto.token!);
        return Right(authResponseDto.user!.toEntity());
      } else {
        return Left(AuthFailure.serverError(authResponseDto.message));
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
        return Right(authResponseDto.user!.toEntity());
      } else {
        return Left(AuthFailure.serverError(authResponseDto.message));
      }
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(AuthFailure.unknown());
    }
  }

  @override
  Future<void> logout() async {
    await TokenStorage.deleteToken();
  }

  @override
  Future<bool> hasToken() async {
    final token = await TokenStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<Either<AuthFailure, User>> getAuthenticatedUser() async {
    try {
      final userDto = await remoteDataSource.getAuthenticatedUser();
      return Right(userDto.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(AuthFailure.unknown());
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
        final responseData = e.response?.data;
        if (responseData is Map<String, dynamic> && responseData.containsKey('message')) {
          return AuthFailure.serverError(responseData['message']);
        } else {
          return AuthFailure.unknown();
        }
      default:
        return AuthFailure.unknown();
    }
  }
}
