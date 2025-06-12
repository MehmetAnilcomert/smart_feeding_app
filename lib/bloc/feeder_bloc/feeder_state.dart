// lib/bloc/feeder_bloc/feeder_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:smart_feeding_app/modals/command_log.dart';
import 'package:smart_feeding_app/modals/system_log.dart';

abstract class FeederState extends Equatable {
  const FeederState();
}

class FeederDataState extends FeederState {
  final List<String> logs;
  final List<SystemLog> systemLogs;
  final List<CommandLog> commandLogs;
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
  final int? errorCode;
  final bool isLoadingSystemLogs;
  final bool isLoadingCommandLogs;

  const FeederDataState({
    required this.logs,
    this.systemLogs = const [],
    this.commandLogs = const [],
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
    this.isLoadingSystemLogs = false,
    this.isLoadingCommandLogs = false,
  });

  factory FeederDataState.initial() => FeederDataState(
        logs: [],
        systemLogs: [],
        commandLogs: [],
        temperature: 0.0,
        feedingFrequencyHour: 0,
        feedingFrequencyMinute: 0,
        feedAmount: 10.0,
        firstFeedHour: TimeOfDay(hour: 7, minute: 0),
        lastFeedHour: TimeOfDay(hour: 19, minute: 0),
        isSaving: false,
        humidity: 0.0,
        esp32Connected: false,
        serverTime: null,
        errorCode: null,
        isLoadingSystemLogs: false,
        isLoadingCommandLogs: false,
      );

  FeederDataState copyWith({
    List<String>? logs,
    List<SystemLog>? systemLogs,
    List<CommandLog>? commandLogs,
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
    bool? isLoadingSystemLogs,
    bool? isLoadingCommandLogs,
    bool clearError = false,
  }) {
    return FeederDataState(
      logs: logs ?? this.logs,
      systemLogs: systemLogs ?? this.systemLogs,
      commandLogs: commandLogs ?? this.commandLogs,
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
      isLoadingSystemLogs: isLoadingSystemLogs ?? this.isLoadingSystemLogs,
      isLoadingCommandLogs: isLoadingCommandLogs ?? this.isLoadingCommandLogs,
    );
  }

  bool get hasError => errorCode != null;

  @override
  List<Object?> get props => [
        logs,
        systemLogs,
        commandLogs,
        temperature,
        feedingFrequencyHour,
        feedingFrequencyMinute,
        feedAmount,
        firstFeedHour,
        lastFeedHour,
        isSaving,
        humidity,
        esp32Connected,
        serverTime,
        errorCode,
        isLoadingSystemLogs,
        isLoadingCommandLogs,
      ];
}
