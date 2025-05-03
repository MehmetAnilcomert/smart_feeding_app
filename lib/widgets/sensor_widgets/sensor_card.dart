import 'package:flutter/material.dart';
import 'package:smart_feeding_app/app_theme.dart';

class SensorCard extends StatelessWidget {
  final String title;
  final String displayValue;
  final String unit;
  final List<Color> gradient;
  final IconData icon;
  final String message;

  const SensorCard({
    required this.title,
    required this.displayValue,
    required this.unit,
    required this.gradient,
    required this.icon,
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: AppTheme.cardElevation,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        // Using LayoutBuilder to enforce consistency while allowing multi-line text
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate sizes based on available space
            final availableHeight = constraints.maxHeight;
            final titleHeight = availableHeight * 0.2; // 20% for title
            final valueHeight = availableHeight * 0.4; // 40% for value
            final messageHeight = availableHeight * 0.25; // 25% for message
            final spacing = availableHeight * 0.055; // 15% for spacing

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section with auto-sizing text
                Container(
                  height: titleHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title that wraps to second line if needed
                      Expanded(
                        child: AutoSizeText(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                          minFontSize: 12,
                          maxLines: 2,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(icon, color: theme.colorScheme.onPrimary, size: 24),
                    ],
                  ),
                ),

                SizedBox(height: spacing),

                // Display value with proper sizing
                Container(
                  height: valueHeight,
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "$displayValue$unit",
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: spacing),

                // Message at bottom that can wrap to multiple lines
                Container(
                  height: messageHeight,
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                    minFontSize: 10,
                    maxLines: 3,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// AutoSizeText widget implementation for text scaling
class AutoSizeText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;
  final double minFontSize;
  final TextOverflow overflow;

  const AutoSizeText(
    this.text, {
    this.style,
    this.maxLines = 1,
    this.minFontSize = 10.0,
    this.overflow = TextOverflow.ellipsis,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: text,
          style: style,
        );

        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: maxLines,
        );

        double fontSize = style?.fontSize ?? 14.0;

        // Try decreasing font size until it fits or reaches minimum
        while (fontSize > minFontSize) {
          textPainter.textScaleFactor = fontSize / (style?.fontSize ?? 14.0);
          textPainter.layout(maxWidth: constraints.maxWidth);

          if (!textPainter.didExceedMaxLines &&
              textPainter.height <= constraints.maxHeight) {
            break;
          }

          fontSize -= 0.5;
        }

        return Text(
          text,
          style: style?.copyWith(fontSize: fontSize),
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}
