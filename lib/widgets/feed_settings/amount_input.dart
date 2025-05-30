import 'package:flutter/material.dart';
import 'compact_input_row.dart';
import 'package:smart_feeding_app/generated/l10n.dart';

class AmountInput extends StatelessWidget {
  final double amount;
  final ValueChanged<double> onChanged;

  const AmountInput({
    required this.amount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CompactInputRow(
      value: amount.toInt(),
      suffix: S.of(context).grams_message,
      onIncrease: () => onChanged(amount + 10),
      onDecrease: () => onChanged((amount - 10).clamp(1, double.infinity)),
      onSubmitted: (v) => onChanged(v.toDouble().clamp(1.0, double.infinity)),
    );
  }
}
