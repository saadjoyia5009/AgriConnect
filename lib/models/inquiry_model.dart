class InquiryModel {
  final String id;
  final String cropName;
  final String cropGrade;
  final String cropImage;
  final String buyerName;
  final String buyerInitials;
  final String buyerLocation;
  final String buyerImage;
  final String requestedQuantity;
  final String proposedPrice;
  final String message;
  final String timeAgo;
  final String status;

  InquiryModel({
    this.id = '',
    this.cropName = '',
    this.cropGrade = '',
    this.cropImage = '',
    this.buyerName = '',
    this.buyerInitials = '',
    this.buyerLocation = '',
    this.buyerImage = '',
    this.requestedQuantity = '',
    this.proposedPrice = '',
    this.message = '',
    this.timeAgo = '',
    this.status = 'Pending',
  });

  factory InquiryModel.fromJson(Map<String, dynamic> json) {
    final buyerName =
    (json['buyer_name'] ?? json['buyerName'] ?? '').toString();

    return InquiryModel(
      id: (json['id'] ?? '').toString(),
      cropName: (json['crop_name'] ?? json['cropName'] ?? '').toString(),
      cropGrade: (json['crop_grade'] ?? json['cropGrade'] ?? '').toString(),
      cropImage: (json['crop_image'] ?? json['cropImage'] ?? '').toString(),
      buyerName: buyerName,
      buyerInitials: (json['buyer_initials'] ??
          json['buyerInitials'] ??
          _getInitials(buyerName))
          .toString(),
      buyerLocation:
      (json['buyer_location'] ?? json['buyerLocation'] ?? '').toString(),
      buyerImage: (json['buyer_image'] ?? json['buyerImage'] ?? '').toString(),
      requestedQuantity:
      (json['requested_quantity'] ?? json['requestedQuantity'] ?? '')
          .toString(),
      proposedPrice:
      (json['proposed_price'] ?? json['proposedPrice'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      timeAgo: (json['time_ago'] ?? json['timeAgo'] ?? '').toString(),
      status: (json['status'] ?? 'Pending').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'crop_name': cropName,
      'crop_grade': cropGrade,
      'crop_image': cropImage,
      'buyer_name': buyerName,
      'buyer_initials': buyerInitials,
      'buyer_location': buyerLocation,
      'buyer_image': buyerImage,
      'requested_quantity': requestedQuantity,
      'proposed_price': proposedPrice,
      'message': message,
      'time_ago': timeAgo,
      'status': status,
    };
  }

  InquiryModel copyWith({
    String? id,
    String? cropName,
    String? cropGrade,
    String? cropImage,
    String? buyerName,
    String? buyerInitials,
    String? buyerLocation,
    String? buyerImage,
    String? requestedQuantity,
    String? proposedPrice,
    String? message,
    String? timeAgo,
    String? status,
  }) {
    return InquiryModel(
      id: id ?? this.id,
      cropName: cropName ?? this.cropName,
      cropGrade: cropGrade ?? this.cropGrade,
      cropImage: cropImage ?? this.cropImage,
      buyerName: buyerName ?? this.buyerName,
      buyerInitials: buyerInitials ?? this.buyerInitials,
      buyerLocation: buyerLocation ?? this.buyerLocation,
      buyerImage: buyerImage ?? this.buyerImage,
      requestedQuantity: requestedQuantity ?? this.requestedQuantity,
      proposedPrice: proposedPrice ?? this.proposedPrice,
      message: message ?? this.message,
      timeAgo: timeAgo ?? this.timeAgo,
      status: status ?? this.status,
    );
  }

  static String _getInitials(String name) {
    if (name.trim().isEmpty) return "B";

    final parts = name.trim().split(" ");

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return "${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}"
        .toUpperCase();
  }
}