import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_event.dart';
import 'package:smart_feeding_app/generated/l10n.dart';

class ActionButtons extends StatelessWidget {
  final bool isSaving;

  const ActionButtons({required this.isSaving});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: isSaving
                ? null
                : () => context.read<FeederBloc>().add(SaveSettingsEvent()),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: AppTheme.spacingSmall),
            ),
            child: isSaving
                ? SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation(theme.colorScheme.onPrimary),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save,
                          size: 18, color: theme.colorScheme.onPrimary),
                      SizedBox(width: AppTheme.spacingSmall),
                      Text(S.of(context).update_settings,
                          style: TextStyle(fontSize: 14)),
                    ],
                  ),
          ),
        ),
        SizedBox(width: AppTheme.spacingSmall),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.read<FeederBloc>().add(ManualFeedEvent()),
            icon: Icon(Icons.pets, size: 18),
            label: Text(S.of(context).feed_now, style: TextStyle(fontSize: 14)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: theme.colorScheme.primary),
              padding: EdgeInsets.symmetric(vertical: AppTheme.spacingSmall),
            ),
          ),
        ),
      ],
    );
  }
}
