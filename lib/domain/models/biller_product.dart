class BillerProduct {
  final String id;
  final String name;
  final String? billerId;
  final int? amount;

  BillerProduct({
    required this.id,
    required this.name,
    this.billerId,
    this.amount,
  });
}