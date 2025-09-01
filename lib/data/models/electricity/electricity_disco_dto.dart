import 'package:poplar_power/domain/models/electricity_disco.dart';

class ElectricityDiscoDto {
  final int id;
  final String alias;
  final String name;
  final bool validation;
  final String logoUrl;
  final int accountNumberSize;

  ElectricityDiscoDto({
    required this.id,
    required this.alias,
    required this.name,
    required this.validation,
    required this.logoUrl,
    required this.accountNumberSize,
  });

  factory ElectricityDiscoDto.fromJson(Map<String, dynamic> json) {
    return ElectricityDiscoDto(
      id: int.parse(json['id'] as String),
      alias: json['alias'],
      name: json['name'],
      validation: json['validation'],
      logoUrl: json['logoUrl'],
      accountNumberSize: json['accountNumberSize'],
    );
  }

  ElectricityDisco toEntity() {
    return ElectricityDisco(
      id: id,
      alias: alias,
      name: name,
      validation: validation,
      logoUrl: logoUrl,
      accountNumberSize: accountNumberSize,
    );
  }
}
