import 'package:flutter/material.dart';
import 'compact_input_row.dart';

class FrequencyInput extends StatelessWidget {
  final int frequency;
  final ValueChanged<int> onChanged;
  final String suffix;

  const FrequencyInput({
    required this.frequency,
    required this.onChanged,
    required this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return CompactInputRow(
      value: frequency,
      suffix: suffix,
      onIncrease: () => onChanged((frequency + 1).clamp(1, 10)),
      onDecrease: () => onChanged((frequency - 1).clamp(1, 10)),
      onSubmitted: (v) => onChanged(v.clamp(1, 10)),
    );
  }
}
