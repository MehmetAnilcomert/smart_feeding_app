import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/sensor_bloc/sensor_state.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/bloc/sensor_bloc/sensor_bloc.dart';

class TemperatureWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocBuilder<SensorBloc, SensorState>(
      builder: (context, state) {
        final connected = state.connected;
        final tempValue = state.temperature ?? 0.0;
        final displayText = connected ? tempValue.toStringAsFixed(1) : '-';

        final bool isHot = connected && tempValue >= 30.0;
        final bool isCold = connected && tempValue <= 15.0;

        final gradient = !connected
            ? [Colors.grey.shade800, Colors.grey.shade600]
            : isHot
                ? AppTheme.temperatureGradientHot
                : isCold
                    ? AppTheme.temperatureGradientCold
                    : AppTheme.temperatureGradientWarm;

        final icon = !connected
            ? Icons.cloud_off
            : isCold
                ? Icons.ac_unit
                : Icons.thermostat;

        return Card(
          elevation: AppTheme.cardElevation,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.current_temperature,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Icon(icon, color: Colors.white, size: 28),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingLarge),
                  Text(
                    displayText + (connected ? '°C' : ''),
                    style: TextStyle(
                      fontSize: connected ? 64 : 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing),
                  Text(
                    connected
                        ? _getTemperatureMessage(tempValue, s)
                        : s.connection_lost_message,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getTemperatureMessage(double temp, S s) {
    if (temp >= 30.0) return s.high_temperature_warning;
    if (temp <= 15.0) return s.low_temperature_warning;
    return s.optimal_temperature_message;
  }
}
