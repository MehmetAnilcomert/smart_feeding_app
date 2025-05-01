import 'package:flutter/material.dart';

abstract class FeederState {
  const FeederState();
}

class FeederDataState extends FeederState {
  final List<String> logs;
  final double temperature;
  final int feedingFrequency;
  final double feedAmount;
  final TimeOfDay firstFeedTime;
  final bool isSaving;

  const FeederDataState({
    required this.logs,
    required this.temperature,
    required this.feedingFrequency,
    required this.feedAmount,
    required this.firstFeedTime,
    this.isSaving = false,
  });

  /// Uygulama ilk açılışındaki default değerler
  factory FeederDataState.initial() => FeederDataState(
        logs: [],
        temperature: 0.0,
        feedingFrequency: 3,
        feedAmount: 100.0,
        firstFeedTime: TimeOfDay(hour: 7, minute: 0),
        isSaving: false,
      );

  FeederDataState copyWith({
    List<String>? logs,
    double? temperature,
    int? feedingFrequency,
    double? feedAmount,
    TimeOfDay? firstFeedTime,
    bool? isSaving,
  }) {
    return FeederDataState(
      logs: logs ?? this.logs,
      temperature: temperature ?? this.temperature,
      feedingFrequency: feedingFrequency ?? this.feedingFrequency,
      feedAmount: feedAmount ?? this.feedAmount,
      firstFeedTime: firstFeedTime ?? this.firstFeedTime,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
