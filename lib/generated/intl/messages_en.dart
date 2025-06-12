// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(firstTime) =>
      "Last feed time must be after first feed time (${firstTime})";

  static String m1(id) => "ID: ${id}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("Smart Chicken Feeder"),
    "command_history": MessageLookupByLibrary.simpleMessage("Command History"),
    "connection_error_title": MessageLookupByLibrary.simpleMessage(
      "Connection Error",
    ),
    "connection_lost": MessageLookupByLibrary.simpleMessage("Connection Lost"),
    "connection_lost_message": MessageLookupByLibrary.simpleMessage(
      "Connection to the feeder device has been lost. Trying to reconnect...",
    ),
    "current_humidity": MessageLookupByLibrary.simpleMessage(
      "Current Humidity",
    ),
    "current_temperature": MessageLookupByLibrary.simpleMessage(
      "Current Temperature",
    ),
    "dark_mode": MessageLookupByLibrary.simpleMessage("Dark Mode"),
    "device_not_reachable_message": MessageLookupByLibrary.simpleMessage(
      "ESP32 device is not reachable. Please check your connection.",
    ),
    "en": MessageLookupByLibrary.simpleMessage("EN"),
    "error": MessageLookupByLibrary.simpleMessage("Error"),
    "error_loading_command_logs": MessageLookupByLibrary.simpleMessage(
      "Error loading command logs.\nPlease check your connection and try again.",
    ),
    "error_loading_system_logs": MessageLookupByLibrary.simpleMessage(
      "Error loading system logs.\nPlease check your connection and try again.",
    ),
    "feed": MessageLookupByLibrary.simpleMessage("Feed"),
    "feed_now": MessageLookupByLibrary.simpleMessage("Feed Now"),
    "feed_settings": MessageLookupByLibrary.simpleMessage("Feed Settings"),
    "feeding_interval_minutes": MessageLookupByLibrary.simpleMessage("minutes"),
    "feeding_logs": MessageLookupByLibrary.simpleMessage("Feeding Logs"),
    "first_feed_time": MessageLookupByLibrary.simpleMessage("First Feed Hour"),
    "general_error_message": MessageLookupByLibrary.simpleMessage(
      "An error occurred. Please try again.",
    ),
    "grams": MessageLookupByLibrary.simpleMessage("grams"),
    "grams_message": MessageLookupByLibrary.simpleMessage("grams"),
    "help": MessageLookupByLibrary.simpleMessage("Help"),
    "help_note": MessageLookupByLibrary.simpleMessage("Help Note: ..."),
    "high_humidity_warning": MessageLookupByLibrary.simpleMessage(
      "Humidity is too high!",
    ),
    "high_temperature_warning": MessageLookupByLibrary.simpleMessage(
      "High temperature! Consider cooling the coop.",
    ),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "invalid_time_range_message": MessageLookupByLibrary.simpleMessage(
      "Last feed time must be after first feed time.",
    ),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "last_feed_time": MessageLookupByLibrary.simpleMessage("Last Feed Hour"),
    "last_feed_time_error": MessageLookupByLibrary.simpleMessage(
      "Last feed time must be after first feed time!",
    ),
    "last_feed_time_help": m0,
    "light_mode": MessageLookupByLibrary.simpleMessage("Light Mode"),
    "log_id": m1,
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "low_humidity_warning": MessageLookupByLibrary.simpleMessage(
      "Humidity is too low!",
    ),
    "low_temperature_warning": MessageLookupByLibrary.simpleMessage(
      "Low temperature! Consider heating the coop.",
    ),
    "manual_feeding_initiated": MessageLookupByLibrary.simpleMessage(
      "Manual feeding initiated!",
    ),
    "no_command_logs_available": MessageLookupByLibrary.simpleMessage(
      "No command history available",
    ),
    "no_logs_available": MessageLookupByLibrary.simpleMessage(
      "No logs available",
    ),
    "no_system_logs_available": MessageLookupByLibrary.simpleMessage(
      "No system logs available",
    ),
    "notConnected": MessageLookupByLibrary.simpleMessage(
      "Could not connect to the device. Please check your device.",
    ),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "optimal_humidity_message": MessageLookupByLibrary.simpleMessage(
      "Humidity is optimal.",
    ),
    "optimal_temperature_message": MessageLookupByLibrary.simpleMessage(
      "Optimal temperature for your chickens.",
    ),
    "pull_to_refresh_logs": MessageLookupByLibrary.simpleMessage(
      "Pull down to refresh",
    ),
    "refresh_logs": MessageLookupByLibrary.simpleMessage("Refresh logs"),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "set_feed_amount": MessageLookupByLibrary.simpleMessage("Feed Amount"),
    "set_feeding_frequency": MessageLookupByLibrary.simpleMessage(
      "Feeding Frequency",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "settings_updated": MessageLookupByLibrary.simpleMessage(
      "Feed settings updated successfully!",
    ),
    "stats": MessageLookupByLibrary.simpleMessage("Statistics"),
    "system_logs": MessageLookupByLibrary.simpleMessage("System Logs"),
    "temperature_high": MessageLookupByLibrary.simpleMessage(
      "High temperature! Consider cooling the coop.",
    ),
    "temperature_low": MessageLookupByLibrary.simpleMessage(
      "Low temperature! Consider heating the coop.",
    ),
    "temperature_optimal": MessageLookupByLibrary.simpleMessage(
      "Optimal temperature for your chickens.",
    ),
    "time_range_error": MessageLookupByLibrary.simpleMessage(
      "Selected time is not in valid range!",
    ),
    "timeout_error_message": MessageLookupByLibrary.simpleMessage(
      "Request timed out. Please try again.",
    ),
    "timeout_error_title": MessageLookupByLibrary.simpleMessage(
      "Timeout Error",
    ),
    "times_per_day": MessageLookupByLibrary.simpleMessage("times/day"),
    "times_per_day_message": MessageLookupByLibrary.simpleMessage("hours"),
    "tr": MessageLookupByLibrary.simpleMessage("TR"),
    "update_settings": MessageLookupByLibrary.simpleMessage("Update Settings"),
    "user": MessageLookupByLibrary.simpleMessage("User"),
    "user_email": MessageLookupByLibrary.simpleMessage("user@example.com"),
    "validation_error_title": MessageLookupByLibrary.simpleMessage(
      "Validation Error",
    ),
  };
}
