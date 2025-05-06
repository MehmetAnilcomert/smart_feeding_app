package com.example.smart_feeding_app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    // Android O ve üzeri için bildirim kanalı oluştur
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      val channel = NotificationChannel(
        "high_importance_channel",              // kanal id
        "Yüksek Önemli Kanal",                  // kullanıcıya görünen adı
        NotificationManager.IMPORTANCE_HIGH     // önem seviyesi
      )
      val manager = getSystemService(NotificationManager::class.java)
      manager.createNotificationChannel(channel)
    }
  }
}
