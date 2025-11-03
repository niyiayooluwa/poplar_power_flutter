import 'package:dart_either/dart_either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/failures/transaction_failure.dart';
import 'package:poplar_power/domain/models/transaction_status.dart';
import 'package:poplar_power/domain/repositories/transaction_repository.dart';
import '../../../data/repositories/transaction_repository_impl.dart';

class GetTransactionHistoryUseCase {
  final TransactionRepository _repository;

  GetTransactionHistoryUseCase(this._repository);

  Future<Either<Failure, List<TransactionStatus>>> execute(String email) async {
    return await _repository.getTransactionHistory(email);
  }
}

final getTransactionHistoryUseCaseProvider =
    Provider<GetTransactionHistoryUseCase>((ref) {
  final transactionRepository = ref.watch(transactionRepositoryProvider);
  return GetTransactionHistoryUseCase(transactionRepository);
});
