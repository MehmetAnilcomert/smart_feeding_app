// lib/bloc/feeder_bloc/feeder_event.dart
import 'package:flutter/material.dart';

abstract class FeederEvent {}

class FeederConnectEvent extends FeederEvent {}

class LoadSettingsEvent extends FeederEvent {}

class FeedingFrequencyChangedEvent extends FeederEvent {
  final int frequency;
  FeedingFrequencyChangedEvent(this.frequency);
}

class FeedingFrequencyMinuteChangedEvent extends FeederEvent {
  final int minute;
  FeedingFrequencyMinuteChangedEvent(this.minute);
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

class SaveSettingsEvent extends FeederEvent {}

class ManualFeedEvent extends FeederEvent {}

class FeederDataReceivedEvent extends FeederEvent {
  final String data;
  FeederDataReceivedEvent(this.data);
}

class FeederDisconnectEvent extends FeederEvent {}

class FeederStatusFetchEvent extends FeederEvent {}

class FeedErrorEvent extends FeederEvent {
  final int messageCode;
  FeedErrorEvent(this.messageCode);
}

class ClearErrorEvent extends FeederEvent {}
