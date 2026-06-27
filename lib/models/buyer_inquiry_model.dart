class BuyerInquiryModel {
  final String id;

  final String cropId;
  final String farmerId;
  final String buyerId;

  final String cropName;
  final String farmerName;
  final String imageUrl;

  final String quantity;
  final String offerPrice;

  final String deliveryDate;
  final String date;

  final String status;
  final String message;

  BuyerInquiryModel({
    required this.id,
    required this.cropId,
    required this.farmerId,
    required this.buyerId,
    required this.cropName,
    required this.farmerName,
    required this.imageUrl,
    required this.quantity,
    required this.offerPrice,
    required this.deliveryDate,
    required this.date,
    required this.status,
    required this.message,
  });

  factory BuyerInquiryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return BuyerInquiryModel(
      id: json["id"]?.toString() ?? "",

      cropId: json["crop_id"]?.toString() ?? "",
      farmerId: json["farmer_id"]?.toString() ?? "",
      buyerId: json["buyer_id"]?.toString() ?? "",

      cropName: json["crop_name"] ?? "",
      farmerName: json["farmer_name"] ?? "",
      imageUrl: json["image_url"] ?? "",

      quantity: json["quantity"] ?? "",
      offerPrice: json["offer_price"] ?? "",

      deliveryDate: json["delivery_date"] ?? "",
      date: json["date"] ?? "",

      status: json["status"] ?? "Pending",
      message: json["message"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,

      "crop_id": cropId,
      "farmer_id": farmerId,
      "buyer_id": buyerId,

      "crop_name": cropName,
      "farmer_name": farmerName,
      "image_url": imageUrl,

      "quantity": quantity,
      "offer_price": offerPrice,

      "delivery_date": deliveryDate,
      "date": date,

      "status": status,
      "message": message,
    };
  }
}