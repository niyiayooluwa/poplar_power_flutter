
class CustomerVerificationResponseDto {
  final bool success;
  final String message;
  final CustomerVerificationDataDto data;

  CustomerVerificationResponseDto({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CustomerVerificationResponseDto.fromJson(Map<String, dynamic> json) =>
      CustomerVerificationResponseDto(
        success: json['success'],
        message: json['message'],
        data: CustomerVerificationDataDto.fromJson(json['data']),
      );
}

class CustomerVerificationDataDto {
  final String fullname;
  final bool enabled;
  final String meterNumber;
  final String accountNumber;
  final double arrearsBalance;
  final String accountType;
  final String address;
  final double minamount;
  final double maxamount;

  CustomerVerificationDataDto({
    required this.fullname,
    required this.enabled,
    required this.meterNumber,
    required this.accountNumber,
    required this.arrearsBalance,
    required this.accountType,
    required this.address,
    required this.minamount,
    required this.maxamount,
  });

  factory CustomerVerificationDataDto.fromJson(Map<String, dynamic> json) =>
      CustomerVerificationDataDto(
        fullname: json['fullname'] ?? '',
        enabled: json['enabled'] ?? false,
        meterNumber: json['meterNumber'] ?? '',
        accountNumber: json['accountNumber'] ?? '',
        arrearsBalance: (json['arrearsBalance'] as num?)?.toDouble() ?? 0.0,
        accountType: json['accountType'] ?? '',
        address: json['address'] ?? '',
        minamount: (json['minamount'] as num?)?.toDouble() ?? 0.0,
        maxamount: (json['maxamount'] as num?)?.toDouble() ?? 0.0,
      );
}
