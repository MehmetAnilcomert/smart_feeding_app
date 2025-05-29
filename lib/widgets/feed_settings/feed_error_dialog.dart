// lib/widgets/feed_settings/feed_error_dialog.dart
import 'package:flutter/material.dart';
import 'package:smart_feeding_app/enums/error_type.dart';
import 'package:smart_feeding_app/factories/error_dialog_factory.dart';

class FeedErrorDialog {
  static void show(BuildContext context, int messageCode) {
    final errorType = FeedErrorType.fromCode(messageCode);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          ErrorDialogFactory.createErrorDialog(context, errorType),
    );
  }

  /// Özel hata türü ile dialog gösterme (isteğe bağlı)
  static void showWithType(BuildContext context, FeedErrorType errorType) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          ErrorDialogFactory.createErrorDialog(context, errorType),
    );
  }

  static void showCustom(
    BuildContext context, {
    required String title,
    required String message,
    IconData icon = Icons.error,
    Color? iconColor,
    List<Widget>? actions,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? Theme.of(context).colorScheme.error,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          actions: actions ??
              [
                TextButton(
                  child: Text('Tamam'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
        );
      },
    );
  }
}
