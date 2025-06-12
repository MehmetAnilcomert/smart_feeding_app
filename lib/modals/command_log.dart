class CommandLog {
  final int id;
  final String message;
  final String createdAt;
  final int deviceId;

  CommandLog({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.deviceId,
  });

  factory CommandLog.fromJson(Map<String, dynamic> json) {
    return CommandLog(
      id: json['id'],
      message: json['message'],
      createdAt: json['created_at'],
      deviceId: json['device_id'],
    );
  }
}
