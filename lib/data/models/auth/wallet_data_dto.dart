import 'package:poplar_power/data/models/auth/account_dto.dart';

class WalletDataDto {
  final AccountDto? account;

  WalletDataDto({
    required this.account,
  });

  factory WalletDataDto.fromJson(Map<String, dynamic> json) {
    return WalletDataDto(
      account: json['account'] != null 
          ? AccountDto.fromJson(json['account'] as Map<String, dynamic>)
          : null,
    );
  }
}