import 'package:poplar_power/domain/models/biller.dart';

class BillerDto {
  final int id;
  final String alias;
  final String name;
  final bool validation;
  final String logoUrl;
  final int accountNumberSize;

  BillerDto({
    required this.id,
    required this.alias,
    required this.name,
    required this.validation,
    required this.logoUrl,
    required this.accountNumberSize,
  });

  factory BillerDto.fromJson(Map<String, dynamic> json) {
    return BillerDto(
      id: int.parse(json['id'] as String),
      alias: json['alias'],
      name: json['name'],
      validation: json['validation'],
      logoUrl: json['logoUrl'],
      accountNumberSize: json['accountNumberSize'],
    );
  }

  Biller toEntity() {
    return Biller (
      id: id,
      alias: alias,
      name: name,
      validation: validation,
      logoUrl: logoUrl,
      accountNumberSize: accountNumberSize,
    );
  }
}
