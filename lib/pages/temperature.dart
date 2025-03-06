import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_state.dart';
import 'package:smart_feeding_app/generated/l10n.dart';

class TemperatureWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final S s = S.of(context);

    return BlocBuilder<FeederBloc, FeederState>(
      builder: (context, state) {
        final temp = (state is FeederDataState) ? state.temperature : 22.5;

        // Determine temperature level for UI styling
        final bool isHot = temp >= 30.0;
        final bool isCold = temp <= 15.0;

        // Select gradient based on temperature
        final List<Color> gradient = isHot
            ? AppTheme.temperatureGradientHot
            : isCold
                ? AppTheme.temperatureGradientCold
                : AppTheme.temperatureGradientWarm;

        // Select icon based on temperature
        final IconData tempIcon = isHot
            ? Icons.thermostat
            : isCold
                ? Icons.ac_unit
                : Icons.thermostat;

        return Card(
          elevation: AppTheme.cardElevation,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
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
                      Icon(
                        tempIcon,
                        color: Colors.white,
                        size: 28,
                      ),
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
                    _getTemperatureMessage(temp),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
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

  String _getTemperatureMessage(double temp) {
    if (temp >= 30.0) {
      return 'High temperature! Consider cooling the coop.';
    } else if (temp <= 15.0) {
      return 'Low temperature! Consider heating the coop.';
    } else {
      return 'Optimal temperature for your chickens.';
    }
  }
}
