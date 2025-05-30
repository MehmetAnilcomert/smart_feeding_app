// lib/bloc/feeder_bloc/feeder_state.dart
import 'package:flutter/material.dart';

abstract class FeederState {
  const FeederState();
}

class FeederDataState extends FeederState {
  final List<String> logs;
  final double temperature;
  final int feedingFrequencyHour;
  final int feedingFrequencyMinute;
  final double feedAmount;
  final TimeOfDay firstFeedHour;
  final TimeOfDay? lastFeedHour;
  final bool isSaving;
  final double humidity;
  final bool esp32Connected;
  final DateTime? serverTime;
  final int? errorCode; // Add error code here

  const FeederDataState({
    required this.logs,
    required this.temperature,
    required this.feedingFrequencyHour,
    required this.feedingFrequencyMinute,
    required this.feedAmount,
    required this.firstFeedHour,
    this.lastFeedHour,
    this.isSaving = false,
    required this.humidity,
    this.esp32Connected = false,
    this.serverTime,
    this.errorCode,
  });

  factory FeederDataState.initial() => FeederDataState(
        logs: [],
        temperature: 0.0,
        feedingFrequencyHour: 1,
        feedingFrequencyMinute: 0,
        feedAmount: 100.0,
        firstFeedHour: TimeOfDay(hour: 7, minute: 0),
        lastFeedHour: TimeOfDay(hour: 19, minute: 0),
        isSaving: false,
        humidity: 0.0,
        esp32Connected: false,
        serverTime: null,
        errorCode: null,
      );

  FeederDataState copyWith({
    List<String>? logs,
    double? temperature,
    int? feedingFrequencyHour,
    int? feedingFrequencyMinute,
    double? feedAmount,
    TimeOfDay? firstFeedHour,
    TimeOfDay? lastFeedHour,
    bool? isSaving,
    double? humidity,
    bool? esp32Connected,
    DateTime? serverTime,
    int? errorCode,
    bool clearError = false,
  }) {
    return FeederDataState(
      logs: logs ?? this.logs,
      temperature: temperature ?? this.temperature,
      feedingFrequencyHour: feedingFrequencyHour ?? this.feedingFrequencyHour,
      feedingFrequencyMinute:
          feedingFrequencyMinute ?? this.feedingFrequencyMinute,
      feedAmount: feedAmount ?? this.feedAmount,
      firstFeedHour: firstFeedHour ?? this.firstFeedHour,
      lastFeedHour: lastFeedHour ?? this.lastFeedHour,
      isSaving: isSaving ?? this.isSaving,
      humidity: humidity ?? this.humidity,
      esp32Connected: esp32Connected ?? this.esp32Connected,
      serverTime: serverTime ?? this.serverTime,
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
    );
  }

  bool get hasError => errorCode != null;
}
