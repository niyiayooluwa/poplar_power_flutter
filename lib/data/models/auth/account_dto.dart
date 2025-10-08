import 'package:poplar_power/data/models/auth/timestamps_dto.dart';

class AccountDto {
  final int id;
  final String sysAccount;
  final String bankAccount;
  final String? walletAccountNo;
  final String currency;
  final String status;
  final bool walletCreated;
  final String? walletCreationMessage;
  final String? internalWalletAccountNo;
  final bool internalWalletCreated;
  final String internalWalletCreationMessage;
  final bool? isInternal;
  final TimestampsDto timestamps;
  final bool blocked;
  final bool active;

  AccountDto({
    required this.id,
    required this.sysAccount,
    required this.bankAccount,
    this.walletAccountNo,
    required this.currency,
    required this.status,
    required this.walletCreated,
    this.walletCreationMessage,
    this.internalWalletAccountNo,
    required this.internalWalletCreated,
    required this.internalWalletCreationMessage,
    this.isInternal,
    required this.timestamps,
    required this.blocked,
    required this.active,
  });

  factory AccountDto.fromJson(Map<String, dynamic> json) {
    return AccountDto(
      id: json['id'] as int,
      sysAccount: json['sysAccount'] as String,
      bankAccount: json['bankAccount'] as String,
      walletAccountNo: json['walletAccountNo'] as String?,
      currency: json['currency'] as String,
      status: json['status'] as String,
      walletCreated: json['walletCreated'] as bool,
      walletCreationMessage: json['walletCreationMessage'] as String?,
      internalWalletAccountNo: json['internalWalletAccountNo'] as String?,
      internalWalletCreated: json['internalWalletCreated'] as bool,
      internalWalletCreationMessage: json['internalWalletCreationMessage'] as String,
      isInternal: json['isInternal'] as bool?,
      timestamps: TimestampsDto.fromJson(json['timestamps'] as Map<String, dynamic>),
      blocked: json['blocked'] as bool,
      active: json['active'] as bool,
    );
  }
}
