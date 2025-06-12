class SystemLog {
  final int id;
  final String type;
  final String message;
  final String createdAt;
  final int deviceId;

  SystemLog({
    required this.id,
    required this.type,
    required this.message,
    required this.createdAt,
    required this.deviceId,
  });

  factory SystemLog.fromJson(Map<String, dynamic> json) {
    return SystemLog(
      id: json['id'],
      type: json['type'],
      message: json['message'],
      createdAt: json['created_at'],
      deviceId: json['device_id'],
    );
  }

  // Helper method to get icon based on type
  String get logTypeIcon {
    switch (type) {
      case 'temperature':
        return '🌡️';
      case 'interval':
        return '⏱️';
      default:
        return 'ℹ️';
    }
  }
}
