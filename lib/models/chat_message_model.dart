class ChatMessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  const ChatMessageModel({
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

      // Backend:
      // conversation
      // conversation_id
      // chat_id
      chatId:
          json["chat_id"]?.toString() ??
          json["conversation_id"]?.toString() ??
          _extractId(json["conversation"]),

      // Backend:
      // sender_id: 4
      // sender: 4
      // sender: {"id": 4, "full_name": "..."}
      senderId: json["sender_id"]?.toString() ?? _extractId(json["sender"]),

      // Backend receiver optional ho sakta hai
      receiverId:
          json["receiver_id"]?.toString() ?? _extractId(json["receiver"]),

      // Django backend generally "text" send karega
      message: json["text"]?.toString() ?? json["message"]?.toString() ?? "",

      createdAt:
          DateTime.tryParse(
            json["created_at"]?.toString() ??
                json["createdAt"]?.toString() ??
                "",
          ) ??
          DateTime.now(),

      isRead: _parseBool(json["is_read"] ?? json["isRead"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "conversation_id": chatId,
      "sender_id": senderId,
      "receiver_id": receiverId,
      "text": message,
      "created_at": createdAt.toIso8601String(),
      "is_read": isRead,
    };
  }

  static String _extractId(dynamic value) {
    if (value == null) return "";

    if (value is Map) {
      return value["id"]?.toString() ?? "";
    }

    return value.toString();
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is int) {
      return value == 1;
    }

    final stringValue = value?.toString().toLowerCase();

    return stringValue == "true" || stringValue == "1";
  }

  ChatMessageModel copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? receiverId,
    String? message,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
