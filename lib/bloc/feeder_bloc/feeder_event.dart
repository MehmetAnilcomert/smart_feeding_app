import 'package:flutter/material.dart';

abstract class FeederEvent {}

class FeederConnectEvent extends FeederEvent {}

class LoadSettingsEvent extends FeederEvent {}

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

class SaveSettingsEvent extends FeederEvent {}

class ManualFeedEvent extends FeederEvent {}

class FeederDataReceivedEvent extends FeederEvent {
  final String data;
  FeederDataReceivedEvent(this.data);
}

class FeederDisconnectEvent extends FeederEvent {}

class FeederStatusFetchEvent extends FeederEvent {}
