class CustomerVerificationRequestDto {
  final String action;
  final String biller;
  final String product;
  final String account;
  final String? reference;

  CustomerVerificationRequestDto({
    this.action = 'namequery',
    required this.biller,
    required this.product,
    required this.account,
    this.reference,
  });

  Map<String, dynamic> toJson() => {
    'action': action,
    'biller': biller,
    'product': product,
    'account': account,
    'reference': reference,
  };
}
