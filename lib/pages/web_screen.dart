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
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final S s = S.of(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double contentPadding = screenWidth * 0.02; // 2% of screen width

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
                  width: MediaQuery.of(context).size.shortestSide *
                      0.06, // Smaller for web
                  height: MediaQuery.of(context).size.shortestSide * 0.06,
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left panel: Temperature and Feed Settings
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Temperature widget
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: TemperatureWidget(),
                      ),
                      SizedBox(height: AppTheme.spacingLarge),

                      // Feed settings
                      Expanded(
                        child: FeedSettingsWidget(),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: AppTheme.spacingLarge),

                // Right panel: Log View
                Expanded(
                  flex: 4,
                  child: LogViewWidget(),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: s.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              label: s.feed,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              label: s.stats,
            ),
          ],
          onTap: (index) {
            setState(() => _selectedIndex = index);
            // For web layout, we could implement different tab views
            // but for now we're keeping the same navigation structure
          },
        ),
      ),
    );
  }
}
