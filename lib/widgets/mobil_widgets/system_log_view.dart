import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_event.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_state.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:intl/intl.dart';

class SystemLogView extends StatefulWidget {
  const SystemLogView({Key? key}) : super(key: key);

  @override
  State<SystemLogView> createState() => _SystemLogViewState();
}

class _SystemLogViewState extends State<SystemLogView> {
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    context.read<FeederBloc>().add(LoadSystemLogsEvent());
  }

  String _formatDateTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('MMM d, HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<FeederBloc, FeederState>(
      builder: (context, state) {
        if (state is! FeederDataState) {
          return const Center(child: CircularProgressIndicator());
        }

        final dataState = state as FeederDataState;

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
                        Icon(Icons.event_note,
                            color: theme.colorScheme.primary),
                        SizedBox(width: AppTheme.spacingSmall),
                        Text(
                          s.system_logs,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: _isRefreshing
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
                      onPressed: () {
                        setState(() {
                          _isRefreshing = true;
                        });
                        context.read<FeederBloc>().add(LoadSystemLogsEvent());
                        Future.delayed(Duration(seconds: 1), () {
                          if (mounted) {
                            setState(() {
                              _isRefreshing = false;
                            });
                          }
                        });
                      },
                      tooltip: s.refresh_logs,
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
                    context.read<FeederBloc>().add(LoadSystemLogsEvent());
                  },
                  child: dataState.hasError
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                s.general_error_message,
                                style:
                                    TextStyle(color: theme.colorScheme.error),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () => context
                                    .read<FeederBloc>()
                                    .add(LoadSystemLogsEvent()),
                                icon: Icon(Icons.refresh),
                                label: Text(s.retry),
                              ),
                            ],
                          ),
                        )
                      : dataState.systemLogs.isEmpty
                          ? Center(
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
                                    s.no_logs_available,
                                    style: theme.textTheme.titleMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    s.pull_to_refresh_logs,
                                    style: theme.textTheme.bodySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              itemCount: dataState.systemLogs.length,
                              separatorBuilder: (_, __) => Divider(height: 1),
                              itemBuilder: (context, index) {
                                final log = dataState.systemLogs[index];
                                return ListTile(
                                  leading: Text(
                                    log.logTypeIcon,
                                    style: TextStyle(fontSize: 24),
                                  ),
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
                                );
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
