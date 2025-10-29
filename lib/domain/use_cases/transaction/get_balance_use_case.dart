import 'package:dart_either/dart_either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/failures/transaction_failure.dart';
import 'package:poplar_power/domain/repositories/transaction_repository.dart';

import '../../../data/repositories/transaction_repository_impl.dart';

class GetBalanceUseCase {
  final TransactionRepository _repository;

  GetBalanceUseCase(this._repository);

  Future<Either<Failure, double>> execute() async {
    return await _repository.getBalance();
  }
}

final getBalanceUseCaseProvider = Provider<GetBalanceUseCase>((ref) {
  final transactionRepository = ref.watch(transactionRepositoryProvider);
  return GetBalanceUseCase(transactionRepository);
});
