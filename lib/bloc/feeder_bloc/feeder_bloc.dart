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
  static const _kFreqMinKey = 'feedingFrequencyMinute';
  static const _kAmtKey = 'feedAmount';
  static const _kTimeKey = 'firstFeedTime';
  static const _kLastTimeKey = 'lastFeedTime';

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

    // Eksik event handler'lar burada tanımlanıyor:
    on<FeedingFrequencyChangedEvent>((event, emit) {
      final s = state as FeederDataState;
      emit(s.copyWith(feedingFrequencyHour: event.frequency));
    });

    on<FeedAmountChangedEvent>((event, emit) {
      final s = state as FeederDataState;
      emit(s.copyWith(feedAmount: event.amount));
    });

    on<FirstFeedTimeChangedEvent>((event, emit) {
      final s = state as FeederDataState;
      emit(s.copyWith(firstFeedHour: event.time));
    });

    on<LastFeedTimeChangedEvent>((event, emit) {
      final s = state as FeederDataState;
      emit(s.copyWith(lastFeedHour: event.lastFeedTime));
    });

    // Eğer minute field'ı da değiştirilecekse (eklenmişse):
    on<FeedingFrequencyMinuteChangedEvent>((event, emit) {
      final s = state as FeederDataState;
      emit(s.copyWith(feedingFrequencyMinute: event.minute));
    });
  }

  Future<void> _onLoadSettings(
      LoadSettingsEvent e, Emitter<FeederState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final s = state as FeederDataState;

    final freq = prefs.getInt(_kFreqKey) ?? s.feedingFrequencyHour;
    final freqMin = prefs.getInt(_kFreqMinKey) ?? s.feedingFrequencyMinute;
    final amt = prefs.getDouble(_kAmtKey) ?? s.feedAmount;

    final firstStr = prefs.getString(_kTimeKey);
    final firstTime = firstStr != null
        ? TimeOfDay(
            hour: int.parse(firstStr.split(':')[0]),
            minute: int.parse(firstStr.split(':')[1]),
          )
        : s.firstFeedHour;

    final lastStr = prefs.getString(_kLastTimeKey);
    final lastTime = lastStr != null
        ? TimeOfDay(
            hour: int.parse(lastStr.split(':')[0]),
            minute: int.parse(lastStr.split(':')[1]),
          )
        : s.lastFeedHour;

    emit(s.copyWith(
      feedingFrequencyHour: freq,
      feedingFrequencyMinute: freqMin,
      feedAmount: amt,
      firstFeedHour: firstTime,
      lastFeedHour: lastTime,
    ));
  }

  Future<void> _onSaveSettings(
      SaveSettingsEvent e, Emitter<FeederState> emit) async {
    var s = state as FeederDataState;
    emit(s.copyWith(isSaving: true));

    try {
      final resp = await _api.setInterval(
        hourValue: s.feedingFrequencyHour,
        minuteValue: s.feedingFrequencyMinute,
        startHour: s.firstFeedHour.hour,
        endHour: s.lastFeedHour?.hour ?? ((s.firstFeedHour.hour + 12) % 24),
        amount: s.feedAmount,
      );

      if (!resp.success) {
        _notif.show(
            1,
            'Error',
            resp.message,
            NotificationDetails(
                android: AndroidNotificationDetails('channel', 'error',
                    importance: Importance.high)));
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kFreqKey, s.feedingFrequencyHour);
      await prefs.setInt(_kFreqMinKey, s.feedingFrequencyMinute);
      await prefs.setDouble(_kAmtKey, s.feedAmount);

      final firstStr =
          '${s.firstFeedHour.hour.toString().padLeft(2, '0')}:${s.firstFeedHour.minute.toString().padLeft(2, '0')}';
      await prefs.setString(_kTimeKey, firstStr);

      if (s.lastFeedHour != null) {
        final lastStr =
            '${s.lastFeedHour!.hour.toString().padLeft(2, '0')}:${s.lastFeedHour!.minute.toString().padLeft(2, '0')}';
        await prefs.setString(_kLastTimeKey, lastStr);
      }
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
        humidity: status.humidity ?? s.humidity,
        esp32Connected: status.esp32Connected,
        serverTime: status.serverTime,
      ));
    } catch (_) {/* ignore */}
  }
}
