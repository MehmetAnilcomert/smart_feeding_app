import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_event.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_state.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/widgets/feed_settings/action_buttons.dart';
import 'package:smart_feeding_app/widgets/feed_settings/amount_input.dart';
import 'package:smart_feeding_app/widgets/feed_settings/frequency_input.dart';
import 'package:smart_feeding_app/widgets/feed_settings/time_picker.dart';

class FeedSettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeederBloc, FeederState>(
      builder: (context, state) {
        final s = state is FeederDataState ? state : FeederDataState.initial();

        return Card(
          elevation: AppTheme.cardElevation,
          child: Padding(
            padding: EdgeInsets.all(AppTheme.spacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.schedule,
                        color: Theme.of(context).colorScheme.primary),
                    SizedBox(width: AppTheme.spacingSmall),
                    Expanded(
                      child: Text(
                        S.of(context).feed_settings,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Divider(height: AppTheme.spacingLarge),
                FrequencyInput(
                  frequency: s.feedingFrequency,
                  onChanged: (f) => context
                      .read<FeederBloc>()
                      .add(FeedingFrequencyChangedEvent(f)),
                ),
                SizedBox(height: AppTheme.spacing),
                AmountInput(
                  amount: s.feedAmount,
                  onChanged: (a) =>
                      context.read<FeederBloc>().add(FeedAmountChangedEvent(a)),
                ),
                SizedBox(height: AppTheme.spacing),
                TimePickerInput(
                  time: s.firstFeedTime,
                  onTimeSelected: (t) => context
                      .read<FeederBloc>()
                      .add(FirstFeedTimeChangedEvent(t)),
                ),
                SizedBox(height: AppTheme.spacingLarge),
                ActionButtons(isSaving: s.isSaving),
              ],
            ),
          ),
        );
      },
    );
  }
}
