import 'package:dart_either/dart_either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/failures/transaction_failure.dart';
import 'package:poplar_power/domain/repositories/wallet_repository.dart';

import '../../../data/repositories/wallet_repository_impl.dart';

class ForgotPinUseCase {
  final WalletRepository _repository;

  ForgotPinUseCase(this._repository);

  Future<Either<Failure, void>> execute(String accountNo) async {
    return await _repository.forgotPin(accountNo);
  }
}

final forgotPinUseCaseProvider = Provider<ForgotPinUseCase>((ref) {
  final repository = ref.watch(walletRepositoryProvider);
  return ForgotPinUseCase(repository);
});