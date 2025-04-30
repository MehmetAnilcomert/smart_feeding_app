import 'package:flutter/material.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:intl/intl.dart';

// Log content widget
class LogContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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

    // Use a Container with dark background to match your screenshot
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? Color(0xFF424242)
            : Colors.white, // Dark gray in dark mode
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      // Important: Use AlwaysScrollableScrollPhysics to ensure scrolling works everywhere
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero, // Remove padding to align with the header
        shrinkWrap: true,
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
              if (index == 0) Divider(height: 1, color: Colors.grey.shade700),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(icon, color: color, size: 20),
                ),
                title: Text(
                  event,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(
                      details,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      DateFormat('MMM dd, yyyy - HH:mm').format(timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.grey.shade400 : Colors.grey,
                      ),
                    ),
                  ],
                ),
                isThreeLine: true,
              ),
              Divider(height: 1, color: Colors.grey.shade700),
            ],
          );
        },
      ),
    );
  }
}
