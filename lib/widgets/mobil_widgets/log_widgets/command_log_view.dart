import 'package:flutter/material.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:smart_feeding_app/modals/command_log.dart';
import 'package:smart_feeding_app/widgets/mobil_widgets/log_widgets/log_view.dart';

class CommandLogView extends StatelessWidget {
  const CommandLogView({Key? key}) : super(key: key);

  String _formatDateTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('MMM d, HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return GenericLogView<CommandLog>(
      logType: LogType.command,
      title: s.command_history,
      icon: Icons.history,
      noLogsMessage: (context) => s.no_logs_available,
      pullToRefreshMessage: (context) => s.pull_to_refresh_logs,
      refreshTooltip: (context) => s.refresh_logs,
      errorMessage: (context) => s.general_error_message,
      retryLabel: (context) => s.retry,
      itemBuilder: (log, context) => ListTile(
        title: Text(
          log.message,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          _formatDateTime(log.createdAt),
          style: theme.textTheme.bodySmall,
        ),
        trailing: Text(
          '${s.log_id(log.id.toString())}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
