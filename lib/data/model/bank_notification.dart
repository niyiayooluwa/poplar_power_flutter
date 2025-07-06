import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BankNotification {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final DateTime date;

  BankNotification ({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.date
  });

  String get formattedDateTime {
    final day = date.day;
    final daySuffix = _getDaySuffix(day);
    final month = DateFormat.MMMM().format(date); // July
    final time = DateFormat.Hms().format(date); // 9:15:48

    return '$month ${day}$daySuffix, $time';
  }

  /// Private method to get the day suffix
  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }

  get markAsRead {

  }
}