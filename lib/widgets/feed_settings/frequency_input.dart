import 'package:flutter/material.dart';
import 'compact_input_row.dart';

class FrequencyInput extends StatelessWidget {
  final int frequency;
  final ValueChanged<int> onChanged;
  final String suffix;
  final bool isHour;

  const FrequencyInput({
    required this.frequency,
    required this.onChanged,
    required this.suffix,
    required this.isHour,
  });

  @override
  Widget build(BuildContext context) {
    final int upperBound = isHour ? 24 : 60;

    return CompactInputRow(
      value: frequency,
      suffix: suffix,
      onIncrease: () => onChanged((frequency + 1).clamp(1, upperBound)),
      onDecrease: () => onChanged((frequency - 1).clamp(1, upperBound)),
      onSubmitted: (v) => onChanged(v.clamp(0, upperBound)),
    );
  }
}
