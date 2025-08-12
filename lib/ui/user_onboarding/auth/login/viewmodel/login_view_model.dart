import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:poplar_power/data/repositories/auth_repository_impl.dart';
import 'package:poplar_power/domain/use_cases/auth/login_use_case.dart';

/// ViewModel managing login logic and state.
class LoginViewModel extends StateNotifier<AsyncValue<void>> {
  final LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase) : super(const AsyncData(null));

  /// Attempts login using the mock auth service.
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    final result = await _loginUseCase.execute(email, password);

    result.fold(
      ifLeft: (failure) => state = AsyncError(failure.message, StackTrace.current),
      ifRight: (user) => state = const AsyncData(null),
    );
  }
}

final loginViewModelProvider =
StateNotifierProvider<LoginViewModel, AsyncValue<void>>(
      (ref) => LoginViewModel(LoginUseCase(AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSourceImpl()))),
);
