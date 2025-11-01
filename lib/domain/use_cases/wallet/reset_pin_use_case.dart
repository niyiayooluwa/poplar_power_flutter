import 'package:dart_either/dart_either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/failures/transaction_failure.dart';
import 'package:poplar_power/domain/repositories/wallet_repository.dart';

import '../../../data/repositories/wallet_repository_impl.dart';

class ResetPinUseCase {
  final WalletRepository _repository;

  ResetPinUseCase(this._repository);

  Future<Either<Failure, void>> execute(String accountNo, String otp,
      String walletPin) async {
    return await _repository.resetPin(accountNo, otp, walletPin);
  }
}

final resetPinUseCaseProvider = Provider<ResetPinUseCase>((ref) {
  final repository = ref.watch(walletRepositoryProvider);
  return ResetPinUseCase(repository);
});