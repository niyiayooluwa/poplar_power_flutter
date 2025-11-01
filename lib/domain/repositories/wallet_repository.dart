import 'package:dart_either/dart_either.dart';

import '../failures/transaction_failure.dart';

abstract class WalletRepository {
  Future<Either<Failure, void>> forgotPin(String accountNo);

  Future<Either<Failure, void>> resetPin(
    String accountNo,
    String otp,
    String walletPin,
  );
}
