import 'package:poplar_power/domain/models/biller_product.dart';

class BillerProductDto {
  final String id;
  final String name;
  final String? alias;
  final int? amount;

  BillerProductDto({
    required this.id,
    required this.name,
    this.alias,
    this.amount,
  });

  factory BillerProductDto.fromJson(Map<String, dynamic> json) {
    return BillerProductDto(
      id: json['id'],
      name: json['name'],
      alias: json['alias'] as String?,
      amount: json['amount'] as int?,
    );
  }

  BillerProduct toEntity() {
    return BillerProduct(id: id, alias: alias, name: name, amount: amount);
  }
}
