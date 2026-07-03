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

      // Backend may send conversation / conversation_id / chat_id
      chatId: json["chat_id"]?.toString() ??
          json["conversation"]?.toString() ??
          json["conversation_id"]?.toString() ??
          "",

      // Backend may send sender / sender_id
      senderId: json["sender_id"]?.toString() ??
          json["sender"]?.toString() ??
          "",

      // Your current backend message serializer may not send receiver
      receiverId: json["receiver_id"]?.toString() ?? "",

      // Backend sends text, old mock used message
      message: json["message"]?.toString() ??
          json["text"]?.toString() ??
          "",

      createdAt: DateTime.tryParse(
        json["created_at"]?.toString() ??
            json["createdAt"]?.toString() ??
            "",
      ) ??
          DateTime.now(),

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
      "text": message,
      "created_at": createdAt.toIso8601String(),
      "is_read": isRead,
    };
  }
}