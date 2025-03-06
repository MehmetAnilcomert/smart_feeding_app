import 'package:flutter/material.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/generated/l10n.dart';

class ConnectivityDialog extends StatelessWidget {
  const ConnectivityDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final S s = S.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      title: Row(
        children: [
          Icon(
            Icons.wifi_off,
            color: AppTheme.accentRed,
          ),
          SizedBox(width: AppTheme.spacingSmall),
          Text(s.connection_lost),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(s.connection_lost_message),
          SizedBox(height: AppTheme.spacing),
          LinearProgressIndicator(
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBrown),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // In a real app, you would try to reconnect here
            Navigator.of(context).pop();
          },
          child: Text(s.retry),
        ),
      ],
    );
  }
}
