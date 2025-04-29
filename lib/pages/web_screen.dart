import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_state.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/pages/feed_setting.dart';
import 'package:smart_feeding_app/pages/log_view.dart';
import 'package:smart_feeding_app/pages/temperature.dart';
import 'package:smart_feeding_app/widgets/connectivity_dialog.dart';
import 'package:smart_feeding_app/widgets/drawer.dart';

class WebHomeScreen extends StatefulWidget {
  @override
  _WebHomeScreenState createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _mainScrollController = ScrollController();
  bool _isLogExpanded = false;

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final S s = S.of(context);
    final Size screenSize = MediaQuery.of(context).size;
    final double contentPadding = screenSize.width * 0.02; // 2% of screen width
    // Calculate a larger icon size - 8% of shortest side instead of 6%
    final double iconSize = MediaQuery.of(context).size.shortestSide * 0.08;

    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listener: (context, state) {
        if (state is ConnectivityDisconnected) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => const ConnectivityDialog(),
          );
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: AppDrawer(),
        appBar: AppBar(
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: iconSize,
                  height: iconSize,
                  color: Colors.transparent,
                  child: Image.asset(
                    "assets/chicken.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: AppTheme.spacingSmall),
              Text(s.app_title),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(contentPadding),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return _buildLayout(constraints);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLayout(BoxConstraints constraints) {
    // Calculate available height (minus padding)
    final double availableHeight = constraints.maxHeight;
    final bool isWideScreen = constraints.maxWidth > 600;

    return CustomScrollView(
      controller: _mainScrollController,
      slivers: [
        // First row: Temperature and Feed Settings side by side
        SliverToBoxAdapter(
          child: SizedBox(
            height: availableHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Temperature widget
                Expanded(
                  flex: 1,
                  child: TemperatureWidget(),
                ),
                SizedBox(width: AppTheme.spacingMedium),
                // Feed settings
                Expanded(
                  flex: isWideScreen ? 1 : 2,
                  child: FeedSettingsWidget(),
                ),
              ],
            ),
          ),
        ),

        // Collapsible Log Header
        SliverPersistentHeader(
          pinned: true,
          delegate: _CollapsibleLogHeaderDelegate(
            isExpanded: _isLogExpanded,
            onToggle: () {
              setState(() {
                _isLogExpanded = !_isLogExpanded;
              });
            },
          ),
        ),

        // Log content - only visible when expanded
        if (_isLogExpanded)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 400, // Fixed height for log content
              child: LogContentWidget(),
            ),
          ),
      ],
    );
  }
}

// Custom delegate for collapsible log header
class _CollapsibleLogHeaderDelegate extends SliverPersistentHeaderDelegate {
  final bool isExpanded;
  final VoidCallback onToggle;

  _CollapsibleLogHeaderDelegate({
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: CollapsibleLogHeaderWidget(
        isExpanded: isExpanded,
        onToggle: onToggle,
      ),
    );
  }

  @override
  double get maxExtent => 60.0; // Height of the header

  @override
  double get minExtent => 60.0; // Height when collapsed

  @override
  bool shouldRebuild(covariant _CollapsibleLogHeaderDelegate oldDelegate) {
    return oldDelegate.isExpanded != isExpanded;
  }
}

// Collapsible log header widget
class CollapsibleLogHeaderWidget extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;

  const CollapsibleLogHeaderWidget({
    Key? key,
    required this.isExpanded,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final S s = S.of(context);

    return GestureDetector(
      onTap: onToggle,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 2,
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
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Log content widget
class LogContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

    return ListView.builder(
      // This is important - it prevents this ListView from interacting with the parent scroll
      physics: ClampingScrollPhysics(),
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
                    '${timestamp.day}/${timestamp.month}/${timestamp.year} - ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
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
    );
  }
}
