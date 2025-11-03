class Transaction {
  final int id;
  final String customerIdentifier;
  final double amount;
  final String? token;
  final String nettpayRef;
  final bool reversed;
  final bool delivered;
  final String email;
  final String phoneNumber;
  final String notificationType;
  final String provider;
  final String createdAt;
  final String? deliveredAt;
  final String categoryId;
  final String billerId;
  final String productId;
  final String customerReference;
  final String? status;

  Transaction({
    required this.id,
    required this.customerIdentifier,
    required this.amount,
    this.token,
    required this.nettpayRef,
    required this.reversed,
    required this.delivered,
    required this.email,
    required this.phoneNumber,
    required this.notificationType,
    required this.provider,
    required this.createdAt,
    this.deliveredAt,
    required this.categoryId,
    required this.billerId,
    required this.productId,
    required this.customerReference,
    this.status,
  });
}
