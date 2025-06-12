import 'package:flutter/material.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/widgets/feed_setting.dart';
import 'package:smart_feeding_app/widgets/sensor_widgets/humidity_card.dart';
import 'package:smart_feeding_app/widgets/sensor_widgets/temperature_card.dart';

class DashboardTab extends StatelessWidget {
  final double cardHeight;

  const DashboardTab({Key? key, required this.cardHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
        ],
      ),
    );
  }
}
