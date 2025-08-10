// lib/data/models/user/user_dto.dart
import 'package:poplar_power/domain/entities/user.dart'; // To convert to entity

class UserDto {
  final String id;
  final String email;
  final String fullName;
  final String phone;
  final String? customRef;
  final double? balance;

  UserDto({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    this.customRef,
    this.balance,
  });

  // Factory constructor to create UserDto from JSON (API response)
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      customRef: json['customRef'] as String?,
      balance: (json['balance'] as num?)?.toDouble(), // Handle nullable num to double
    );
  }

  // Method to convert UserDto to Domain Entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      fullName: fullName,
      phone: phone,
      customRef: customRef,
      balance: balance,
    );
  }
}