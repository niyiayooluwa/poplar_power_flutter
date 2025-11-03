import 'package:poplar_power/data/models/auth/timestamps_dto.dart';

class FeeGroupDto {
  final int id;
  final String groupName;
  final String feeCode;
  final String remark;
  final TimestampsDto timestamps;
  final bool active;
  final bool isDefault;

  FeeGroupDto({
    required this.id,
    required this.groupName,
    required this.feeCode,
    required this.remark,
    required this.timestamps,
    required this.active,
    required this.isDefault,
  });

  factory FeeGroupDto.fromJson(Map<String, dynamic> json) {
    return FeeGroupDto(
      id: json['id'] as int,
      groupName: json['groupName'] as String,
      feeCode: json['feeCode'] as String,
      remark: json['remark'] as String,
      timestamps: TimestampsDto.fromJson(json['timestamps'] as Map<String, dynamic>),
      active: json['active'] as bool,
      isDefault: json['default'] as bool,
    );
  }
}
