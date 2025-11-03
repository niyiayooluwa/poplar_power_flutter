class GetBalanceResponseDto {
  final double balance;

  GetBalanceResponseDto({required this.balance});

  factory GetBalanceResponseDto.fromJson(Map<String, dynamic> json) {
    double parsedBalance = 0.0;
    if (json['body'] is Map<String, dynamic>) {
      final body = json['body'] as Map<String, dynamic>;
      if (body['data'] is Map<String, dynamic>) {
        final data = body['data'] as Map<String, dynamic>;
        if (data['currentBalance'] is num) {
          parsedBalance = (data['currentBalance'] as num).toDouble();
        }
      }
    }
    return GetBalanceResponseDto(
      balance: parsedBalance,
    );
  }
}
