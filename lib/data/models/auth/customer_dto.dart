import 'package:poplar_power/data/models/auth/fee_group_dto.dart';
import 'package:poplar_power/data/models/auth/timestamps_dto.dart';

class CustomerDto {
  final int id;
  final dynamic transactionTier;
  final FeeGroupDto feeGroup;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String systemRef;
  final String serviceRef;
  final String status;
  final dynamic address;
  final dynamic dob;
  final dynamic street;
  final dynamic state;
  final dynamic country;
  final dynamic city;
  final dynamic zip;
  final dynamic otp;
  final dynamic otpExpiration;
  final bool isInternal;
  final bool pinCreated;
  final TimestampsDto timestamps;
  final bool blocked;
  final String fullname;
  final bool active;

  CustomerDto({
    required this.id,
    this.transactionTier,
    required this.feeGroup,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.systemRef,
    required this.serviceRef,
    required this.status,
    this.address,
    this.dob,
    this.street,
    this.state,
    this.country,
    this.city,
    this.zip,
    this.otp,
    this.otpExpiration,
    required this.isInternal,
    required this.pinCreated,
    required this.timestamps,
    required this.blocked,
    required this.fullname,
    required this.active,
  });

  factory CustomerDto.fromJson(Map<String, dynamic> json) {
    return CustomerDto(
      id: json['id'] as int,
      transactionTier: json['transactionTier'],
      feeGroup: FeeGroupDto.fromJson(json['feeGroup'] as Map<String, dynamic>),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      systemRef: json['systemRef'] as String,
      serviceRef: json['serviceRef'] as String,
      status: json['status'] as String,
      address: json['address'],
      dob: json['dob'],
      street: json['street'],
      state: json['state'],
      country: json['country'],
      city: json['city'],
      zip: json['zip'],
      otp: json['otp'],
      otpExpiration: json['otpExpiration'],
      isInternal: json['isInternal'] as bool,
      pinCreated: json['pinCreated'] as bool,
      timestamps: TimestampsDto.fromJson(json['timestamps'] as Map<String, dynamic>),
      blocked: json['blocked'] as bool,
      fullname: json['fullname'] as String,
      active: json['active'] as bool,
    );
  }
}
