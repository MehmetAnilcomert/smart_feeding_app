import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/theme_bloc.dart';
import 'package:smart_feeding_app/generated/l10n.dart';

class DarkModeToggle extends StatelessWidget {
  const DarkModeToggle({
    super.key,
    required this.isDarkMode,
    required this.s,
  });

  final bool isDarkMode;
  final S s;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode
            ? AppTheme.cardDark.withOpacity(0.5)
            : Colors.grey.withOpacity(0.1),
      ),
      child: SwitchListTile(
        value: isDarkMode,
        onChanged: (_) => context.read<ThemeBloc>().toggleTheme(),
        title: Text(
          isDarkMode ? s.light_mode : s.dark_mode,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        secondary: Icon(
          isDarkMode ? Icons.light_mode : Icons.dark_mode,
          color:
              isDarkMode ? AppTheme.primaryLightBrown : AppTheme.primaryBrown,
        ),
      ),
    );
  }
}
