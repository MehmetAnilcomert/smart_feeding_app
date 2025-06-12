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
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing,
                    vertical: AppTheme.spacingSmall / 2,
                  ),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppTheme.borderRadius / 2),
                  ),
                  // Daha doğal bir görünüm için hintStyle kullanımı
                  hintStyle: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                ),
                onSubmitted: (txt) {
                  final v = int.tryParse(txt);
                  if (v != null && onSubmitted != null) onSubmitted!(v);
                },
              ),
              Padding(
                padding: EdgeInsets.only(right: AppTheme.spacing),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                  child: Text(
                    suffix,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: AppTheme.spacingSmall),

        // Buttons container
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
