import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_event.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_state.dart';
import 'package:smart_feeding_app/bloc/log_expand.dart';
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
              InkWell(
                onTap: () => context.read<LogExpandCubit>().toggle(),
                child: Padding(
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
                            'System Logs',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _isRefreshing
                              ? SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        theme.colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                )
                              : IconButton(
                                  icon: Icon(Icons.refresh,
                                      color: theme.colorScheme.primary),
                                  onPressed: () {
                                    setState(() {
                                      _isRefreshing = true;
                                    });
                                    context
                                        .read<FeederBloc>()
                                        .add(LoadSystemLogsEvent());
                                    Future.delayed(Duration(seconds: 1), () {
                                      if (mounted) {
                                        setState(() {
                                          _isRefreshing = false;
                                        });
                                      }
                                    });
                                  },
                                  tooltip: 'Refresh logs',
                                ),
                          BlocBuilder<LogExpandCubit, bool>(
                            builder: (context, isExpanded) {
                              return Icon(
                                isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: theme.colorScheme.primary,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              BlocBuilder<LogExpandCubit, bool>(
                builder: (context, isExpanded) {
                  return AnimatedCrossFade(
                    firstChild: SizedBox.shrink(),
                    secondChild: Container(
                      constraints: BoxConstraints(maxHeight: 300),
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<FeederBloc>().add(LoadSystemLogsEvent());
                        },
                        child: dataState.hasError
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Error loading system logs',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () => context
                                          .read<FeederBloc>()
                                          .add(LoadSystemLogsEvent()),
                                      child: const Text('Retry'),
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
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
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
                    crossFadeState: isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: AppTheme.animationDuration,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
