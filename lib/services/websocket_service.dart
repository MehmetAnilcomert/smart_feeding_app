import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String webSocketUrl;
  late WebSocketChannel _channel;

  WebSocketService({required this.webSocketUrl});

  void connect(void Function(Map<String, dynamic>) onData) {
    _channel = WebSocketChannel.connect(Uri.parse(webSocketUrl));

    _channel.stream.listen((message) {
      print('Gelen WebSocket mesajı: $message');
      try {
        final data = jsonDecode(message);
        if (data is Map<String, dynamic>) {
          onData(data);
        }
      } catch (e) {
        print('Invalid Json message catched: $message');
      }
    }, onError: (error) {
      print('WebSocket hatası: $error');
    }, onDone: () {
      print('WebSocket bağlantısı kapandı');
    });
  }

  void disconnect() {
    _channel.sink.close();
  }

  void send(Map<String, dynamic> data) {
    _channel.sink.add(jsonEncode(data));
  }
}
