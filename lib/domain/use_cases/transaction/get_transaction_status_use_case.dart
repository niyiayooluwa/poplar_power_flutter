import 'package:dart_either/dart_either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/failures/transaction_failure.dart';
import 'package:poplar_power/domain/models/transaction_status.dart';
import 'package:poplar_power/domain/repositories/transaction_repository.dart';
import '../../../data/repositories/transaction_repository_impl.dart';

class GetTransactionStatusUseCase {
  final TransactionRepository _repository;

  GetTransactionStatusUseCase(this._repository);

  Future<Either<Failure, TransactionStatus>> execute(String nettpayRef) async {
    return await _repository.getTransactionStatus(nettpayRef);
  }
}

final getTransactionStatusUseCaseProvider =
    Provider<GetTransactionStatusUseCase>((ref) {
  final transactionRepository = ref.watch(transactionRepositoryProvider);
  return GetTransactionStatusUseCase(transactionRepository);
});
