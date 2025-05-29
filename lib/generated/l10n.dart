// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Smart Chicken Feeder`
  String get app_title {
    return Intl.message(
      'Smart Chicken Feeder',
      name: 'app_title',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Feed`
  String get feed {
    return Intl.message('Feed', name: 'feed', desc: '', args: []);
  }

  /// `Statistics`
  String get stats {
    return Intl.message('Statistics', name: 'stats', desc: '', args: []);
  }

  /// `Current Temperature`
  String get current_temperature {
    return Intl.message(
      'Current Temperature',
      name: 'current_temperature',
      desc: '',
      args: [],
    );
  }

  /// `High temperature! Consider cooling the coop.`
  String get temperature_high {
    return Intl.message(
      'High temperature! Consider cooling the coop.',
      name: 'temperature_high',
      desc: '',
      args: [],
    );
  }

  /// `Low temperature! Consider heating the coop.`
  String get temperature_low {
    return Intl.message(
      'Low temperature! Consider heating the coop.',
      name: 'temperature_low',
      desc: '',
      args: [],
    );
  }

  /// `Optimal temperature for your chickens.`
  String get temperature_optimal {
    return Intl.message(
      'Optimal temperature for your chickens.',
      name: 'temperature_optimal',
      desc: '',
      args: [],
    );
  }

  /// `Feed Settings`
  String get feed_settings {
    return Intl.message(
      'Feed Settings',
      name: 'feed_settings',
      desc: '',
      args: [],
    );
  }

  /// `Feeding Frequency`
  String get set_feeding_frequency {
    return Intl.message(
      'Feeding Frequency',
      name: 'set_feeding_frequency',
      desc: '',
      args: [],
    );
  }

  /// `Feed Amount`
  String get set_feed_amount {
    return Intl.message(
      'Feed Amount',
      name: 'set_feed_amount',
      desc: '',
      args: [],
    );
  }

  /// `First Feed Time`
  String get first_feed_time {
    return Intl.message(
      'First Feed Time',
      name: 'first_feed_time',
      desc: '',
      args: [],
    );
  }

  /// `Update Settings`
  String get update_settings {
    return Intl.message(
      'Update Settings',
      name: 'update_settings',
      desc: '',
      args: [],
    );
  }

  /// `Feed Now`
  String get feed_now {
    return Intl.message('Feed Now', name: 'feed_now', desc: '', args: []);
  }

  /// `Feeding Logs`
  String get feeding_logs {
    return Intl.message(
      'Feeding Logs',
      name: 'feeding_logs',
      desc: '',
      args: [],
    );
  }

  /// `No logs available`
  String get no_logs_available {
    return Intl.message(
      'No logs available',
      name: 'no_logs_available',
      desc: '',
      args: [],
    );
  }

  /// `Connection Lost`
  String get connection_lost {
    return Intl.message(
      'Connection Lost',
      name: 'connection_lost',
      desc: '',
      args: [],
    );
  }

  /// `Connection to the feeder device has been lost. Trying to reconnect...`
  String get connection_lost_message {
    return Intl.message(
      'Connection to the feeder device has been lost. Trying to reconnect...',
      name: 'connection_lost_message',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `times/day`
  String get times_per_day {
    return Intl.message('times/day', name: 'times_per_day', desc: '', args: []);
  }

  /// `grams`
  String get grams {
    return Intl.message('grams', name: 'grams', desc: '', args: []);
  }

  /// `Feed settings updated successfully!`
  String get settings_updated {
    return Intl.message(
      'Feed settings updated successfully!',
      name: 'settings_updated',
      desc: '',
      args: [],
    );
  }

  /// `Manual feeding initiated!`
  String get manual_feeding_initiated {
    return Intl.message(
      'Manual feeding initiated!',
      name: 'manual_feeding_initiated',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get user {
    return Intl.message('User', name: 'user', desc: '', args: []);
  }

  /// `user@example.com`
  String get user_email {
    return Intl.message(
      'user@example.com',
      name: 'user_email',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Help`
  String get help {
    return Intl.message('Help', name: 'help', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Dark Mode`
  String get dark_mode {
    return Intl.message('Dark Mode', name: 'dark_mode', desc: '', args: []);
  }

  /// `Light Mode`
  String get light_mode {
    return Intl.message('Light Mode', name: 'light_mode', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `EN`
  String get en {
    return Intl.message('EN', name: 'en', desc: '', args: []);
  }

  /// `TR`
  String get tr {
    return Intl.message('TR', name: 'tr', desc: '', args: []);
  }

  /// `High temperature! Consider cooling the coop.`
  String get high_temperature_warning {
    return Intl.message(
      'High temperature! Consider cooling the coop.',
      name: 'high_temperature_warning',
      desc: '',
      args: [],
    );
  }

  /// `Low temperature! Consider heating the coop.`
  String get low_temperature_warning {
    return Intl.message(
      'Low temperature! Consider heating the coop.',
      name: 'low_temperature_warning',
      desc: '',
      args: [],
    );
  }

  /// `Optimal temperature for your chickens.`
  String get optimal_temperature_message {
    return Intl.message(
      'Optimal temperature for your chickens.',
      name: 'optimal_temperature_message',
      desc: '',
      args: [],
    );
  }

  /// `hours`
  String get times_per_day_message {
    return Intl.message(
      'hours',
      name: 'times_per_day_message',
      desc: '',
      args: [],
    );
  }

  /// `grams`
  String get grams_message {
    return Intl.message('grams', name: 'grams_message', desc: '', args: []);
  }

  /// `Help Note: ...`
  String get help_note {
    return Intl.message(
      'Help Note: ...',
      name: 'help_note',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `minutes`
  String get feeding_interval_minutes {
    return Intl.message(
      'minutes',
      name: 'feeding_interval_minutes',
      desc: '',
      args: [],
    );
  }

  /// `Last Feed Hour`
  String get last_feed_time {
    return Intl.message(
      'Last Feed Hour',
      name: 'last_feed_time',
      desc: '',
      args: [],
    );
  }

  /// `Could not connect to the device. Please check your device.`
  String get notConnected {
    return Intl.message(
      'Could not connect to the device. Please check your device.',
      name: 'notConnected',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Current Humidity`
  String get current_humidity {
    return Intl.message(
      'Current Humidity',
      name: 'current_humidity',
      desc: '',
      args: [],
    );
  }

  /// `Humidity is too low!`
  String get low_humidity_warning {
    return Intl.message(
      'Humidity is too low!',
      name: 'low_humidity_warning',
      desc: '',
      args: [],
    );
  }

  /// `Humidity is too high!`
  String get high_humidity_warning {
    return Intl.message(
      'Humidity is too high!',
      name: 'high_humidity_warning',
      desc: '',
      args: [],
    );
  }

  /// `Humidity is optimal.`
  String get optimal_humidity_message {
    return Intl.message(
      'Humidity is optimal.',
      name: 'optimal_humidity_message',
      desc: '',
      args: [],
    );
  }

  /// `Last feed time must be after first feed time ({firstTime})`
  String last_feed_time_help(String firstTime) {
    return Intl.message(
      'Last feed time must be after first feed time ($firstTime)',
      name: 'last_feed_time_help',
      desc: '',
      args: [firstTime],
    );
  }

  /// `Last feed time must be after first feed time!`
  String get last_feed_time_error {
    return Intl.message(
      'Last feed time must be after first feed time!',
      name: 'last_feed_time_error',
      desc: '',
      args: [],
    );
  }

  /// `Selected time is not in valid range!`
  String get time_range_error {
    return Intl.message(
      'Selected time is not in valid range!',
      name: 'time_range_error',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'tr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
