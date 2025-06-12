// lib/widgets/generic_log_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_event.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_state.dart';

enum LogType { system, command }

class GenericLogView<T> extends StatelessWidget {
  final LogType logType;
  final String title;
  final IconData icon;
  final String Function(BuildContext) noLogsMessage;
  final String Function(BuildContext) pullToRefreshMessage;
  final String Function(BuildContext) refreshTooltip;
  final String Function(BuildContext) errorMessage;
  final String Function(BuildContext) retryLabel;
  final Widget Function(T log, BuildContext context) itemBuilder;

  const GenericLogView({
    Key? key,
    required this.logType,
    required this.title,
    required this.icon,
    required this.noLogsMessage,
    required this.pullToRefreshMessage,
    required this.refreshTooltip,
    required this.errorMessage,
    required this.retryLabel,
    required this.itemBuilder,
  }) : super(key: key);

  Future<void> _onRefresh(BuildContext context) async {
    final event = logType == LogType.system
        ? LoadSystemLogsEvent()
        : LoadCommandLogsEvent();
    context.read<FeederBloc>().add(event);
    await context.read<FeederBloc>().stream.firstWhere((state) =>
        state is FeederDataState &&
        (logType == LogType.system
            ? !(state as FeederDataState).isLoadingSystemLogs
            : !(state as FeederDataState).isLoadingCommandLogs));
  }

  Widget _emptyState(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Container(
          height: 200,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.note_alt_outlined,
                size: 48,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(height: 16),
              Text(
                noLogsMessage(context),
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                pullToRefreshMessage(context),
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeederBloc, FeederState>(
      builder: (context, state) {
        if (state is! FeederDataState) {
          return const Center(child: CircularProgressIndicator());
        }

        final logs =
            logType == LogType.system ? state.systemLogs : state.commandLogs;
        final isLoading = logType == LogType.system
            ? state.isLoadingSystemLogs
            : state.isLoadingCommandLogs;
        final event = logType == LogType.system
            ? LoadSystemLogsEvent()
            : LoadCommandLogsEvent();
        final maxHeight = MediaQuery.of(context).size.height * 0.45;

        return Card(
          margin: const EdgeInsets.all(12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(icon,
                                color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 8),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                title,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(Icons.refresh,
                                color: Theme.of(context).colorScheme.primary),
                        onPressed: isLoading
                            ? null
                            : () => context.read<FeederBloc>().add(event),
                        tooltip: refreshTooltip(context),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: maxHeight,
                  child: RefreshIndicator(
                    onRefresh: () => _onRefresh(context),
                    child: logs.isEmpty
                        ? _emptyState(context)
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            padding: const EdgeInsets.only(bottom: 16),
                            itemCount: logs.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 4),
                            itemBuilder: (ctx, idx) =>
                                itemBuilder(logs[idx] as T, ctx),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
