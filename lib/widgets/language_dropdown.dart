import 'package:flutter/material.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/language_bloc.dart';
import 'package:smart_feeding_app/generated/l10n.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({
    super.key,
    required this.currentLanguage,
    required this.isDarkMode,
    required this.languageCubit,
  });

  final AppLanguage currentLanguage;
  final bool isDarkMode;
  final LanguageCubit languageCubit;

  @override
  Widget build(BuildContext context) {
    final S s = S.of(context);

    return DropdownButton<AppLanguage>(
      value: currentLanguage,
      icon: Icon(
        Icons.arrow_drop_down,
        color: isDarkMode ? AppTheme.primaryLightBrown : AppTheme.primaryBrown,
      ),
      underline: SizedBox(),
      dropdownColor: isDarkMode ? AppTheme.cardDark : AppTheme.cardLight,
      items: AppLanguage.values.map((lang) {
        return DropdownMenuItem<AppLanguage>(
          value: lang,
          child: Text(
            lang == AppLanguage.en ? s.en : s.tr,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          languageCubit.changeLanguage(value);
        }
      },
    );
  }
}
