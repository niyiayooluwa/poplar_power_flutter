import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:poplar_power/data/repositories/auth_repository_impl.dart';
import 'package:poplar_power/domain/use_cases/auth/verify_otp_use_case.dart';

class OtpViewModel extends StateNotifier<AsyncValue<void>> {
  final VerifyOtpUseCase _verifyOtpUseCase;

  OtpViewModel(this._verifyOtpUseCase) : super(const AsyncData(null));

  Future<void> verifyOtp(String email, String password, String otp) async {
    state = const AsyncLoading();
    final result = await _verifyOtpUseCase.execute(email, password, otp);
    result.fold(
      ifLeft: (failure) => state = AsyncError(failure.message, StackTrace.current),
      ifRight: (user) => state = const AsyncData(null),
    );
  }
}

final otpViewModelProvider =
    StateNotifierProvider<OtpViewModel, AsyncValue<void>>(
  (ref) => OtpViewModel(
    VerifyOtpUseCase(
      AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSourceImpl()),
    ),
  ),
);
