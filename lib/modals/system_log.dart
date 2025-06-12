import 'package:flutter/material.dart';

class SystemLog {
  final int id;
  final DateTime createdAt;
  final int deviceId;

  final String rawType;
  final String message;

  SystemLog({
    required this.id,
    required this.createdAt,
    required this.deviceId,
    required this.rawType,
    required this.message,
  });

  factory SystemLog.fromJson(Map<String, dynamic> json) {
    return SystemLog(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      deviceId: json['device_id'] as int,
      rawType: json['type'] as String,
      message: json['message'] as String,
    );
  }

  IconData get iconData {
    switch (rawType) {
      case 'temperature':
        return Icons.thermostat;
      case 'interval':
        return Icons.timer;
      default:
        return Icons.info;
    }
  }

  Color get color {
    switch (rawType) {
      case 'temperature':
        return Colors.orange;
      case 'interval':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
