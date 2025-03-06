import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_event.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_state.dart';
import 'package:smart_feeding_app/services/websocket_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FeederBloc extends Bloc<FeederEvent, FeederState> {
  late WebSocketService _webSocketService;
  List<String> logs = [];
  double currentTemperature = 0.0;
  int feedingFrequency = 0;
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FeederBloc() : super(FeederInitial()) {
    _initializeNotifications();

    on<FeederConnectEvent>((event, emit) async {
      _webSocketService = WebSocketService(
        onData: (data) => add(FeederDataReceivedEvent(data)),
        onError: () => add(FeederDisconnectEvent()),
      );
      await _webSocketService.connect();
      emit(FeederConnected());
    });

    on<FeederDisconnectEvent>((event, emit) {
      emit(FeederDisconnected());
    });

    on<FeederDataReceivedEvent>((event, emit) {
      try {
        // Example JSON: { "log": "message", "temperature": 25.0, "feedingFrequency": 3 }
        final decoded = json.decode(event.data);
        if (decoded['log'] != null) logs.add(decoded['log']);
        if (decoded['temperature'] != null) {
          currentTemperature = decoded['temperature'];
          if (currentTemperature > 30.0 || currentTemperature < 5.0) {
            _showNotification(
                "Temperature Alert", "Temp is $currentTemperature°C");
          }
        }
        if (decoded['feedingFrequency'] != null) {
          feedingFrequency = decoded['feedingFrequency'];
        }
      } catch (e) {
        print("Data parse error: $e");
      }
      emit(FeederDataState(
        logs: List.from(logs),
        temperature: currentTemperature,
        feedingFrequency: feedingFrequency,
      ));
    });

    on<FeedingFrequencyChangedEvent>((event, emit) {
      feedingFrequency = event.frequency;
      _webSocketService
          .send(json.encode({"feedingFrequency": feedingFrequency}));
      emit(FeederDataState(
        logs: List.from(logs),
        temperature: currentTemperature,
        feedingFrequency: feedingFrequency,
      ));
    });
  }

  Future _initializeNotifications() async {
    final settingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final settings = InitializationSettings(android: settingsAndroid);
    await notificationsPlugin.initialize(settings);
  }

  Future _showNotification(String title, String body) async {
    final details = AndroidNotificationDetails('channelId', 'channelName',
        importance: Importance.max);
    await notificationsPlugin.show(
        0, title, body, NotificationDetails(android: details));
  }
}
