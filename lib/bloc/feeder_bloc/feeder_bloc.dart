// lib/bloc/feeder_bloc/feeder_bloc.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_feeding_app/services/feeder_api.dart';
import 'feeder_event.dart';
import 'feeder_state.dart';

class FeederBloc extends Bloc<FeederEvent, FeederState> {
  static const _kFreqKey = 'feedingFrequency';
  static const _kAmtKey = 'feedAmount';
  static const _kTimeKey = 'firstFeedTime';

  final FlutterLocalNotificationsPlugin _notif =
      FlutterLocalNotificationsPlugin();
  final FeederApiService _api;

  FeederBloc({required String baseUrl})
      : _api = FeederApiService(baseUrl: baseUrl),
        super(FeederDataState.initial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<SaveSettingsEvent>(_onSaveSettings);
    on<ManualFeedEvent>(_onManualFeed);
    on<FeederStatusFetchEvent>(_onFetchStatus);

    _init();
  }

  Future<void> _init() async {
    add(LoadSettingsEvent());
    add(FeederStatusFetchEvent());
  }

  Future<void> _onLoadSettings(
      LoadSettingsEvent e, Emitter<FeederState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final s = state as FeederDataState;

    final freq = prefs.getInt(_kFreqKey) ?? s.feedingFrequency;
    final amt = prefs.getDouble(_kAmtKey) ?? s.feedAmount;
    final tstr = prefs.getString(_kTimeKey);
    final time = tstr != null
        ? TimeOfDay(
            hour: int.parse(tstr.split(':')[0]),
            minute: int.parse(tstr.split(':')[1]),
          )
        : s.firstFeedTime;

    emit(s.copyWith(
      feedingFrequency: freq,
      feedAmount: amt,
      firstFeedTime: time,
    ));
  }

  Future<void> _onSaveSettings(
      SaveSettingsEvent e, Emitter<FeederState> emit) async {
    var s = state as FeederDataState;
    emit(s.copyWith(isSaving: true));

    try {
      // 1) /set-interval endpoint
      final resp = await _api.setInterval(
        hourValue: s.feedingFrequency, // örneğin frekansı kullanıyoruz
        minuteValue: 0, // Burayı ihtiyacınıza göre ayarlayın
        startHour: s.firstFeedTime.hour,
        endHour: (s.firstFeedTime.hour + 12) % 24, // örnek
        amount: s.feedAmount,
      );

      // Başarılı değilse Snackbar veya bildirim gönderebilirsiniz
      if (!resp.success) {
        _notif.show(
            1,
            'Error',
            resp.message,
            NotificationDetails(
                android: AndroidNotificationDetails('channel', 'error',
                    importance: Importance.high)));
      }

      // 2) Local kaydetme
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kFreqKey, s.feedingFrequency);
      await prefs.setDouble(_kAmtKey, s.feedAmount);
      final ts = s.firstFeedTime.hour.toString().padLeft(2, '0') +
          ':' +
          s.firstFeedTime.minute.toString().padLeft(2, '0');
      await prefs.setString(_kTimeKey, ts);
    } catch (err) {
      _notif.show(
          2,
          'Save Error',
          err.toString(),
          NotificationDetails(
              android: AndroidNotificationDetails('channel', 'error',
                  importance: Importance.high)));
    } finally {
      s = state as FeederDataState;
      emit(s.copyWith(isSaving: false));
    }
  }

  Future<void> _onManualFeed(
      ManualFeedEvent e, Emitter<FeederState> emit) async {
    final s = state as FeederDataState;
    try {
      final resp = await _api.triggerManualFeed(amount: s.feedAmount);
      // Bildirimle geri bildirim verebilirsiniz:
      _notif.show(
          3,
          resp.success ? 'Feeding' : 'Error',
          resp.message,
          NotificationDetails(
              android: AndroidNotificationDetails('channel', 'manual_feed',
                  importance: Importance.high)));
    } catch (err) {
      _notif.show(
          4,
          'Feed Error',
          err.toString(),
          NotificationDetails(
              android: AndroidNotificationDetails('channel', 'error',
                  importance: Importance.high)));
    }
  }

  Future<void> _onFetchStatus(
    FeederStatusFetchEvent e,
    Emitter<FeederState> emit,
  ) async {
    final s = state as FeederDataState;
    try {
      final status = await _api.getStatus();

      emit(s.copyWith(
        temperature: status.temperature ?? s.temperature,
        // istersen humidity, esp32Connected vs. ekle
      ));
    } catch (_) {/* ignore */}
  }
}
