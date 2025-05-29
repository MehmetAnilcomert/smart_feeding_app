// lib/widgets/feed_settings/time_picker_input.dart
import 'package:flutter/material.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/widgets/feed_settings/time_picker/time_picker_logic.dart';
import 'package:smart_feeding_app/widgets/feed_settings/time_picker/time_picker_messages.dart';
import 'package:smart_feeding_app/widgets/feed_settings/time_picker/time_picker_styles.dart';

class TimePickerInput extends StatelessWidget {
  final String? label;
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onTimeSelected;
  final TimeOfDay? minTime;
  final TimeOfDay? maxTime;
  final bool isLastFeedTime;

  const TimePickerInput({
    Key? key,
    this.label,
    required this.time,
    required this.onTimeSelected,
    this.minTime,
    this.maxTime,
    this.isLastFeedTime = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = TimePickerLogic(
      minTime: minTime,
      maxTime: maxTime,
      isLastFeedTime: isLastFeedTime,
    );

    final hasError = logic.hasValidationError(time);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context),
        _buildTimeSelector(context, logic, hasError),
        _buildHelpText(context),
      ],
    );
  }

  Widget _buildLabel(BuildContext context) {
    if (label == null) return SizedBox.shrink();

    return Column(
      children: [
        Text(
          label!,
          style: TimePickerStyles.labelStyle(context),
        ),
        SizedBox(height: AppTheme.spacingSmall),
      ],
    );
  }

  Widget _buildTimeSelector(
      BuildContext context, TimePickerLogic logic, bool hasError) {
    return InkWell(
      onTap: () => _handleTimeTap(context, logic),
      child: Container(
        padding: TimePickerStyles.containerPadding(),
        decoration:
            TimePickerStyles.containerDecoration(context, hasError: hasError),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time.format(context),
              style:
                  TimePickerStyles.timeTextStyle(context, hasError: hasError),
            ),
            Icon(
              Icons.access_time,
              color: TimePickerStyles.iconColor(context, hasError: hasError),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpText(BuildContext context) {
    if (!isLastFeedTime || minTime == null) {
      return SizedBox.shrink();
    }

    final logic = TimePickerLogic(
      minTime: minTime,
      maxTime: maxTime,
      isLastFeedTime: isLastFeedTime,
    );

    if (!logic.hasValidationError(time)) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Theme.of(context).colorScheme.error.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: Theme.of(context).colorScheme.error,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  TimePickerMessages.getHelpText(context, minTime!),
                  style: TimePickerStyles.helpTextStyle(context).copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleTimeTap(
      BuildContext context, TimePickerLogic logic) async {
    final picked = await logic.showTimePickerDialog(context, time);

    if (picked != null && picked != time) {
      if (logic.validateSelectedTime(context, picked)) {
        onTimeSelected(picked);
      }
    }
  }
}
