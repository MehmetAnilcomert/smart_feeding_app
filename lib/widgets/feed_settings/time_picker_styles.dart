// lib/widgets/feed_settings/time_picker_styles.dart
import 'package:flutter/material.dart';
import 'package:smart_feeding_app/app_theme.dart';

class TimePickerStyles {
  static TextStyle labelStyle(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle timeTextStyle(BuildContext context,
      {bool hasError = false}) {
    return TextStyle(
      fontSize: 16,
      color: hasError
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle helpTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
    );
  }

  static BoxDecoration containerDecoration(BuildContext context,
      {bool hasError = false}) {
    return BoxDecoration(
      border: Border.all(
        color: hasError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).dividerColor,
        width: hasError ? 2.0 : 1.0,
      ),
      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
    );
  }

  static EdgeInsets containerPadding() {
    return EdgeInsets.symmetric(
      horizontal: AppTheme.spacing,
      vertical: AppTheme.spacingSmall,
    );
  }

  static Color iconColor(BuildContext context, {bool hasError = false}) {
    return hasError
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.onSurface;
  }
}
