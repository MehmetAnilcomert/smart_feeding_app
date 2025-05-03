import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/sensor_bloc/sensor_bloc.dart';
import 'package:smart_feeding_app/bloc/sensor_bloc/sensor_state.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'sensor_card.dart';

class HumidityCard extends StatelessWidget {
  const HumidityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocBuilder<SensorBloc, SensorState>(
      builder: (context, state) {
        final connected = state.connected;
        final val = state.humidity ?? 0.0;
        final text = connected ? val.toStringAsFixed(1) : '-';

        // Message based on value:
        final message = connected
            ? (val <= 30
                ? s.low_humidity_warning
                : val >= 70
                    ? s.high_humidity_warning
                    : s.optimal_humidity_message)
            : s.connection_lost_message;

        return SensorCard(
          title: s.current_humidity,
          displayValue: text,
          unit: connected ? '%' : '',
          icon: connected ? Icons.water_drop : Icons.cloud_off,
          gradient: connected
              ? [AppTheme.accentGreen, AppTheme.accentAmber]
              : [Colors.grey.shade700, Colors.grey.shade500],
          message: message,
        );
      },
    );
  }
}
