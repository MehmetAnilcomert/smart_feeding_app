import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_state.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/widgets/feed_setting.dart';
import 'package:smart_feeding_app/widgets/mobil_widgets/temperature.dart';
import 'package:smart_feeding_app/widgets/connectivity_dialog.dart';
import 'package:smart_feeding_app/widgets/drawer/drawer.dart';
import 'package:smart_feeding_app/widgets/web_widgets/collapsible_log_header_delegate.dart';
import 'package:smart_feeding_app/widgets/web_widgets/log_content_widget.dart';

class WebHomeScreen extends StatefulWidget {
  @override
  _WebHomeScreenState createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  bool _isLogExpanded = false;

  @override
  Widget build(BuildContext context) {
    final S s = S.of(context);
    final Size screenSize = MediaQuery.of(context).size;
    final double contentPadding = screenSize.width * 0.02; // 2% of screen width
    final double iconSize = MediaQuery.of(context).size.shortestSide * 0.08;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
        endDrawer: AppDrawer(),
        appBar: AppBar(
          backgroundColor: isDarkMode
              ? Color(0xFF795548)
              : null, // Brown color for app bar in dark mode
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
          child: Container(
            color: isDarkMode ? Color(0xFF303030) : null,
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
      ),
    );
  }

  Widget _buildLayout(BoxConstraints constraints) {
    final double availableHeight = constraints.maxHeight;
    final bool isWideScreen = constraints.maxWidth > 600;

    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
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
          delegate: CollapsibleLogHeaderDelegate(
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: SizedBox(
                height: 400, // Fixed height for log content
                child: LogContentWidget(),
              ),
            ),
          ),
      ],
    );
  }
}
