import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:poplar_power/data/repositories/auth_repository_impl.dart';
import 'package:poplar_power/domain/use_cases/auth/resend_otp_use_case.dart';

class ResendOtpViewModel extends StateNotifier<AsyncValue<void>> {
  final ResendOtpUseCase _resendOtpUseCase;

  ResendOtpViewModel(this._resendOtpUseCase) : super(const AsyncData(null));

  Future<void> resendOtp(String email) async {
    state = const AsyncLoading();
    final result = await _resendOtpUseCase.execute(email);
    result.fold(
      ifLeft: (failure) => state = AsyncError(failure.message, StackTrace.current),
      ifRight: (_) => state = const AsyncData(null),
    );
  }
}

final resendOtpViewModelProvider =
    StateNotifierProvider<ResendOtpViewModel, AsyncValue<void>>(
  (ref) => ResendOtpViewModel(
    ResendOtpUseCase(
      AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSourceImpl()),
    ),
  ),
);