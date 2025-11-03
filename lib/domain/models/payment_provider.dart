/// Enum representing the available payment providers.
enum PaymentProvider {
  nettpay,
  paystack,
  flutterwave,
  stripe,
  bankTransfer;

  /// Converts the enum to its string representation for API requests.
  String toJson() {
    if (this == bankTransfer) {
      return 'BANK_TRANSFER';
    }
    return name.toUpperCase();
  }

  /// Creates a [PaymentProvider] from a string.
  /// Defaults to [paystack] if the string is unrecognized.
  static PaymentProvider fromJson(String json) {
    return values.firstWhere(
      (e) => e.toJson() == json.toUpperCase(),
    );
  }
}
