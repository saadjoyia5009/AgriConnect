class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type; // inquiry, chat, system
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
}