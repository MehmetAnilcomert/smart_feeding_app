import 'package:flutter/material.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:smart_feeding_app/modals/command_log.dart';
import 'package:smart_feeding_app/widgets/mobil_widgets/log_widgets/log_view.dart';

class CommandLogView extends StatelessWidget {
  const CommandLogView({Key? key}) : super(key: key);

  String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat('MMM d, HH:mm', locale).format(date);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return GenericLogView<CommandLog>(
      logType: LogType.command,
      title: s.command_history,
      icon: Icons.history,
      noLogsMessage: (_) => s.no_logs_available,
      pullToRefreshMessage: (_) => s.pull_to_refresh_logs,
      refreshTooltip: (_) => s.refresh_logs,
      errorMessage: (_) => s.general_error_message,
      retryLabel: (_) => s.retry,
      itemBuilder: (log, context) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.fastfood,
                    size: 32, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (log.feedAmount != null)
                        Text(
                          s.feed_amount('${log.feedAmount}g'),
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      if (log.interval != null &&
                          log.startTime != null &&
                          log.endTime != null)
                        Text(
                          s.feed_interval(
                            log.interval!.inMinutes.toString(),
                            log.startTime!.format(context),
                            log.endTime!.format(context),
                          ),
                          style: theme.textTheme.bodyMedium,
                        ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(context, log.createdAt),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Text(
                  '#${log.id}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
