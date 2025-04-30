import 'package:flutter/material.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/widgets/drawer/info_note.dart';

class HelpRow extends StatelessWidget {
  const HelpRow({
    super.key,
    required this.isDarkMode,
    required this.s,
    required GlobalKey<State<StatefulWidget>> helpIconKey,
  }) : _helpIconKey = helpIconKey;

  final bool isDarkMode;
  final S s;
  final GlobalKey<State<StatefulWidget>> _helpIconKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('help_tile'),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode
            ? AppTheme.cardDark.withOpacity(0.5)
            : Colors.grey.withOpacity(0.1),
      ),
      child: ListTile(
        onTap: () =>
            InfoNoteWidget.show(context, s.help_note, anchorKey: _helpIconKey),
        leading: Icon(
          Icons.help_outline,
          color:
              isDarkMode ? AppTheme.primaryLightBrown : AppTheme.primaryBrown,
        ),
        title: Text(
          s.help,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: CircleAvatar(
          key: _helpIconKey, // Add the key to the exclamation mark icon
          radius: 12,
          backgroundColor:
              isDarkMode ? AppTheme.primaryLightBrown : AppTheme.primaryBrown,
          child: Text(
            '!',
            style: TextStyle(
              color: isDarkMode ? Colors.black : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
