// lib/widgets/feed_settings/time_picker_logic.dart
import 'package:flutter/material.dart';
import 'package:smart_feeding_app/mixin/time_validation_mixin.dart';
import 'package:smart_feeding_app/widgets/feed_settings/time_picker_messages.dart';

class TimePickerLogic with TimeValidationMixin {
  final TimeOfDay? minTime;
  final TimeOfDay? maxTime;
  final bool isLastFeedTime;

  TimePickerLogic({
    this.minTime,
    this.maxTime,
    this.isLastFeedTime = false,
  });

  /// Başlangıç zamanını hesaplar
  TimeOfDay calculateInitialTime(TimeOfDay currentTime) {
    if (isLastFeedTime && minTime != null) {
      final minInMinutes = timeToMinutes(minTime!);
      final currentInMinutes = timeToMinutes(currentTime);

      if (currentInMinutes <= minInMinutes) {
        // Minimum'dan 1 saat sonra başlat
        final newMinutes = minInMinutes + 60;
        return minutesToTime(newMinutes);
      }
    }
    return currentTime;
  }

  /// Seçilen zamanı validasyondan geçirir
  bool validateSelectedTime(BuildContext context, TimeOfDay selectedTime) {
    if (minTime != null && !isTimeAfter(selectedTime, minTime!)) {
      TimePickerMessages.showValidationError(context,
          isLastFeedTime: isLastFeedTime);
      return false;
    }

    if (maxTime != null && !isTimeBefore(selectedTime, maxTime!)) {
      TimePickerMessages.showValidationError(context,
          isLastFeedTime: isLastFeedTime);
      return false;
    }

    return true;
  }

  /// Mevcut durumda validasyon hatası var mı?
  bool hasValidationError(TimeOfDay currentTime) {
    if (isLastFeedTime && minTime != null) {
      return !isTimeAfter(currentTime, minTime!);
    }
    return false;
  }

  /// Zaman seçici dialog'unu açar ve sonucu döndürür
  Future<TimeOfDay?> showTimePickerDialog(
      BuildContext context, TimeOfDay currentTime) async {
    final initialTime = calculateInitialTime(currentTime);

    return await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
  }
}
