import 'package:flutter/material.dart';
import 'package:smart_feeding_app/generated/l10n.dart';

class SystemLog {
  final int id;
  final DateTime createdAt;
  final int deviceId;
  final String rawType;
  final String message;

  // Parsed fields as strings including unit
  final String? temperatureStr;
  final String? humidityStr;
  final int? intervalHours;
  final int? intervalMinutes;
  final int? feedAmount;
  final String? startTime;
  final String? endTime;

  SystemLog._({
    required this.id,
    required this.createdAt,
    required this.deviceId,
    required this.rawType,
    required this.message,
    this.temperatureStr,
    this.humidityStr,
    this.intervalHours,
    this.intervalMinutes,
    this.feedAmount,
    this.startTime,
    this.endTime,
  });

  static String _convertTimeStringToLocal(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) return timeString;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final serverTime = DateTime(2000, 1, 1, hour, minute);
      final localTime = serverTime.add(Duration(hours: 3));

      return "${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return timeString;
    }
  }

  factory SystemLog.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    final msg = json['message'] as String;

    String? tempStr;
    String? humStr;
    int? hrs;
    int? mins;
    int? amount;
    String? start;
    String? end;

    if (type == 'temperature') {
      final regex = RegExp(
        r"(Temperature|Sıcaklık).*?: (?<temp>[\d.]+).*?C,.*?(Humidity|Nem).*?: (?<hum>[\d.]+)%",
        caseSensitive: false,
      );
      final match = regex.firstMatch(msg);
      if (match != null) {
        tempStr = "${match.namedGroup('temp')}\u00B0C"; // Unicode °C
        humStr = "${match.namedGroup('hum')}%";
      }
    } else if (type == 'interval') {
      final regex = RegExp(
        r"Feed interval set: (?<h>\d+)h (?<m>\d+)m, amount: (?<a>\d+)g, between (?<s>[\d:]+)-(?<e>[\d:]+)",
      );
      final match = regex.firstMatch(msg);
      if (match != null) {
        hrs = int.parse(match.namedGroup('h')!);
        mins = int.parse(match.namedGroup('m')!);
        amount = int.parse(match.namedGroup('a')!);

        // Server saatini local saate çevir
        start = _convertTimeStringToLocal(match.namedGroup('s')!);
        end = _convertTimeStringToLocal(match.namedGroup('e')!);
      }
    }

    return SystemLog._(
      id: json['id'] as int,
      createdAt:
          DateTime.parse(json['created_at'] as String).add(Duration(hours: 3)),
      deviceId: json['device_id'] as int,
      rawType: type,
      message: msg,
      temperatureStr: tempStr,
      humidityStr: humStr,
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
        if (temperatureStr != null && humidityStr != null) {
          return s.temperature_log(
            temperatureStr!,
            humidityStr!,
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
