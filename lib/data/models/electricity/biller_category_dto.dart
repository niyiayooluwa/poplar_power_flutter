import 'package:poplar_power/domain/models/biller_category.dart';

class BillerCategoryDto {
  final String id;
  final String alias;
  final String name;
  final String logoUrl;

  BillerCategoryDto({
    required this.id,
    required this.alias,
    required this.name,
    required this.logoUrl,
  });

  factory BillerCategoryDto.fromJson(Map<String, dynamic> json) {
    return BillerCategoryDto(
      id: json['id'],
      alias: json['alias'],
      name: json['name'],
      logoUrl: json['logoUrl'],
    );
  }

  BillerCategory toEntity() {
    return BillerCategory(id: id, alias: alias, name: name, logoUrl: logoUrl);
  }
}
