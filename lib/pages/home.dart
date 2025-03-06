import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_state.dart';
import 'package:smart_feeding_app/bloc/theme_bloc.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/pages/feed_setting.dart';
import 'package:smart_feeding_app/pages/log_view.dart';
import 'package:smart_feeding_app/pages/temperature.dart';
import 'package:smart_feeding_app/widgets/connectivity_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final S s = S.of(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

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
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.pets, size: 28),
              SizedBox(width: AppTheme.spacingSmall),
              Text(s.app_title),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => context.read<ThemeBloc>().toggleTheme(),
              tooltip:
                  isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(AppTheme.spacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Temperature widget at the top
                TemperatureWidget(),
                SizedBox(height: AppTheme.spacingLarge),

                // Feed settings in the middle
                FeedSettingsWidget(),
                SizedBox(height: AppTheme.spacingLarge),

                // Expandable log view at the bottom
                LogViewWidget(),
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
            // In a real app, you might navigate to different pages
            // For now, we'll just scroll to different sections
            if (index == 1) {
              // Scroll to feed settings
              _scrollToPosition(1);
            } else if (index == 2) {
              // Scroll to logs
              _scrollToPosition(2);
            } else {
              // Scroll to top
              _scrollToPosition(0);
            }
          },
        ),
      ),
    );
  }

  void _scrollToPosition(int section) {
    double position = 0;

    switch (section) {
      case 0: // Top
        position = 0;
        break;
      case 1: // Feed settings
        position = 300;
        break;
      case 2: // Logs
        position = 600;
        break;
    }

    _scrollController.animateTo(
      position,
      duration: AppTheme.animationDuration,
      curve: Curves.easeInOut,
    );
  }
}
