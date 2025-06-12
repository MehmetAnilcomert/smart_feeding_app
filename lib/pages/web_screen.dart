import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_state.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_event.dart';
import 'package:smart_feeding_app/bloc/log_expand.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/widgets/feed_setting.dart';
import 'package:smart_feeding_app/widgets/connectivity_dialog.dart';
import 'package:smart_feeding_app/widgets/drawer/drawer.dart';
import 'package:smart_feeding_app/widgets/sensor_widgets/temperature_card.dart';
import 'package:smart_feeding_app/widgets/sensor_widgets/humidity_card.dart';
import 'package:smart_feeding_app/widgets/mobil_widgets/log_widgets/command_log_view.dart';
import 'package:smart_feeding_app/widgets/mobil_widgets/log_widgets/system_log_view.dart';

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
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Load logs data when app starts
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final feederBloc = context.read<FeederBloc>();
                  feederBloc.add(LoadSystemLogsEvent());
                  feederBloc.add(LoadCommandLogsEvent());
                });

                final isWideScreen =
                    constraints.maxWidth > 1000; // Reduced threshold

                return Container(
                  color: isDarkMode ? Color(0xFF303030) : null,
                  padding: EdgeInsets.all(padding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main content area (narrower)
                      Expanded(
                        flex: isWideScreen ? 3 : 1, // Adjusted flex ratio
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Compact sensor cards
                              AspectRatio(
                                aspectRatio:
                                    3.2, // Wider aspect ratio (less tall)
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TemperatureCard(),
                                    ),
                                    SizedBox(width: AppTheme.spacingSmall),
                                    Expanded(
                                      child: HumidityCard(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: AppTheme
                                      .spacingMedium), // Reduced spacing
                              // Feed Settings
                              FeedSettingsWidget(),
                            ],
                          ),
                        ),
                      ),
                      if (isWideScreen) ...[
                        SizedBox(
                            width: AppTheme.spacingMedium), // Reduced spacing
                        Expanded(
                          flex: 2,
                          child: Card(
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: EdgeInsets.all(AppTheme.spacing),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    s.logs_tab,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: AppTheme.spacingSmall),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: Column(
                                        children: [
                                          CommandLogView(),
                                          SizedBox(
                                              height: AppTheme.spacingSmall),
                                          SystemLogView(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
