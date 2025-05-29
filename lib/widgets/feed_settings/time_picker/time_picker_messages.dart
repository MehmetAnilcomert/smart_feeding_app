import 'package:flutter/material.dart';
import 'package:smart_feeding_app/generated/l10n.dart';

class TimePickerMessages {
  static String getHelpText(BuildContext context, TimeOfDay minTime) {
    // L10n ile dil desteği - parametreli mesaj için doğru syntax
    return S.of(context).last_feed_time_help(minTime.format(context));
  }

  static String getValidationErrorMessage(BuildContext context,
      {bool isLastFeedTime = false}) {
    if (isLastFeedTime) {
      return S.of(context).last_feed_time_error;
    }
    return S.of(context).time_range_error;
  }

  static void showValidationError(BuildContext context,
      {bool isLastFeedTime = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          getValidationErrorMessage(context, isLastFeedTime: isLastFeedTime),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
