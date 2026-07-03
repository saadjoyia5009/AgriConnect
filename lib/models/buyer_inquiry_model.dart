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

      cropId: json["crop_id"]?.toString() ?? json["crop"]?.toString() ?? "",
      farmerId: json["farmer_id"]?.toString() ?? json["farmer"]?.toString() ?? "",
      buyerId: json["buyer_id"]?.toString() ?? json["buyer"]?.toString() ?? "",

      cropName: json["crop_name"]?.toString() ?? "",
      farmerName: json["farmer_name"]?.toString() ?? "",
      imageUrl: json["image_url"]?.toString() ?? "",

      quantity: json["quantity"]?.toString() ?? json["quantity_requested"]?.toString() ?? "",
      offerPrice: json["offer_price"]?.toString() ?? json["offered_price"]?.toString() ?? "",

      deliveryDate: json["delivery_date"]?.toString() ?? "",
      date: json["date"]?.toString() ?? json["created_at"]?.toString() ?? "",

      status: json["status"]?.toString() ?? "Pending",
      message: json["message"]?.toString() ?? "",
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