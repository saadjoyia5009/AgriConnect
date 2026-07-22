class NotificationModel {
  final String id;

  final String title;
  final String message;

  // inquiry, chat, system
  final String type;

  // farmer, buyer
  final String role;

  // inquiryId, chatId etc
  final String? referenceId;

  // screen navigation
  final String? navigationType;

  final String time;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.role,
    this.referenceId,
    this.navigationType,
    required this.time,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      role: json['role'] ?? '',
      referenceId: json['reference_id'],
      navigationType: json['navigation_type'],
      time: json['time'] ?? '',
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'role': role,
      'reference_id': referenceId,
      'navigation_type': navigationType,
      'time': time,
      'is_read': isRead,
    };
  }
}
