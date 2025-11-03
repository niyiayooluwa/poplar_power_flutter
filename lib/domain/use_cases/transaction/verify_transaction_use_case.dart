import 'package:dart_either/dart_either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/domain/failures/transaction_failure.dart';
import 'package:poplar_power/domain/models/verification_response.dart';
import 'package:poplar_power/domain/repositories/transaction_repository.dart';
import 'package:poplar_power/data/repositories/transaction_repository_impl.dart';

class VerifyTransactionUseCase {
  final TransactionRepository _repository;

  VerifyTransactionUseCase(this._repository);

  Future<Either<Failure, VerificationResponse>> execute(String reference) {
    return _repository.verifyTransaction(reference);
  }
}

final verifyTransactionUseCaseProvider =
    Provider<VerifyTransactionUseCase>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return VerifyTransactionUseCase(repo);
});
