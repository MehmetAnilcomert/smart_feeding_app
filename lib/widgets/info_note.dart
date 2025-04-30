import 'package:flutter/material.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/modals/triangle_pointer.dart';

/// A small note popup that appears directly below the triggering widget with a pointer.
class InfoNoteWidget extends StatelessWidget {
  final String note;
  final GlobalKey? anchorKey;

  const InfoNoteWidget({
    Key? key,
    required this.note,
    this.anchorKey,
  }) : super(key: key);

  /// Shows the info note popup. Tapping outside dismisses it.
  static void show(BuildContext context, String note, {GlobalKey? anchorKey}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (_) => InfoNoteWidget(note: note, anchorKey: anchorKey),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark ? AppTheme.cardDark : AppTheme.cardLight;
    final borderColor = isDark ? Colors.white30 : Colors.black26;

    // Calculate position based on the anchor widget if provided
    Offset? notePosition;
    double noteWidth = 200.0; // Set a fixed width for the note
    double arrowOffset = 0; // Horizontal offset for the arrow

    if (anchorKey != null && anchorKey!.currentContext != null) {
      final RenderBox renderBox =
          anchorKey!.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;

      final exclamationCenter = position.dx + size.width / 2;

      notePosition = Offset(
        exclamationCenter - noteWidth / 2,
        position.dy + size.height + 8,
      );

      arrowOffset = noteWidth / 2 - 8;

      final screenWidth = MediaQuery.of(context).size.width;
      if (notePosition.dx < 16) {
        arrowOffset -= (16 - notePosition.dx);
        notePosition = Offset(16, notePosition.dy);
      }
      if (notePosition.dx + noteWidth > screenWidth - 16) {
        arrowOffset += (notePosition.dx + noteWidth - (screenWidth - 16));
        notePosition = Offset(screenWidth - 16 - noteWidth, notePosition.dy);
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: [
            // Arrow pointing up
            if (notePosition != null)
              Positioned(
                left: notePosition.dx + arrowOffset,
                top: notePosition.dy - 8,
                child: CustomPaint(
                  size: Size(16, 8),
                  painter: TrianglePointer(backgroundColor, borderColor),
                ),
              ),

            // The note box
            Positioned(
              left: notePosition?.dx ?? 32,
              top: notePosition?.dy ??
                  (MediaQuery.of(context).padding.top + kToolbarHeight + 16),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: noteWidth,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    note,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
