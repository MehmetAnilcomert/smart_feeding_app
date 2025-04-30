import 'package:flutter/material.dart';
import 'package:smart_feeding_app/app_theme.dart';

Widget buildMenuItem(
  BuildContext context, {
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  bool isDestructive = false,
  required bool isDarkMode,
}) {
  final Color primaryColor =
      isDarkMode ? AppTheme.primaryLightBrown : AppTheme.primaryBrown;
  return Container(
    margin: EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: isDarkMode
          ? AppTheme.cardDark.withOpacity(0.5)
          : Colors.grey.withOpacity(0.1),
    ),
    child: ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isDestructive ? Colors.red : primaryColor),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive
              ? Colors.red
              : isDarkMode
                  ? Colors.white
                  : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isDestructive
            ? Colors.red
            : isDarkMode
                ? Colors.white.withOpacity(0.5)
                : Colors.grey,
        size: 20,
      ),
    ),
  );
}
