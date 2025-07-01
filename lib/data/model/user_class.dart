class User {
  final String firstName;
  final String lastName;
  final String email;
  final double balance;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.balance
  });

  // Helper methods (business logic)
  String get formattedBalance => '\$${balance.toStringAsFixed(2)}';
  bool get hasPositiveBalance => balance > 0;
}