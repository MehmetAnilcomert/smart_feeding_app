import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_state.dart';
import 'package:smart_feeding_app/bloc/log_expand.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/widgets/feed_setting.dart';
import 'package:smart_feeding_app/widgets/connectivity_dialog.dart';
import 'package:smart_feeding_app/widgets/drawer/drawer.dart';
import 'package:smart_feeding_app/widgets/sensor_widgets/temperature_card.dart';
import 'package:smart_feeding_app/widgets/sensor_widgets/humidity_card.dart';
import 'package:smart_feeding_app/widgets/mobil_widgets/log_view.dart';

class WebHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final S s = S.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final padding = MediaQuery.of(context).size.width * 0.02;
    final iconSize = MediaQuery.of(context).size.shortestSide * 0.08;

    return MultiBlocProvider(
      providers: [
        BlocProvider<LogExpandCubit>(create: (_) => LogExpandCubit()),
      ],
      child: BlocListener<ConnectivityBloc, ConnectivityState>(
        listener: (context, state) {
          if (state is ConnectivityDisconnected) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const ConnectivityDialog(),
            );
          }
        },
        child: Scaffold(
          endDrawer: AppDrawer(),
          appBar: AppBar(
            backgroundColor: isDarkMode ? Color(0xFF795548) : null,
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    "assets/chicken.png",
                    width: iconSize,
                    height: iconSize,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: AppTheme.spacingSmall),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(s.app_title),
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Container(
              color: isDarkMode ? Color(0xFF303030) : null,
              padding: EdgeInsets.all(padding),
              // Use SingleChildScrollView to make the content scrollable
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // First row: Temperature and Humidity Cards
                    // Use AspectRatio to ensure consistent sizing
                    AspectRatio(
                      aspectRatio: 2.5, // Adjust this value as needed
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: TemperatureCard()),
                          SizedBox(width: AppTheme.spacingMedium),
                          Expanded(child: HumidityCard()),
                        ],
                      ),
                    ),

                    SizedBox(height: AppTheme.spacingLarge),

                    // Second row: Feed Settings and Log Widget
                    // Check screen width to determine layout
                    MediaQuery.of(context).size.width > 600
                        ? // Wide screen: use row layout
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: FeedSettingsWidget()),
                              SizedBox(width: AppTheme.spacingMedium),
                              Expanded(child: LogViewWidget()),
                            ],
                          )
                        : // Narrow screen: use column layout
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              FeedSettingsWidget(),
                              SizedBox(height: AppTheme.spacingMedium),
                              LogViewWidget(),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
