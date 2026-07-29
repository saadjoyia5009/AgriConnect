class ChatConversationModel {
  final String id;
  final String inquiryId;

  final String buyerId;
  final String buyerName;

  final String farmerId;
  final String farmerName;

  final String cropId;
  final String cropName;
  final String cropImage;

  final String otherUserId;
  final String otherUserName;
  final String otherUserRole;

  final String lastMessage;
  final DateTime? lastMessageTime;

  final int unreadCount;
  final bool canChat;
  final String inquiryStatus;

  const ChatConversationModel({
    required this.id,
    required this.inquiryId,
    required this.buyerId,
    required this.buyerName,
    required this.farmerId,
    required this.farmerName,
    required this.cropId,
    required this.cropName,
    required this.cropImage,
    this.otherUserId = "",
    this.otherUserName = "",
    this.otherUserRole = "",
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.canChat,
    required this.inquiryStatus,
  });

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) {
    final inquiryStatus = (
        json["inquiry_status"] ??
            json["status"] ??
            ""
    ).toString().trim().toLowerCase();

    final buyer = _toMap(json["buyer"]);
    final farmer = _toMap(json["farmer"]);
    final crop = _toMap(json["crop"]);

    final conversationId = _extractId(
      json["id"] ?? json["conversation_id"],
    );

    return ChatConversationModel(
      id: conversationId,
      inquiryId: _extractId(
        json["inquiry_id"] ?? json["inquiry"],
      ),
      buyerId: _extractId(
        json["buyer_id"] ?? json["buyer"],
      ),
      buyerName: (
          json["buyer_name"] ??
              buyer["full_name"] ??
              buyer["name"] ??
              buyer["username"] ??
              "Buyer"
      ).toString(),
      farmerId: _extractId(
        json["farmer_id"] ?? json["farmer"],
      ),
      farmerName: (
          json["farmer_name"] ??
              farmer["full_name"] ??
              farmer["name"] ??
              farmer["username"] ??
              "Farmer"
      ).toString(),
      cropId: _extractId(
        json["crop_id"] ?? json["crop"],
      ),
      cropName: (
          json["crop_name"] ??
              crop["name"] ??
              "Crop"
      ).toString(),
      cropImage: (
          json["crop_image"] ??
              json["image_url"] ??
              crop["image"] ??
              ""
      ).toString(),
      otherUserId: _extractId(json["other_user_id"]),
      otherUserName: (
          json["other_user_name"] ?? ""
      ).toString(),
      otherUserRole: (
          json["other_user_role"] ?? ""
      ).toString().trim().toLowerCase(),
      lastMessage: (
          json["last_message"] ?? ""
      ).toString(),
      lastMessageTime: _parseDate(
        json["last_message_at"] ??
            json["last_message_time"],
      ),
      unreadCount: _parseInt(json["unread_count"]),
      canChat:
      conversationId.isNotEmpty &&
          inquiryStatus == "accepted",
      inquiryStatus: inquiryStatus,
    );
  }

  bool get hasUnreadMessages => unreadCount > 0;

  String get displayLastMessage {
    return lastMessage.trim().isEmpty
        ? "Start conversation"
        : lastMessage;
  }

  DateTime? get displayTime => lastMessageTime;

  String get participantName {
    if (otherUserName.trim().isNotEmpty) {
      return otherUserName;
    }

    if (otherUserRole == "farmer") {
      return farmerName;
    }

    if (otherUserRole == "buyer") {
      return buyerName;
    }

    return "User";
  }

  static Map<String, dynamic> _toMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return <String, dynamic>{};
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value?.toString() ?? "") ?? 0;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(value.toString())?.toLocal();
  }

  static String _extractId(dynamic value) {
    if (value == null) return "";

    if (value is Map) {
      return value["id"]?.toString() ?? "";
    }

    return value.toString();
  }
}
