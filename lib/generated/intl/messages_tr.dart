// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a tr locale. All the
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
  String get localeName => 'tr';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("Akıllı Besleyici"),
    "connection_error": MessageLookupByLibrary.simpleMessage("Bağlantı Hatası"),
    "connection_error_message": MessageLookupByLibrary.simpleMessage(
      "İnternet bağlantısı yok. Lütfen internet bağlantınızı kontrol edin ve tekrar deneyin.",
    ),
    "current_temperature": MessageLookupByLibrary.simpleMessage(
      "Güncel Sıcaklık",
    ),
    "feed": MessageLookupByLibrary.simpleMessage("Besleme"),
    "logs": MessageLookupByLibrary.simpleMessage("Kayıtlar"),
    "no_logs": MessageLookupByLibrary.simpleMessage("Kayıt bulunamadı."),
    "ok": MessageLookupByLibrary.simpleMessage("Tamam"),
    "set_feeding_frequency": MessageLookupByLibrary.simpleMessage(
      "Besleme Sıklığını Ayarla (günde kaç kez):",
    ),
    "temperature": MessageLookupByLibrary.simpleMessage("Sıcaklık"),
    "update_frequency": MessageLookupByLibrary.simpleMessage(
      "Sıklığı Güncelle",
    ),
  };
}
