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

    return BlocConsumer<SensorBloc, SensorState>(
      listener: (context, state) {
        // Şu an için dinleyiciye gerek yok.
      },
      builder: (context, state) {
        final temp = state.temperature ?? 0.0;

        final bool isHot = temp >= 30.0;
        final bool isCold = temp <= 15.0;

        final gradient = isHot
            ? AppTheme.temperatureGradientHot
            : isCold
                ? AppTheme.temperatureGradientCold
                : AppTheme.temperatureGradientWarm;

        final tempIcon = isCold ? Icons.ac_unit : Icons.thermostat;

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
              padding: EdgeInsets.all(AppTheme.spacing),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.current_temperature,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Icon(tempIcon, color: Colors.white, size: 28),
                    ],
                  ),
                  SizedBox(height: AppTheme.spacingLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        temp.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '°C',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppTheme.spacing),
                  Text(
                    _getTemperatureMessage(temp, s),
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
    if (temp >= 30.0) {
      return s.high_temperature_warning;
    } else if (temp <= 15.0) {
      return s.low_temperature_warning;
    } else {
      return s.optimal_temperature_message;
    }
  }
}
