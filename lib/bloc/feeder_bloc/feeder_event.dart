import 'package:flutter/material.dart';

abstract class FeederEvent {}

class LoadSettingsEvent extends FeederEvent {}

class SaveSettingsEvent extends FeederEvent {}

class ManualFeedEvent extends FeederEvent {}

class FeederStatusFetchEvent extends FeederEvent {}

class FeedingFrequencyChangedEvent extends FeederEvent {
  final int frequency;
  FeedingFrequencyChangedEvent(this.frequency);
}

class FeedAmountChangedEvent extends FeederEvent {
  final double amount;
  FeedAmountChangedEvent(this.amount);
}

class FirstFeedTimeChangedEvent extends FeederEvent {
  final TimeOfDay time;
  FirstFeedTimeChangedEvent(this.time);
}

class LastFeedTimeChangedEvent extends FeederEvent {
  final TimeOfDay lastFeedTime;
  LastFeedTimeChangedEvent(this.lastFeedTime);
}

class FeedingFrequencyMinuteChangedEvent extends FeederEvent {
  final int minute;
  FeedingFrequencyMinuteChangedEvent(this.minute);
}

class FeedErrorEvent extends FeederEvent {
  final int messageCode;
  FeedErrorEvent(this.messageCode);
}

class ClearErrorEvent extends FeederEvent {}

// New event for command logs
class LoadCommandLogsEvent extends FeederEvent {}

class LoadSystemLogsEvent extends FeederEvent {}
