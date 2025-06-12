import 'package:flutter/material.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/modals/system_log.dart';
import 'package:smart_feeding_app/widgets/mobil_widgets/log_widgets/log_view.dart';
import 'package:intl/intl.dart';

class SystemLogView extends StatelessWidget {
  const SystemLogView({Key? key}) : super(key: key);

  String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat('MMM d, HH:mm', locale).format(date);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return GenericLogView<SystemLog>(
      logType: LogType.system,
      title: s.system_logs,
      icon: Icons.event_note,
      noLogsMessage: (_) => s.no_logs_available,
      pullToRefreshMessage: (_) => s.pull_to_refresh_logs,
      refreshTooltip: (_) => s.refresh_logs,
      errorMessage: (_) => s.general_error_message,
      retryLabel: (_) => s.refresh_logs,
      itemBuilder: (log, context) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: log.color,
              child: Icon(log.iconData, color: Colors.white),
            ),
            title: Text(
              log.localizedMessage(context),
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              _formatDate(context, log.createdAt),
              style: theme.textTheme.bodySmall,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
        );
      },
    );
  }
}
