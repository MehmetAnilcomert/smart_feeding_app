# 🐾 Smart Feeding App - IoT Feeder Controller

A Flutter-based application for controlling IoT smart chicken feeders via WebSocket. Built with robust state management using the **Bloc pattern**, this app offers real-time monitoring, multi-language support, and theme customization.

![Flutter](https://img.shields.io/badge/Flutter-3.13-blue)
![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Web-lightgrey)
![License](https://img.shields.io/badge/License-MIT-green)

## 🌟 Features

### 🎛️ Feeding Control
- Adjust feeding schedules in real-time through WebSocket communication.
- Dynamically update feeding frequency without device reboot.

### 📜 Real-Time Logs
- Stream system logs and feeding events directly to the app.
- Filter logs by type (info, warning, error) for quick diagnostics.

### 🌡️ Temperature Monitoring
- Live ambient temperature display with color-coded thresholds:
  - **Safe Range**: 15°C - 25°C (59°F - 77°F)
  - **Critical**: Push notifications when exceeding limits
- Historical temperature graph (last 24 hours)

### 📦 Technologies Used

- **Flutter**  
- **WebSocket** for real-time communication  
- **intl** for localization  🌐
- **Bloc** for state management  
- **flutter_localizations** for multi-language support  
