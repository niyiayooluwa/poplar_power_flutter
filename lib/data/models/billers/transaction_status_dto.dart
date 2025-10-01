import '../../../domain/models/transaction_status.dart';

class TransactionStatusDto {
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

  TransactionStatusDto({
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
  });

  factory TransactionStatusDto.fromJson(Map<String, dynamic> json) {
    return TransactionStatusDto(
        id: json['id'] as int,
        customerIdentifier: json['customerIdentifier'] as String,
        amount: (json['amount'] as num).toDouble(),
        token: json['token'] as String?,
        nettpayRef: json['nettpayRef'] as String,
        reversed: json['reversed'] as bool,
        delivered: json['delivered'] as bool,
        email: json['email'] as String,
        phoneNumber: json['phoneNumber'] as String,
        notificationType: json['notificationType'] as String,
        provider: json['provider'] as String,
        createdAt: json['createdAt'] as String,
        deliveredAt: json['deliveredAt'] as String?,
        categoryId: json['categoryId'] as String,
        billerId: json['billerId'] as String,
        productId: json['productId'] as String,
        customerReference: json['customerReference'] as String
    );
  }

  TransactionStatus toDomain() {
    return TransactionStatus(
        id: id,
        customerIdentifier: customerIdentifier,
        amount: amount,
        nettpayRef: nettpayRef,
        reversed: reversed,
        delivered: delivered,
        email: email,
        phoneNumber: phoneNumber,
        notificationType: notificationType,
        provider: provider,
        createdAt: createdAt,
        categoryId: categoryId,
        billerId: billerId,
        productId: productId,
        customerReference: customerReference
    );
  }
}
