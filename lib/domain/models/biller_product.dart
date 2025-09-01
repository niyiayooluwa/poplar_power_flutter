class BillerProduct {
  final String id;
  final String name;
  final String? alias;
  final int? amount;

  BillerProduct({
    required this.id,
    required this.name,
    this.alias,
    this.amount,
  });

  factory BillerProduct.fromJson(Map<String, dynamic> json) {
    return BillerProduct(
      id: json['id'].toString(),
      name: json['name'],
      alias: json['alias'] as String?,
      amount: json['amount'] as int?,
    );
  }
}