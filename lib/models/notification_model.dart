class NotificationModel {
  final String id;
  final String title;
  final String message;

  // inquiry, chat, system
  final String type;

  final String time;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.time,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'].toString(),
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      type: json['notification_type']?.toString() ?? 'system',
      time: json['created_at']?.toString() ?? '',
      isRead: json['is_read'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'notification_type': type,
      'created_at': time,
      'is_read': isRead,
    };
  }
}