import 'package:dart_either/dart_either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/data/repositories/transaction_repository_impl.dart';
import 'package:poplar_power/domain/failures/transaction_failure.dart';
import 'package:poplar_power/domain/repositories/transaction_repository.dart';

class GetWalletBalanceUseCase {
  final TransactionRepository _repository;

  GetWalletBalanceUseCase(this._repository);

  Future<Either<Failure, double>> execute() async {
    return await _repository.getBalance();
  }
}

final getWalletBalanceUseCaseProvider = Provider<GetWalletBalanceUseCase>((ref) {
  final transactionRepository = ref.watch(transactionRepositoryProvider);
  return GetWalletBalanceUseCase(transactionRepository);
});
