import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/bloc/theme_bloc.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/pages/feed_setting.dart';
import 'package:smart_feeding_app/pages/log_view.dart';
import 'package:smart_feeding_app/pages/temperature.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    FeedSettingsPage(),
    LogViewPage(),
    TemperaturePage(),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final S s = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.app_title),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () => context.read<ThemeBloc>().toggleTheme(),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: s.feed,
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: s.logs),
          BottomNavigationBarItem(
              icon: Icon(Icons.thermostat), label: s.temperature),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
