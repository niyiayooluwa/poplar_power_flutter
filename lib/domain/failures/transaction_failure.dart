abstract class Failure {
  final String message;

  Failure(this.message);
}

class TransactionFailure extends Failure {
  TransactionFailure(super.message);
}
