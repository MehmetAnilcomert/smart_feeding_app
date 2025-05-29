// lib/mixins/time_validation_mixin.dart
import 'package:flutter/material.dart';

mixin TimeValidationMixin {
  bool isTimeAfter(TimeOfDay time1, TimeOfDay time2) {
    final time1InMinutes = time1.hour * 60 + time1.minute;
    final time2InMinutes = time2.hour * 60 + time2.minute;
    return time1InMinutes > time2InMinutes;
  }

  bool isTimeBefore(TimeOfDay time1, TimeOfDay time2) {
    final time1InMinutes = time1.hour * 60 + time1.minute;
    final time2InMinutes = time2.hour * 60 + time2.minute;
    return time1InMinutes < time2InMinutes;
  }

  bool isTimeRangeValid(TimeOfDay startTime, TimeOfDay? endTime) {
    if (endTime == null) return true;
    return isTimeAfter(endTime, startTime);
  }

  int timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  TimeOfDay minutesToTime(int minutes) {
    return TimeOfDay(
      hour: (minutes ~/ 60) % 24,
      minute: minutes % 60,
    );
  }
}
