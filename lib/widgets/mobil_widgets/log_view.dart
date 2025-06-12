import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_event.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_state.dart';
import 'package:intl/intl.dart';

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

  String _formatDateTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('MMM d, HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Load logs when widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final event = logType == LogType.system
          ? LoadSystemLogsEvent()
          : LoadCommandLogsEvent();
      context.read<FeederBloc>().add(event);
    });

    return BlocBuilder<FeederBloc, FeederState>(
      buildWhen: (previous, current) {
        if (previous is FeederDataState && current is FeederDataState) {
          if (logType == LogType.system) {
            return previous.systemLogs != current.systemLogs ||
                previous.errorCode != current.errorCode ||
                previous.isLoadingSystemLogs != current.isLoadingSystemLogs;
          } else {
            return previous.commandLogs != current.commandLogs ||
                previous.errorCode != current.errorCode ||
                previous.isLoadingCommandLogs != current.isLoadingCommandLogs;
          }
        }
        return true;
      },
      builder: (context, state) {
        if (state is! FeederDataState) {
          return const Center(child: CircularProgressIndicator());
        }

        final logs =
            logType == LogType.system ? state.systemLogs : state.commandLogs;
        final isLoading = logType == LogType.system
            ? state.isLoadingSystemLogs
            : state.isLoadingCommandLogs;

        return Card(
          elevation: AppTheme.cardElevation,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(AppTheme.spacing),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(icon, color: theme.colorScheme.primary),
                        SizedBox(width: AppTheme.spacingSmall),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: isLoading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.primary,
                                ),
                              ),
                            )
                          : Icon(Icons.refresh,
                              color: theme.colorScheme.primary),
                      onPressed: isLoading
                          ? null
                          : () {
                              final event = logType == LogType.system
                                  ? LoadSystemLogsEvent()
                                  : LoadCommandLogsEvent();
                              context.read<FeederBloc>().add(event);
                            },
                      tooltip: refreshTooltip(context),
                    ),
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  minHeight: 200,
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: RefreshIndicator(
                  onRefresh: () async {
                    final event = logType == LogType.system
                        ? LoadSystemLogsEvent()
                        : LoadCommandLogsEvent();
                    context.read<FeederBloc>().add(event);
                    // Wait for the loading to complete
                    await Future.doWhile(() async {
                      await Future.delayed(Duration(milliseconds: 100));
                      final currentState = context.read<FeederBloc>().state;
                      if (currentState is FeederDataState) {
                        return logType == LogType.system
                            ? currentState.isLoadingSystemLogs
                            : currentState.isLoadingCommandLogs;
                      }
                      return false;
                    });
                  },
                  child: state.hasError
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                errorMessage(context),
                                style:
                                    TextStyle(color: theme.colorScheme.error),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  final event = logType == LogType.system
                                      ? LoadSystemLogsEvent()
                                      : LoadCommandLogsEvent();
                                  context.read<FeederBloc>().add(event);
                                },
                                icon: Icon(Icons.refresh),
                                label: Text(retryLabel(context)),
                              ),
                            ],
                          ),
                        )
                      : logs.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                Container(
                                  height: 200,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                ),
                              ],
                            )
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              itemCount: logs.length,
                              separatorBuilder: (_, __) => Divider(height: 1),
                              itemBuilder: (context, index) {
                                return itemBuilder(logs[index] as T, context);
                              },
                            ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
