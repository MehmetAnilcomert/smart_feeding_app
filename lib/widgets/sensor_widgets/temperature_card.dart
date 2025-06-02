import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/sensor_bloc/sensor_bloc.dart';
import 'package:smart_feeding_app/bloc/sensor_bloc/sensor_state.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'sensor_card.dart';

class TemperatureCard extends StatelessWidget {
  const TemperatureCard({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocBuilder<SensorBloc, SensorState>(
      builder: (context, state) {
        final connected = state.connected;
        final val = state.temperature ?? 0.0;
        final text = connected ? val.toStringAsFixed(1) : '-';
        final isHot = connected && val >= 30;
        final isCold = connected && val <= 15;

        return SensorCard(
          title: s.current_temperature,
          displayValue: text,
          unit: connected ? '°C' : '',
          icon: connected
              ? (isCold ? Icons.ac_unit : Icons.thermostat)
              : Icons.cloud_off,
          gradient: !connected
              ? [Colors.grey.shade700, Colors.grey.shade500]
              : isHot
                  ? AppTheme.temperatureGradientHot
                  : isCold
                      ? AppTheme.temperatureGradientCold
                      : AppTheme.temperatureGradientWarm,
          message: connected
              ? (isHot
                  ? s.high_temperature_warning
                  : isCold
                      ? s.low_temperature_warning
                      : s.temperature_optimal)
              : s.connection_lost_message,
        );
      },
    );
  }
}
