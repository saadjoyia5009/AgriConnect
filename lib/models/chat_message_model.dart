class ChatMessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  ChatMessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json["id"]?.toString() ?? "",
      chatId: json["chat_id"]?.toString() ?? "",
      senderId: json["sender_id"]?.toString() ?? "",
      receiverId: json["receiver_id"]?.toString() ?? "",
      message: json["message"]?.toString() ?? "",
      createdAt: DateTime.parse(
        json["created_at"] ?? DateTime.now().toIso8601String(),
      ),
      isRead: json["is_read"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "chat_id": chatId,
      "sender_id": senderId,
      "receiver_id": receiverId,
      "message": message,
      "created_at": createdAt.toIso8601String(),
      "is_read": isRead,
    };
  }
}