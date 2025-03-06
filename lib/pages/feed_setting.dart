import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_event.dart';
import 'package:smart_feeding_app/generated/l10n.dart';

class FeedSettingsPage extends StatelessWidget {
  final TextEditingController _frequencyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final S s = S.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(s.set_feeding_frequency),
            TextField(
              controller: _frequencyController,
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                final frequency = int.tryParse(_frequencyController.text);
                if (frequency != null) {
                  context
                      .read<FeederBloc>()
                      .add(FeedingFrequencyChangedEvent(frequency));
                }
              },
              child: Text(s.update_frequency),
            ),
          ],
        ),
      ),
    );
  }
}
