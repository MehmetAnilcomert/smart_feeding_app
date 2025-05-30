import 'package:flutter/material.dart';
import 'package:smart_feeding_app/mixin/time_validation_mixin.dart';
import 'package:smart_feeding_app/widgets/feed_settings/time_picker/time_picker_messages.dart';

class TimePickerLogic with TimeValidationMixin {
  final TimeOfDay? minTime;
  final TimeOfDay? maxTime;
  final bool isLastFeedTime;

  TimePickerLogic({
    this.minTime,
    this.maxTime,
    this.isLastFeedTime = false,
  });

  TimeOfDay calculateInitialTime(TimeOfDay currentTime) {
    if (isLastFeedTime && minTime != null) {
      final minInMinutes = timeToMinutes(minTime!);
      final currentInMinutes = timeToMinutes(currentTime);

      if (currentInMinutes <= minInMinutes) {
        final newMinutes = minInMinutes + 60;
        return minutesToTime(newMinutes);
      }
    }
    return currentTime;
  }

  bool validateSelectedTime(BuildContext context, TimeOfDay selectedTime) {
    bool isValid = true;

    if (minTime != null && !isTimeAfter(selectedTime, minTime!)) {
      isValid = false;
    }

    if (maxTime != null && !isTimeBefore(selectedTime, maxTime!)) {
      isValid = false;
    }

    if (!isValid) {
      TimePickerMessages.showValidationError(context,
          isLastFeedTime: isLastFeedTime);
    }

    return isValid;
  }

  bool hasValidationError(TimeOfDay? currentTime) {
    if (!isLastFeedTime || minTime == null || currentTime == null) {
      return false;
    }

    return !isTimeAfter(currentTime, minTime!);
  }

  Future<TimeOfDay?> showTimePickerDialog(
      BuildContext context, TimeOfDay currentTime) async {
    final initialTime = calculateInitialTime(currentTime);

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      if (minTime != null && !isTimeAfter(picked, minTime!)) {
        TimePickerMessages.showValidationError(context,
            isLastFeedTime: isLastFeedTime);
        return null;
      }

      if (maxTime != null && !isTimeBefore(picked, maxTime!)) {
        TimePickerMessages.showValidationError(context,
            isLastFeedTime: isLastFeedTime);
        return null;
      }
    }

    return picked;
  }
}
