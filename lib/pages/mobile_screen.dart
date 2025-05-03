import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_state.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/widgets/feed_setting.dart';
import 'package:smart_feeding_app/widgets/mobil_widgets/log_view.dart';
import 'package:smart_feeding_app/widgets/connectivity_dialog.dart';
import 'package:smart_feeding_app/widgets/drawer/drawer.dart';
import 'package:smart_feeding_app/widgets/sensor_widgets/humidity_card.dart';
import 'package:smart_feeding_app/widgets/sensor_widgets/temperature_card.dart';

class MobileHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    // Set fixed height for consistent card sizing across languages
    final cardHeight = 200.0; // Fixed consistent height

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
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: MediaQuery.of(context).size.shortestSide * 0.12,
                  height: MediaQuery.of(context).size.shortestSide * 0.12,
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
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(AppTheme.spacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Fixed height container with AspectRatio to maintain proportions
                SizedBox(
                  height: cardHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: TemperatureCard(),
                      ),
                      SizedBox(width: AppTheme.spacing),
                      Expanded(
                        child: HumidityCard(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppTheme.spacingLarge),
                FeedSettingsWidget(),
                SizedBox(height: AppTheme.spacingLarge),
                LogViewWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
