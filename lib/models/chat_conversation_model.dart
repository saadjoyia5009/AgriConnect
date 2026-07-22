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
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.canChat,
    required this.inquiryStatus,
  });

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) {
    return ChatConversationModel(
      id: json["id"]?.toString() ?? json["conversation_id"]?.toString() ?? "",

      inquiryId: json["inquiry_id"]?.toString() ?? _extractId(json["inquiry"]),

      buyerId:
          json["buyer_id"]?.toString() ??
          json["buyer"]?["id"]?.toString() ??
          "",

      buyerName:
          json["buyer_name"]?.toString() ??
          json["buyer"]?["full_name"]?.toString() ??
          "Buyer",

      farmerId:
          json["farmer_id"]?.toString() ??
          json["farmer"]?["id"]?.toString() ??
          "",

      farmerName:
          json["farmer_name"]?.toString() ??
          json["farmer"]?["full_name"]?.toString() ??
          "Farmer",

      cropId:
          json["crop_id"]?.toString() ?? json["crop"]?["id"]?.toString() ?? "",

      cropName:
          json["crop_name"]?.toString() ??
          json["crop"]?["name"]?.toString() ??
          "Crop",

      cropImage:
          json["crop_image"]?.toString() ??
          json["crop"]?["image"]?.toString() ??
          "",

      lastMessage: json["last_message"]?.toString() ?? "",

      lastMessageTime: json["last_message_time"] != null
          ? DateTime.tryParse(json["last_message_time"].toString())
          : null,

      unreadCount: _parseInt(json["unread_count"]),

      canChat:
          json["can_chat"] == true ||
          json["inquiry_status"]?.toString().toLowerCase() == "accepted" ||
          json["inquiry_status"]?.toString().toLowerCase() == "active",
      inquiryStatus:
          json["inquiry_status"]?.toString() ??
          json["status"]?.toString() ??
          "",
    );
  }

  bool get hasUnreadMessages => unreadCount > 0;
  String get displayLastMessage =>
      lastMessage.trim().isEmpty ? "Start conversation" : lastMessage;
  DateTime? get displayTime => lastMessageTime;

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? "") ?? 0;
  }

  static String _extractId(dynamic value) {
    if (value is Map) return value["id"]?.toString() ?? "";
    return value?.toString() ?? "";
  }
}
