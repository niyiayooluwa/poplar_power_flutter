
class BillerCategory {
  final String id;
  final String alias;
  final String name;
  final String logoUrl;

  BillerCategory({
    required this.id,
    required this.alias,
    required this.name,
    required this.logoUrl,
  });

  factory BillerCategory.fromJson(Map<String, dynamic> json) {
    return BillerCategory(
      id: json['id'].toString(),
      alias: json['alias'],
      name: json['name'],
      logoUrl: json['logoUrl'],
    );
  }
}
