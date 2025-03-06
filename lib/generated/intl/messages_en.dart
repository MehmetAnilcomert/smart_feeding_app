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

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("Smart Chicken Feeder"),
    "connection_lost": MessageLookupByLibrary.simpleMessage("Connection Lost"),
    "connection_lost_message": MessageLookupByLibrary.simpleMessage(
      "Connection to the feeder device has been lost. Trying to reconnect...",
    ),
    "current_temperature": MessageLookupByLibrary.simpleMessage(
      "Current Temperature",
    ),
    "feed": MessageLookupByLibrary.simpleMessage("Feed"),
    "feed_now": MessageLookupByLibrary.simpleMessage("Feed Now"),
    "feed_settings": MessageLookupByLibrary.simpleMessage("Feed Settings"),
    "feeding_logs": MessageLookupByLibrary.simpleMessage("Feeding Logs"),
    "first_feed_time": MessageLookupByLibrary.simpleMessage("First Feed Time"),
    "grams": MessageLookupByLibrary.simpleMessage("grams"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "manual_feeding_initiated": MessageLookupByLibrary.simpleMessage(
      "Manual feeding initiated!",
    ),
    "no_logs_available": MessageLookupByLibrary.simpleMessage(
      "No logs available",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "set_feed_amount": MessageLookupByLibrary.simpleMessage("Feed Amount"),
    "set_feeding_frequency": MessageLookupByLibrary.simpleMessage(
      "Feeding Frequency",
    ),
    "settings_updated": MessageLookupByLibrary.simpleMessage(
      "Feed settings updated successfully!",
    ),
    "stats": MessageLookupByLibrary.simpleMessage("Statistics"),
    "temperature_high": MessageLookupByLibrary.simpleMessage(
      "High temperature! Consider cooling the coop.",
    ),
    "temperature_low": MessageLookupByLibrary.simpleMessage(
      "Low temperature! Consider heating the coop.",
    ),
    "temperature_optimal": MessageLookupByLibrary.simpleMessage(
      "Optimal temperature for your chickens.",
    ),
    "times_per_day": MessageLookupByLibrary.simpleMessage("times/day"),
    "update_settings": MessageLookupByLibrary.simpleMessage("Update Settings"),
  };
}
