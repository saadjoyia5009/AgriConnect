class BuyerInquiryModel {
  final String id;

  final String cropId;
  final String farmerId;
  final String buyerId;

  final String cropName;
  final String farmerName;
  final String imageUrl;
  final String cropUnit;

  final String quantity;
  final String offerPrice;
  final String deliveryDate;
  final String date;

  final String status;
  final String message;

  final String? conversationId;
  final bool canChat;

  const BuyerInquiryModel({
    required this.id,
    required this.cropId,
    required this.farmerId,
    required this.buyerId,
    required this.cropName,
    required this.farmerName,
    required this.imageUrl,
    required this.cropUnit,
    required this.quantity,
    required this.offerPrice,
    required this.deliveryDate,
    required this.date,
    required this.status,
    required this.message,
    required this.conversationId,
    required this.canChat,
  });

  factory BuyerInquiryModel.fromJson(Map<String, dynamic> json) {
    final rawConversationId = json["conversation_id"];

    return BuyerInquiryModel(
      id: json["id"]?.toString() ?? "",

      cropId:
      json["crop_id"]?.toString() ??
          json["crop"]?.toString() ??
          "",

      farmerId:
      json["farmer_id"]?.toString() ??
          json["farmer"]?.toString() ??
          "",

      buyerId:
      json["buyer_id"]?.toString() ??
          json["buyer"]?.toString() ??
          "",

      cropName: json["crop_name"]?.toString() ?? "",
      farmerName: json["farmer_name"]?.toString() ?? "",

      imageUrl:
      json["image_url"]?.toString() ??
          json["crop_image"]?.toString() ??
          "",

      cropUnit: json["crop_unit"]?.toString() ?? "",

      quantity:
      json["quantity_requested"]?.toString() ??
          json["quantity"]?.toString() ??
          "",

      offerPrice:
      json["offered_price"]?.toString() ??
          json["offer_price"]?.toString() ??
          "",

      deliveryDate: json["delivery_date"]?.toString() ?? "",

      date:
      json["created_at"]?.toString() ??
          json["date"]?.toString() ??
          "",

      status: json["status"]?.toString() ?? "pending",
      message: json["message"]?.toString() ?? "",

      conversationId: rawConversationId?.toString(),

      canChat: json["can_chat"] == true,
    );
  }

  String get normalizedStatus {
    return status.trim().toLowerCase();
  }

  bool get isPending {
    return normalizedStatus == "pending";
  }

  bool get isAccepted {
    return normalizedStatus == "accepted";
  }

  bool get isRejected {
    return normalizedStatus == "rejected";
  }

  bool get isCompleted {
    return normalizedStatus == "completed";
  }

  bool get hasConversation {
    return conversationId?.trim().isNotEmpty ?? false;
  }

  bool get chatAvailable {
    return isAccepted && canChat && hasConversation;
  }

  String get displayQuantity {
    if (cropUnit.trim().isEmpty) {
      return quantity;
    }

    return "$quantity $cropUnit";
  }

  BuyerInquiryModel copyWith({
    String? id,
    String? cropId,
    String? farmerId,
    String? buyerId,
    String? cropName,
    String? farmerName,
    String? imageUrl,
    String? cropUnit,
    String? quantity,
    String? offerPrice,
    String? deliveryDate,
    String? date,
    String? status,
    String? message,
    String? conversationId,
    bool? canChat,
  }) {
    return BuyerInquiryModel(
      id: id ?? this.id,
      cropId: cropId ?? this.cropId,
      farmerId: farmerId ?? this.farmerId,
      buyerId: buyerId ?? this.buyerId,
      cropName: cropName ?? this.cropName,
      farmerName: farmerName ?? this.farmerName,
      imageUrl: imageUrl ?? this.imageUrl,
      cropUnit: cropUnit ?? this.cropUnit,
      quantity: quantity ?? this.quantity,
      offerPrice: offerPrice ?? this.offerPrice,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      date: date ?? this.date,
      status: status ?? this.status,
      message: message ?? this.message,
      conversationId: conversationId ?? this.conversationId,
      canChat: canChat ?? this.canChat,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "crop": cropId,
      "farmer": farmerId,
      "buyer": buyerId,
      "crop_name": cropName,
      "farmer_name": farmerName,
      "image_url": imageUrl,
      "crop_unit": cropUnit,
      "quantity_requested": quantity,
      "offered_price": offerPrice,
      "delivery_date": deliveryDate,
      "created_at": date,
      "status": status,
      "message": message,
      "conversation_id": conversationId,
      "can_chat": canChat,
    };
  }
}