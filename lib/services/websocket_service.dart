import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String url;
  late WebSocketChannel _channel;

  WebSocketService({required this.url});

  void connect(void Function(Map<String, dynamic>) onData) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel.stream.listen((message) {
      final data = jsonDecode(message);
      onData(data);
    }, onError: (error) {
      print('WebSocket error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });
  }

  void disconnect() {
    _channel.sink.close();
  }

  void send(Map<String, dynamic> data) {
    _channel.sink.add(jsonEncode(data));
  }
}
