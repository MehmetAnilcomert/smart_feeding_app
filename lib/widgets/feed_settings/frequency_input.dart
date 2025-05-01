import 'package:flutter/material.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'compact_input_row.dart';
import 'package:smart_feeding_app/generated/l10n.dart';

class FrequencyInput extends StatelessWidget {
  final int frequency;
  final ValueChanged<int> onChanged;

  const FrequencyInput({
    required this.frequency,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CompactInputRow(
      value: frequency,
      suffix: S.of(context).times_per_day,
      onIncrease: () => onChanged((frequency + 1).clamp(1, 10)),
      onDecrease: () => onChanged((frequency - 1).clamp(1, 10)),
      onSubmitted: (v) => onChanged(v.clamp(1, 10)),
    );
  }
}
