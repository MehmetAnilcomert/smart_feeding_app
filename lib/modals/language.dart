import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageManager {
  static const String _languageKey = 'selected_language';
  Locale _locale = const Locale('tr'); // Default dil

  Locale get locale => _locale;

  // SharedPreferences'tan dil tercihini yükle
  Future<void> loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode =
        prefs.getString(_languageKey) ?? 'tr'; // Default Türkçe
    _locale = Locale(languageCode);
  }

  // Dil tercihini SharedPreferences'a kaydet
  Future<void> setLanguage(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
  }
}
