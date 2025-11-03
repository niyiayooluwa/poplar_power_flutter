class AccountDto {
  final int bankAccount;
  final int sysAccount;
  final bool internalWalletCreated;

  AccountDto({
    required this.bankAccount,
    required this.sysAccount,
    required this.internalWalletCreated,
  });

  factory AccountDto.fromJson(Map<String, dynamic> json) {
    // Convert to string first, then parse as int - handles leading zeros
    int safeParseInt(dynamic value) {
      if (value == null) return 0;
      return int.tryParse(value.toString()) ?? 0;
    }

    return AccountDto(
      bankAccount: safeParseInt(json['bankAccount']),
      sysAccount: safeParseInt(json['sysAccount']),
      internalWalletCreated: (json['internalWalletCreated'] as bool?) ?? false,
    );
  }
}