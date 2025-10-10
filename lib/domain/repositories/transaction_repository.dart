import 'package:dart_either/dart_either.dart';
import 'package:poplar_power/domain/failures/transaction_failure.dart';

import '../models/transaction_status.dart';

import 'package:poplar_power/domain/models/verification_response.dart';

abstract class TransactionRepository {
  Future<Either<Failure, TransactionStatus>> getTransactionStatus(String nettpayRef);
  Future<Either<Failure, List<TransactionStatus>>> getTransactionHistory(String email);
  Future<Either<Failure, double>> getBalance(String accountNo, String pin);
  Future<Either<Failure, VerificationResponse>> verifyTransaction(String reference);
}
