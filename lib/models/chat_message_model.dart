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

  factory ChatMessageModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ChatMessageModel(
      id: json["id"]?.toString() ?? "",

      chatId:
      json["chat_id"]?.toString() ??
          json["conversation"]?.toString() ??
          json["conversation_id"]?.toString() ??
          "",

      senderId:
      json["sender_id"]?.toString() ??
          json["sender"]?.toString() ??
          "",

      receiverId:
      json["receiver_id"]?.toString() ?? "",

      message:
      json["message"]?.toString() ??
          json["text"]?.toString() ??
          "",

      createdAt:
      DateTime.tryParse(
        json["created_at"]?.toString() ??
            json["createdAt"]?.toString() ??
            "",
      ) ??
          DateTime.now(),

      isRead: json["is_read"] == true,
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


class ChatConversationModel {
  final String id;
  final String inquiryId;
  final String inquiryStatus;

  final String cropId;
  final String cropName;

  final String buyerId;
  final String buyerName;

  final String farmerId;
  final String farmerName;

  final String otherUserId;
  final String otherUserName;
  final String otherUserRole;

  final String lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final DateTime? createdAt;

  const ChatConversationModel({
    required this.id,
    required this.inquiryId,
    required this.inquiryStatus,
    required this.cropId,
    required this.cropName,
    required this.buyerId,
    required this.buyerName,
    required this.farmerId,
    required this.farmerName,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserRole,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
    required this.createdAt,
  });

  factory ChatConversationModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ChatConversationModel(
      id: json["id"]?.toString() ?? "",

      inquiryId:
      json["inquiry"]?.toString() ?? "",

      inquiryStatus:
      json["inquiry_status"]?.toString() ?? "",

      cropId:
      json["crop_id"]?.toString() ?? "",

      cropName:
      json["crop_name"]?.toString() ?? "",

      buyerId:
      json["buyer_id"]?.toString() ??
          json["buyer"]?.toString() ??
          "",

      buyerName:
      json["buyer_name"]?.toString() ?? "",

      farmerId:
      json["farmer_id"]?.toString() ??
          json["farmer"]?.toString() ??
          "",

      farmerName:
      json["farmer_name"]?.toString() ?? "",

      otherUserId:
      json["other_user_id"]?.toString() ?? "",

      otherUserName:
      json["other_user_name"]?.toString() ?? "",

      otherUserRole:
      json["other_user_role"]?.toString() ?? "",

      lastMessage:
      json["last_message"]?.toString() ?? "",

      lastMessageAt: DateTime.tryParse(
        json["last_message_at"]?.toString() ?? "",
      ),

      unreadCount: _parseInt(
        json["unread_count"],
      ),

      createdAt: DateTime.tryParse(
        json["created_at"]?.toString() ?? "",
      ),
    );
  }

  bool get hasUnreadMessages {
    return unreadCount > 0;
  }

  String get displayName {
    if (otherUserName.trim().isNotEmpty) {
      return otherUserName;
    }

    if (otherUserRole.trim().toLowerCase() == "buyer") {
      return buyerName;
    }

    return farmerName;
  }

  String get displayLastMessage {
    if (lastMessage.trim().isEmpty) {
      return "No messages yet";
    }

    return lastMessage;
  }

  DateTime? get displayTime {
    return lastMessageAt ?? createdAt;
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
      value?.toString() ?? "",
    ) ??
        0;
  }
}