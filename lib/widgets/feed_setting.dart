import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_event.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_state.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/widgets/feed_settings/action_buttons.dart';
import 'package:smart_feeding_app/widgets/feed_settings/amount_input.dart';
import 'package:smart_feeding_app/widgets/feed_settings/feed_error_dialog.dart';
import 'package:smart_feeding_app/widgets/feed_settings/frequency_input.dart';
import 'package:smart_feeding_app/widgets/feed_settings/time_picker/time_picker.dart';

class FeedSettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeederBloc, FeederState>(
      listener: (context, state) {
        if (state is FeederDataState && state.hasError) {
          FeedErrorDialog.show(context, state.errorCode!);
        }
      },
      builder: (context, state) {
        final s = state as FeederDataState;

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
                  suffix: S.of(context).times_per_day,
                  frequency: s.feedingFrequencyHour,
                  onChanged: (f) => context
                      .read<FeederBloc>()
                      .add(FeedingFrequencyChangedEvent(f)),
                ),
                SizedBox(height: AppTheme.spacing),
                FrequencyInput(
                  suffix: S.of(context).feeding_interval_minutes,
                  frequency: s.feedingFrequencyMinute,
                  onChanged: (f) => context
                      .read<FeederBloc>()
                      .add(FeedingFrequencyMinuteChangedEvent(f)),
                ),
                SizedBox(height: AppTheme.spacing),
                AmountInput(
                  amount: s.feedAmount,
                  onChanged: (a) =>
                      context.read<FeederBloc>().add(FeedAmountChangedEvent(a)),
                ),
                SizedBox(height: AppTheme.spacing),
                TimePickerInput(
                  label: S.of(context).first_feed_time,
                  time: s.firstFeedHour,
                  onTimeSelected: (t) => context
                      .read<FeederBloc>()
                      .add(FirstFeedTimeChangedEvent(t)),
                ),
                SizedBox(height: AppTheme.spacing),
                TimePickerInput(
                  label: S.of(context).last_feed_time,
                  time: s.lastFeedHour ??
                      _getDefaultLastFeedTime(s.firstFeedHour),
                  minTime: s.firstFeedHour,
                  isLastFeedTime: true,
                  onTimeSelected: (t) => context
                      .read<FeederBloc>()
                      .add(LastFeedTimeChangedEvent(t)),
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

  TimeOfDay _getDefaultLastFeedTime(TimeOfDay firstFeedTime) {
    final firstInMinutes = firstFeedTime.hour * 60 + firstFeedTime.minute;
    final defaultLastInMinutes = firstInMinutes + 120;

    return TimeOfDay(
      hour: (defaultLastInMinutes ~/ 60) % 24,
      minute: defaultLastInMinutes % 60,
    );
  }
}
