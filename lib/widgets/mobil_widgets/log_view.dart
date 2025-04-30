import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_state.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:intl/intl.dart';

class LogViewWidget extends StatefulWidget {
  @override
  _LogViewWidgetState createState() => _LogViewWidgetState();
}

class _LogViewWidgetState extends State<LogViewWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final S s = S.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<FeederBloc, FeederState>(
      builder: (context, state) {
        // Sample logs for demonstration
        final List<Map<String, dynamic>> logs = [
          {
            'timestamp': DateTime.now().subtract(Duration(minutes: 30)),
            'event': 'Feeding completed',
            'details': 'Dispensed 100g of feed',
            'type': 'success',
          },
          {
            'timestamp': DateTime.now().subtract(Duration(hours: 2)),
            'event': 'Temperature alert',
            'details': 'Temperature reached 32°C',
            'type': 'warning',
          },
          {
            'timestamp': DateTime.now().subtract(Duration(hours: 5)),
            'event': 'Feeding completed',
            'details': 'Dispensed 100g of feed',
            'type': 'success',
          },
          {
            'timestamp': DateTime.now().subtract(Duration(hours: 8)),
            'event': 'System check',
            'details': 'All systems operational',
            'type': 'info',
          },
          {
            'timestamp': DateTime.now().subtract(Duration(hours: 12)),
            'event': 'Feeding completed',
            'details': 'Dispensed 100g of feed',
            'type': 'success',
          },
        ];

        return Card(
          elevation: AppTheme.cardElevation,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(AppTheme.spacing),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.list_alt,
                            color: theme.colorScheme.primary,
                          ),
                          SizedBox(width: AppTheme.spacingSmall),
                          Text(
                            s.feeding_logs,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedCrossFade(
                firstChild: Container(height: 0),
                secondChild: _buildLogsList(logs),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: AppTheme.animationDuration,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogsList(List<Map<String, dynamic>> logs) {
    return Container(
      constraints: BoxConstraints(maxHeight: 300),
      child: logs.isEmpty
          ? Padding(
              padding: EdgeInsets.all(AppTheme.spacing),
              child: Center(
                child: Text('No logs available'),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                final DateTime timestamp = log['timestamp'];
                final String event = log['event'];
                final String details = log['details'];
                final String type = log['type'];

                // Determine icon and color based on log type
                IconData icon;
                Color color;

                switch (type) {
                  case 'success':
                    icon = Icons.check_circle;
                    color = AppTheme.accentGreen;
                    break;
                  case 'warning':
                    icon = Icons.warning_amber;
                    color = AppTheme.accentAmber;
                    break;
                  case 'error':
                    icon = Icons.error;
                    color = AppTheme.accentRed;
                    break;
                  case 'info':
                  default:
                    icon = Icons.info;
                    color = Colors.blue;
                    break;
                }

                return Column(
                  children: [
                    if (index == 0) Divider(height: 1),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: color.withOpacity(0.2),
                        child: Icon(icon, color: color, size: 20),
                      ),
                      title: Text(
                        event,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(details),
                          SizedBox(height: 4),
                          Text(
                            DateFormat('MMM dd, yyyy - HH:mm')
                                .format(timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                    Divider(height: 1),
                  ],
                );
              },
            ),
    );
  }
}
