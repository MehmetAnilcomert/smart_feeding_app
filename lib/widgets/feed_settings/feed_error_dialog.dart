import 'package:flutter/material.dart';
import 'package:smart_feeding_app/generated/l10n.dart';

class FeedErrorDialog {
  static void show(BuildContext context, int messageCode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Row(
            children: [
              Icon(Icons.error, color: Theme.of(context).colorScheme.error),
              SizedBox(width: 8),
              Text(
                S.of(context).error,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ),
          content: Text(
            messageCode == 1 ? S.of(context).notConnected : S.of(context).error,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          actions: [
            TextButton(
              child: Text(S.of(context).ok),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
