class GetBalanceRequestDto {
  final String accountNo;
  final String pin;

  GetBalanceRequestDto({required this.accountNo, required this.pin});

  Map<String, dynamic> toJson() {
    return {
      'accountNo': accountNo,
      'pin': pin,
    };
  }
}
