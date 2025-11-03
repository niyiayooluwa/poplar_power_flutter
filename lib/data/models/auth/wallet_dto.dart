import 'package:poplar_power/data/models/auth/wallet_data_dto.dart';

class WalletDto {
  final WalletDataDto? data;
  final bool success;

  WalletDto({required this.data, required this.success});

  factory WalletDto.fromJson(Map<String, dynamic> json) {
    return WalletDto(
      data: json['data'] != null 
          ? WalletDataDto.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      success: (json['success'] as bool?) ?? false,
    );
  }
}
