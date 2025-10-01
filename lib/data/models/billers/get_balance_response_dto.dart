class GetBalanceResponseDto {
  final double balance;

  GetBalanceResponseDto({required this.balance});

  factory GetBalanceResponseDto.fromJson(Map<String, dynamic> json) {
    return GetBalanceResponseDto(
      balance: (json['balance'] as num).toDouble(),
    );
  }
}
