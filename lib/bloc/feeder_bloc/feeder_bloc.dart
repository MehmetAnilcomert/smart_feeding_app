// lib/bloc/feeder_bloc/feeder_bloc.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_feeding_app/modals/apiException.dart';
import 'package:smart_feeding_app/services/feeder_api.dart';
import 'feeder_event.dart';
import 'feeder_state.dart';

class FeederBloc extends Bloc<FeederEvent, FeederState> {
  static const _kFreqKey = 'feedingFrequency';
  static const _kFreqMinKey = 'feedingFrequencyMinute';
  static const _kAmtKey = 'feedAmount';
  static const _kTimeKey = 'firstFeedTime';
  static const _kLastTimeKey = 'lastFeedTime';

  final FeederApiService _api;

  FeederBloc({required String httpUrl})
      : _api = FeederApiService(baseUrl: httpUrl),
        super(FeederDataState.initial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<SaveSettingsEvent>(_onSaveSettings);
    on<ManualFeedEvent>(_onManualFeed);
    on<FeederStatusFetchEvent>(_onFetchStatus);

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

    on<FeedingFrequencyMinuteChangedEvent>((event, emit) {
      final s = state as FeederDataState;
      emit(s.copyWith(feedingFrequencyMinute: event.minute));
    });

    on<FeedErrorEvent>((event, emit) async {
      final currentState = state;
      emit(FeedErrorState(event.messageCode));

      await Future.delayed(Duration(seconds: 3));
      if (currentState is FeederDataState) {
        emit(currentState);
      }
    });
  }

  bool _isTimeValid(TimeOfDay firstTime, TimeOfDay? lastTime) {
    if (lastTime == null) return true;

    int firstInMinutes = firstTime.hour * 60 + firstTime.minute;
    int lastInMinutes = lastTime.hour * 60 + lastTime.minute;

    return lastInMinutes > firstInMinutes;
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

    if (!_isTimeValid(s.firstFeedHour, s.lastFeedHour)) {
      add(FeedErrorEvent(4));
      return;
    }

    emit(s.copyWith(isSaving: true));

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kFreqKey, s.feedingFrequencyHour);
      await prefs.setInt(_kFreqMinKey, s.feedingFrequencyMinute);
      await prefs.setDouble(_kAmtKey, s.feedAmount);

      final firstStr =
          '${s.firstFeedHour.hour.toString().padLeft(2, '0')}:${s.firstFeedHour.minute.toString().padLeft(2, '0')}';
      await prefs.setString(_kTimeKey, firstStr);

      final lastStr =
          '${s.lastFeedHour.hour.toString().padLeft(2, '0')}:${s.lastFeedHour.minute.toString().padLeft(2, '0')}';
      await prefs.setString(_kLastTimeKey, lastStr);

      await _api
          .setInterval(
        hourValue: s.feedingFrequencyHour,
        minuteValue: s.feedingFrequencyMinute,
        startHour: s.firstFeedHour,
        endHour: s.lastFeedHour,
        amount: s.feedAmount,
      )
          .timeout(
        Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException(
              'API request timed out', Duration(seconds: 30));
        },
      );
    } on TimeoutException {
      add(FeedErrorEvent(1)); // Timeout error
    } catch (err) {
      if (err is ApiException && err.statusCode == 503) {
        add(FeedErrorEvent(1)); // ESP32 is not reachable
      } else {
        add(FeedErrorEvent(2)); // General error
      }
    } finally {
      emit(s.copyWith(isSaving: false));
    }
  }

  Future<void> _onManualFeed(
      ManualFeedEvent e, Emitter<FeederState> emit) async {
    final s = state as FeederDataState;
    try {
      await _api.triggerManualFeed(amount: s.feedAmount).timeout(
        Duration(seconds: 15), // Manuel besleme için 15 saniye timeout
        onTimeout: () {
          throw TimeoutException(
              'Manual feed request timed out', Duration(seconds: 15));
        },
      );
    } on TimeoutException {
      add(FeedErrorEvent(1)); // Timeout hatası
    } catch (err) {
      if (err is ApiException && err.statusCode == 503) {
        add(FeedErrorEvent(1)); // ESP32 is not reachable
      } else {
        add(FeedErrorEvent(2)); // Genel hata
      }
    }
  }

  Future<void> _onFetchStatus(
    FeederStatusFetchEvent e,
    Emitter<FeederState> emit,
  ) async {
    final s = state as FeederDataState;
    try {
      final status = await _api.getStatus().timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException(
              'Status request timed out', Duration(seconds: 10));
        },
      );

      emit(s.copyWith(
        temperature: status.temperature ?? s.temperature,
        humidity: status.humidity ?? s.humidity,
        esp32Connected: status.esp32Connected,
        serverTime: status.serverTime,
      ));
    } on TimeoutException {
      emit(s.copyWith(esp32Connected: false));
    } catch (_) {
      emit(s.copyWith(esp32Connected: false));
    }
  }
}
