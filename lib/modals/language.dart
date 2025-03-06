import 'package:flutter/material.dart';

class LanguageManager {
  Locale _locale = Locale('tr'); // Default language is set to Turkish

  Locale get locale => _locale;

  void setLanguage(Locale locale) {
    _locale = locale;
  }
}
