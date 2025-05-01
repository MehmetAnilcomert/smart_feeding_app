import 'package:flutter/material.dart';
import 'package:smart_feeding_app/app_theme.dart';

class CompactInputRow extends StatelessWidget {
  final int value;
  final String suffix;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final ValueChanged<int>? onSubmitted;

  const CompactInputRow({
    Key? key,
    required this.value,
    required this.suffix,
    required this.onIncrease,
    required this.onDecrease,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: value.toString());
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffixText: suffix,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppTheme.spacing,
                vertical: AppTheme.spacingSmall / 2,
              ),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.borderRadius / 2),
              ),
            ),
            textAlign: TextAlign.center,
            onSubmitted: (txt) {
              final v = int.tryParse(txt);
              if (v != null && onSubmitted != null) onSubmitted!(v);
            },
          ),
        ),
        SizedBox(width: AppTheme.spacingSmall),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius / 2),
          ),
          child: IconButton(
            icon: Icon(Icons.add, color: Colors.white, size: 16),
            onPressed: onIncrease,
            padding: EdgeInsets.all(4),
            constraints: BoxConstraints(minWidth: 28, minHeight: 28),
            visualDensity: VisualDensity.compact,
          ),
        ),
        SizedBox(width: AppTheme.spacingSmall / 2),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius / 2),
          ),
          child: IconButton(
            icon: Icon(Icons.remove, color: Colors.white, size: 16),
            onPressed: onDecrease,
            padding: EdgeInsets.all(4),
            constraints: BoxConstraints(minWidth: 28, minHeight: 28),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }
}
