import 'package:poplar_power/domain/models/biller_product.dart';

class BillerProductDto {
  final String id;
  final String name;
  final String? billerId;
  final double? amount;

  BillerProductDto({
    required this.id,
    required this.name,
    this.billerId,
    this.amount,
  });

  factory BillerProductDto.fromJson(Map<String, dynamic> json) {
    return BillerProductDto(
      id: json['id'] as String,
      name: json['name'] as String,
      billerId: json['billerId'] as String?,
      amount: json['amount'] as double?,
    );
  }

  BillerProduct toEntity() {
    return BillerProduct(
        id: id,
        billerId: billerId,
        name: name,
        amount: amount?.toInt());
  }
}
