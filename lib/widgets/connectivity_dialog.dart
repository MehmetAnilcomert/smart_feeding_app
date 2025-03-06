import 'package:flutter/material.dart';
import 'package:smart_feeding_app/generated/l10n.dart';

class ConnectivityDialog extends StatelessWidget {
  const ConnectivityDialog({super.key});

  @override
  Widget build(BuildContext context) {
    S s = S.of(context);
    return AlertDialog(
      title: Text(s.connection_error),
      content: Text(s.connection_error_message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(s.ok),
        ),
      ],
    );
  }
}
