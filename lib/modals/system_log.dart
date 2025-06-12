import 'package:flutter/material.dart';
import 'package:smart_feeding_app/generated/l10n.dart';

class SystemLog {
  final int id;
  final DateTime createdAt;
  final int deviceId;
  final String rawType;
  final String message;

  // Parsed fields
  final double? temperature;
  final double? humidity;
  final int? intervalHours;
  final int? intervalMinutes;
  final int? feedAmount;
  final String? startTime;
  final String? endTime;

  SystemLog._(
      {required this.id,
      required this.createdAt,
      required this.deviceId,
      required this.rawType,
      required this.message,
      this.temperature,
      this.humidity,
      this.intervalHours,
      this.intervalMinutes,
      this.feedAmount,
      this.startTime,
      this.endTime});

  factory SystemLog.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    final msg = json['message'] as String;
    double? temp;
    double? hum;
    int? hrs;
    int? mins;
    int? amount;
    String? start;
    String? end;

    if (type == 'temperature') {
      final regex = RegExp(
          r"Temperature logged: (?<temp>[\d.]+)°C, Humidity logged: (?<hum>[\d.]+)%");
      final match = regex.firstMatch(msg);
      if (match != null) {
        temp = double.parse(match.namedGroup('temp')!);
        hum = double.parse(match.namedGroup('hum')!);
      }
    } else if (type == 'interval') {
      final regex = RegExp(
          r"Feed interval set: (?<h>\d+)h (?<m>\d+)m, amount: (?<a>\d+)g, between (?<s>[\d:]+)-(?<e>[\d:]+)");
      final match = regex.firstMatch(msg);
      if (match != null) {
        hrs = int.parse(match.namedGroup('h')!);
        mins = int.parse(match.namedGroup('m')!);
        amount = int.parse(match.namedGroup('a')!);
        start = match.namedGroup('s');
        end = match.namedGroup('e');
      }
    }

    return SystemLog._(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      deviceId: json['device_id'] as int,
      rawType: type,
      message: msg,
      temperature: temp,
      humidity: hum,
      intervalHours: hrs,
      intervalMinutes: mins,
      feedAmount: amount,
      startTime: start,
      endTime: end,
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

  String localizedMessage(BuildContext context) {
    final s = S.of(context);
    switch (rawType) {
      case 'temperature':
        if (temperature != null && humidity != null) {
          return s.temperature_log(
            temperature!.toStringAsFixed(1),
            humidity!.toStringAsFixed(1),
          );
        }
        break;
      case 'interval':
        if (intervalHours != null &&
            intervalMinutes != null &&
            feedAmount != null &&
            startTime != null &&
            endTime != null) {
          return s.feed_interval_set(
            intervalHours!,
            intervalMinutes!,
            feedAmount!,
            startTime!,
            endTime!,
          );
        }
        break;
    }
    // Fallback
    return message;
  }
}
