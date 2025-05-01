import 'package:flutter/material.dart';
import 'package:smart_feeding_app/app_theme.dart';

class TimePickerInput extends StatelessWidget {
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onTimeSelected;

  const TimePickerInput({
    required this.time,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null && picked != time) onTimeSelected(picked);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.spacing,
          vertical: AppTheme.spacingSmall,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(time.format(context), style: TextStyle(fontSize: 16)),
            Icon(Icons.access_time),
          ],
        ),
      ),
    );
  }
}
