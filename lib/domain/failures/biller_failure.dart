sealed class BillerFailure {
  final String message;

  const BillerFailure(this.message);

  factory BillerFailure.network() => const BillerFailure._('Network error occurred.');

  factory BillerFailure.unknown() => const BillerFailure._('An unknown error occurred.');

  const factory BillerFailure._(String message) = _BillerFailureImpl;
}

class _BillerFailureImpl extends BillerFailure {
  const _BillerFailureImpl(super.message);
}
