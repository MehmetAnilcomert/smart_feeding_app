import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_state.dart';
import 'package:smart_feeding_app/generated/l10n.dart';

class TemperaturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final S s = S.of(context);
    return BlocBuilder<FeederBloc, FeederState>(
      builder: (context, state) {
        final temp = (state is FeederDataState) ? state.temperature : 0.0;
        return Center(
          child: Text(
            '${s.current_temperature}: $temp°C',
            style: TextStyle(fontSize: 24),
          ),
        );
      },
    );
  }
}
