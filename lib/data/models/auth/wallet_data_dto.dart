import 'package:poplar_power/data/models/auth/account_dto.dart';
import 'package:poplar_power/data/models/auth/customer_dto.dart';

class WalletDataDto {
  final CustomerDto customer;
  final AccountDto account;

  WalletDataDto({required this.customer, required this.account});

  factory WalletDataDto.fromJson(Map<String, dynamic> json) {
    return WalletDataDto(
      customer: CustomerDto.fromJson(json['customer'] as Map<String, dynamic>),
      account: AccountDto.fromJson(json['account'] as Map<String, dynamic>),
    );
  }
}
