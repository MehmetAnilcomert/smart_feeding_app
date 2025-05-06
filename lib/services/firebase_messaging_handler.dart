import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_feeding_app/firebase_options.dart';

// This file handles the top-level Firebase background message handler
// which needs to be defined at the top level

// Top-level function for handling Firebase background messages
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized even in the background
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");
  print("Message data: ${message.data}");
}
