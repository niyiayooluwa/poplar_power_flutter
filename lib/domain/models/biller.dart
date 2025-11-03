class Biller {
  final int id;
  final String alias;
  final String name;
  final bool validation;
  final String logoUrl;
  final int accountNumberSize;

  Biller({
    required this.id,
    required this.alias,
    required this.name,
    required this.validation,
    required this.logoUrl,
    required this.accountNumberSize,
  });

  factory Biller.fromJson(Map<String, dynamic> json) {
    return Biller(
      id: int.parse(json['id'] as String),
      alias: json['alias'],
      name: json['name'],
      validation: json['validation'],
      logoUrl: json['logoUrl'],
      accountNumberSize: json['accountNumberSize'],
    );
  }
}
