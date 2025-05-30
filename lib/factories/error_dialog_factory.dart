// lib/factories/error_dialog_factory.dart
import 'package:flutter/material.dart';
import 'package:smart_feeding_app/enums/error_type.dart';
import 'package:smart_feeding_app/generated/l10n.dart';

class ErrorDialogFactory {
  static Widget createErrorDialog(
    BuildContext context,
    FeedErrorType errorType,
  ) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: _buildTitle(context, errorType),
      content: _buildContent(context, errorType),
      actions: _buildActions(context, errorType),
    );
  }

  static Widget _buildTitle(BuildContext context, FeedErrorType errorType) {
    return Row(
      children: [
        Icon(
          errorType.icon,
          color: errorType.getColor(context),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            errorType.getTitle(context),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildContent(BuildContext context, FeedErrorType errorType) {
    return Text(
      errorType.getMessage(context),
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  static List<Widget> _buildActions(
      BuildContext context, FeedErrorType errorType) {
    final actions = <Widget>[
      TextButton(
        child: Text(S.of(context).ok),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ];

    // Belirli hata türleri için ek aksiyonlar
    switch (errorType) {
      case FeedErrorType.deviceNotReachable:
        actions.insert(
            0,
            TextButton(
              child: Text(S.of(context).retry),
              onPressed: () {
                Navigator.of(context).pop();
                // Burada retry logic'i eklenebilir
                // Örneğin: context.read<FeederBloc>().add(RetryConnectionEvent());
              },
            ));
        break;
      case FeedErrorType.timeoutError:
        actions.insert(
            0,
            TextButton(
              child: Text(S.of(context).retry),
              onPressed: () {
                Navigator.of(context).pop();
                // Retry logic
              },
            ));
        break;
      default:
        break;
    }

    return actions;
  }
}
