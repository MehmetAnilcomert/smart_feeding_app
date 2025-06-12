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

  static String m0(amount) => "Beslenen Miktar: ${amount}";

  static String m1(minutes, start, end) =>
      "${start}–${end} saatleri arasında ${minutes} dakikada aralıklarla";

  static String m2(h, m, a, s, e) =>
      "Besleme aralığı ayarlandı: ${h}s ${m}d, miktar: ${a}g, ${s}–${e} arasında";

  static String m3(firstTime) =>
      "Son besleme saati, ilk besleme saatinden (${firstTime}) sonra olmalıdır";

  static String m4(id) => "No: ${id}";

  static String m5(temp, hum) =>
      "Sensör verisi kaydedildi: ${temp}, Nem: ${hum}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_title": MessageLookupByLibrary.simpleMessage("Akıllı Tavuk Besleyici"),
    "command_history": MessageLookupByLibrary.simpleMessage("Komut Geçmişi"),
    "connection_error_title": MessageLookupByLibrary.simpleMessage(
      "Bağlantı Hatası",
    ),
    "connection_lost": MessageLookupByLibrary.simpleMessage("Bağlantı Kesildi"),
    "connection_lost_message": MessageLookupByLibrary.simpleMessage(
      "Besleyici cihazla bağlantı kesildi. Yeniden bağlanmaya çalışılıyor...",
    ),
    "current_humidity": MessageLookupByLibrary.simpleMessage("Mevcut Nem"),
    "current_temperature": MessageLookupByLibrary.simpleMessage(
      "Mevcut Sıcaklık",
    ),
    "dark_mode": MessageLookupByLibrary.simpleMessage("Karanlık Mod"),
    "dashboard_tab": MessageLookupByLibrary.simpleMessage("Yönetim Paneli"),
    "device_not_reachable_message": MessageLookupByLibrary.simpleMessage(
      "ESP32 cihazına ulaşılamıyor. Lütfen bağlantınızı kontrol edin.",
    ),
    "en": MessageLookupByLibrary.simpleMessage("EN"),
    "error": MessageLookupByLibrary.simpleMessage("Hata"),
    "error_loading_command_logs": MessageLookupByLibrary.simpleMessage(
      "Komut geçmişi yüklenirken hata oluştu.\nLütfen bağlantınızı kontrol edin ve tekrar deneyin.",
    ),
    "error_loading_system_logs": MessageLookupByLibrary.simpleMessage(
      "Sistem günlükleri yüklenirken hata oluştu.\nLütfen bağlantınızı kontrol edin ve tekrar deneyin.",
    ),
    "feed": MessageLookupByLibrary.simpleMessage("Besleme"),
    "feed_amount": m0,
    "feed_interval": m1,
    "feed_interval_set": m2,
    "feed_now": MessageLookupByLibrary.simpleMessage("Şimdi Besle"),
    "feed_settings": MessageLookupByLibrary.simpleMessage("Besleme Ayarları"),
    "feeding_interval_minutes": MessageLookupByLibrary.simpleMessage("dakika"),
    "feeding_logs": MessageLookupByLibrary.simpleMessage("Besleme Kayıtları"),
    "first_feed_time": MessageLookupByLibrary.simpleMessage(
      "İlk Besleme Saati",
    ),
    "general_error_message": MessageLookupByLibrary.simpleMessage(
      "Bir hata oluştu. Lütfen tekrar deneyin.",
    ),
    "grams": MessageLookupByLibrary.simpleMessage("gram"),
    "grams_message": MessageLookupByLibrary.simpleMessage("gram"),
    "help": MessageLookupByLibrary.simpleMessage("Yardım"),
    "help_note": MessageLookupByLibrary.simpleMessage("Yardım Notu: ..."),
    "high_humidity_warning": MessageLookupByLibrary.simpleMessage(
      "Nem oranı oldukça yüksek!",
    ),
    "high_temperature_warning": MessageLookupByLibrary.simpleMessage(
      "Yüksek Sıcaklık! Kümesi soğutmalısın.",
    ),
    "home": MessageLookupByLibrary.simpleMessage("Ana Sayfa"),
    "invalid_time_range_message": MessageLookupByLibrary.simpleMessage(
      "Son besleme saati, ilk besleme saatinden sonra olmalıdır.",
    ),
    "language": MessageLookupByLibrary.simpleMessage("Dil"),
    "last_feed_time": MessageLookupByLibrary.simpleMessage("Son Besleme Saati"),
    "last_feed_time_error": MessageLookupByLibrary.simpleMessage(
      "Son besleme saati, ilk besleme saatinden sonra olmalıdır!",
    ),
    "last_feed_time_help": m3,
    "light_mode": MessageLookupByLibrary.simpleMessage("Aydınlık Mod"),
    "log_id": m4,
    "logout": MessageLookupByLibrary.simpleMessage("Çıkış Yap"),
    "logs_tab": MessageLookupByLibrary.simpleMessage("Kayıtlar"),
    "low_humidity_warning": MessageLookupByLibrary.simpleMessage(
      "Nem oranı oldukça düşük!",
    ),
    "low_temperature_warning": MessageLookupByLibrary.simpleMessage(
      "Düşük sıcaklık! Kümesi ısıtmalısın.",
    ),
    "manual_feeding_initiated": MessageLookupByLibrary.simpleMessage(
      "Manuel besleme başlatıldı!",
    ),
    "no_command_logs_available": MessageLookupByLibrary.simpleMessage(
      "Komut geçmişi bulunamadı",
    ),
    "no_logs_available": MessageLookupByLibrary.simpleMessage(
      "Kayıt bulunamadı",
    ),
    "no_system_logs_available": MessageLookupByLibrary.simpleMessage(
      "Sistem günlükleri bulunamadı",
    ),
    "notConnected": MessageLookupByLibrary.simpleMessage(
      "Cihaza bağlanılamadı. Lütfen cihazınızı kontrol edin.",
    ),
    "ok": MessageLookupByLibrary.simpleMessage("Tamam"),
    "optimal_humidity_message": MessageLookupByLibrary.simpleMessage(
      "Nem oranı ideal miktarda.",
    ),
    "pull_to_refresh_logs": MessageLookupByLibrary.simpleMessage(
      "Yenilemek için aşağı çekin",
    ),
    "refresh_logs": MessageLookupByLibrary.simpleMessage("Yenile"),
    "retry": MessageLookupByLibrary.simpleMessage("Tekrar Dene"),
    "set_feed_amount": MessageLookupByLibrary.simpleMessage("Yem Miktarı"),
    "set_feeding_frequency": MessageLookupByLibrary.simpleMessage(
      "Besleme Sıklığı",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Ayarlar"),
    "settings_updated": MessageLookupByLibrary.simpleMessage(
      "Besleme ayarları başarıyla güncellendi!",
    ),
    "stats": MessageLookupByLibrary.simpleMessage("İstatistikler"),
    "system_logs": MessageLookupByLibrary.simpleMessage("Sistem Günlükleri"),
    "temperature_high": MessageLookupByLibrary.simpleMessage(
      "Yüksek sıcaklık! Kümesi soğutmayı düşünün.",
    ),
    "temperature_log": m5,
    "temperature_low": MessageLookupByLibrary.simpleMessage(
      "Düşük sıcaklık! Kümesi ısıtmayı düşünün.",
    ),
    "temperature_optimal": MessageLookupByLibrary.simpleMessage(
      "Tavuklarınız için optimal sıcaklık.",
    ),
    "time_range_error": MessageLookupByLibrary.simpleMessage(
      "Seçilen saat geçerli aralıkta değil!",
    ),
    "timeout_error_message": MessageLookupByLibrary.simpleMessage(
      "İstek zaman aşımına uğradı. Lütfen tekrar deneyin.",
    ),
    "timeout_error_title": MessageLookupByLibrary.simpleMessage(
      "Zaman Aşımı Hatası",
    ),
    "times_per_day": MessageLookupByLibrary.simpleMessage("saat"),
    "times_per_day_message": MessageLookupByLibrary.simpleMessage("defa/gün"),
    "tr": MessageLookupByLibrary.simpleMessage("TR"),
    "update_settings": MessageLookupByLibrary.simpleMessage(
      "Ayarları Güncelle",
    ),
    "user": MessageLookupByLibrary.simpleMessage("Kullanıcı"),
    "user_email": MessageLookupByLibrary.simpleMessage("kullanici@ornek.com"),
    "validation_error_title": MessageLookupByLibrary.simpleMessage(
      "Doğrulama Hatası",
    ),
  };
}
