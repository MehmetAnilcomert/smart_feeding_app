import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArgCubit extends Cubit<Map<String, dynamic>?> {
  ArgCubit(Map<String, dynamic>? initialState) : super(initialState) {
    if (initialState != null && initialState.containsKey('message')) {
      try {
        // Parse the message if it's a string
        if (initialState['message'] is String) {
          final decodedMessage = jsonDecode(initialState['message']);
          emit({'message': decodedMessage});
        }
      } catch (e) {
        throw Exception('Failed to parse message: $e');
      }
    }
  }

  void processNotificationData() {
    if (state != null && state!.containsKey('message')) {
      // Handle notification data

      // You can add your logic here to handle the notification data
      // For example, navigate to a specific screen based on the notification
    }
  }
}
