import 'package:flutter/material.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/generated/l10n.dart';

// Collapsible log header widget
class CollapsibleLogHeaderWidget extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;

  const CollapsibleLogHeaderWidget({
    Key? key,
    required this.isExpanded,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final S s = S.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Use dark gray background for header in dark mode
    final backgroundColor = isDarkMode
        ? Color(0xFF424242) // Dark gray for dark mode
        : theme.cardColor;

    final textColor = isDarkMode ? Colors.white : theme.colorScheme.onSurface;

    return GestureDetector(
      onTap: onToggle,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 2,
        color: backgroundColor,
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacing),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.list_alt,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: AppTheme.spacingSmall),
                  Text(
                    s.feeding_logs,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
