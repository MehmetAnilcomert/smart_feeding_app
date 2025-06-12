import 'package:flutter/material.dart';

class CommandLog {
  final int id;
  final DateTime createdAt;
  final int deviceId;

  // Parsed fields
  final int? feedAmount;
  final Duration? interval;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  CommandLog({
    required this.id,
    required this.createdAt,
    required this.deviceId,
    this.feedAmount,
    this.interval,
    this.startTime,
    this.endTime,
  });

  factory CommandLog.fromJson(Map<String, dynamic> json) {
    final rawMsg = json['message'] as String;
    int? feed;
    Duration? interval;
    TimeOfDay? start;
    TimeOfDay? end;

    if (rawMsg.startsWith('FEED=')) {
      final amt = rawMsg.split('=')[1];
      feed = int.tryParse(amt);
    } else if (rawMsg.startsWith('INTERVAL=')) {
      // Example: INTERVAL=120,START=23:00,END=23:59,AMOUNT=50
      final parts = rawMsg.split(',');
      for (var part in parts) {
        final kv = part.split('=');
        if (kv.length != 2) continue;
        switch (kv[0]) {
          case 'INTERVAL':
            final seconds = int.tryParse(kv[1]);
            if (seconds != null)
              interval = Duration(minutes: (seconds / 60).round());
            break;
          case 'START':
            final t = kv[1].split(':');
            start = TimeOfDay(hour: int.parse(t[0]), minute: int.parse(t[1]));
            break;
          case 'END':
            final t = kv[1].split(':');
            end = TimeOfDay(hour: int.parse(t[0]), minute: int.parse(t[1]));
            break;
          case 'AMOUNT':
            feed = int.tryParse(kv[1]);
            break;
        }
      }
    }

    return CommandLog(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      deviceId: json['device_id'] as int,
      feedAmount: feed,
      interval: interval,
      startTime: start,
      endTime: end,
    );
  }
}
