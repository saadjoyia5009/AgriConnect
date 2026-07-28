class AdminCropModel {
  final String id;
  final String farmerId;
  final String cropName;
  final String farmerName;
  final String category;
  final String description;
  final String location;
  final String price;
  final String quantity;
  final String unit;
  final String status;
  final String listedDate;
  final String imageUrl;

  final int inquiryCount;
  final int pendingInquiryCount;
  final int acceptedInquiryCount;

  const AdminCropModel({
    required this.id,
    required this.farmerId,
    required this.cropName,
    required this.farmerName,
    required this.category,
    required this.description,
    required this.location,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.status,
    required this.listedDate,
    required this.imageUrl,
    required this.inquiryCount,
    required this.pendingInquiryCount,
    required this.acceptedInquiryCount,
  });

  factory AdminCropModel.fromJson(Map<String, dynamic> json) {
    final farmer = _toMap(json["farmer"]);

    final firstName =
        farmer["first_name"]?.toString().trim() ?? "";
    final lastName =
        farmer["last_name"]?.toString().trim() ?? "";
    final username =
        farmer["username"]?.toString().trim() ?? "";

    final fullName = [
      firstName,
      lastName,
    ].where((value) => value.isNotEmpty).join(" ").trim();

    final unit = json["unit"]?.toString() ?? "";
    final rawPrice = json["price_per_unit"]?.toString() ?? "0";
    final rawQuantity = json["quantity"]?.toString() ?? "0";

    return AdminCropModel(
      id: json["id"]?.toString() ?? "",
      farmerId: farmer["id"]?.toString() ?? "",
      cropName: json["name"]?.toString() ?? "",
      farmerName: fullName.isNotEmpty ? fullName : username,
      category: _formatText(json["category"]?.toString()),
      description: json["description"]?.toString() ?? "",
      location: json["farm_location"]?.toString() ?? "",
      price: "Rs. ${_cleanNumber(rawPrice)} / ${_formatUnit(unit)}",
      quantity: "${_cleanNumber(rawQuantity)} ${_formatUnit(unit)}",
      unit: unit,
      status: _formatStatus(json["status"]?.toString()),
      listedDate: _formatDate(json["created_at"]?.toString()),
      imageUrl: json["image"]?.toString() ?? "",
      inquiryCount: _toInt(json["inquiry_count"]),
      pendingInquiryCount: _toInt(
        json["pending_inquiry_count"],
      ),
      acceptedInquiryCount: _toInt(
        json["accepted_inquiry_count"],
      ),
    );
  }

  String get backendStatus {
    switch (status.toLowerCase()) {
      case "active":
        return "active";
      case "sold out":
        return "sold_out";
      case "draft":
        return "draft";
      default:
        return status.toLowerCase();
    }
  }

  AdminCropModel copyWith({
    String? id,
    String? farmerId,
    String? cropName,
    String? farmerName,
    String? category,
    String? description,
    String? location,
    String? price,
    String? quantity,
    String? unit,
    String? status,
    String? listedDate,
    String? imageUrl,
    int? inquiryCount,
    int? pendingInquiryCount,
    int? acceptedInquiryCount,
  }) {
    return AdminCropModel(
      id: id ?? this.id,
      farmerId: farmerId ?? this.farmerId,
      cropName: cropName ?? this.cropName,
      farmerName: farmerName ?? this.farmerName,
      category: category ?? this.category,
      description: description ?? this.description,
      location: location ?? this.location,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      listedDate: listedDate ?? this.listedDate,
      imageUrl: imageUrl ?? this.imageUrl,
      inquiryCount: inquiryCount ?? this.inquiryCount,
      pendingInquiryCount:
      pendingInquiryCount ?? this.pendingInquiryCount,
      acceptedInquiryCount:
      acceptedInquiryCount ?? this.acceptedInquiryCount,
    );
  }

  static Map<String, dynamic> _toMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return {};
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value?.toString() ?? "") ?? 0;
  }

  static String _formatStatus(String? value) {
    switch (value?.trim().toLowerCase()) {
      case "active":
        return "Active";
      case "sold_out":
        return "Sold Out";
      case "draft":
        return "Draft";
      default:
        return "Unknown";
    }
  }

  static String _formatText(String? value) {
    final text = value?.trim().replaceAll("_", " ") ?? "";

    if (text.isEmpty) return "";

    return text
        .split(" ")
        .where((word) => word.isNotEmpty)
        .map(
          (word) =>
      "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}",
    )
        .join(" ");
  }

  static String _formatUnit(String value) {
    switch (value.toLowerCase()) {
      case "kg":
        return "Kg";
      case "ton":
        return "Ton";
      case "box":
        return "Box";
      case "bundle":
        return "Bundle";
      case "bag":
        return "Bag";
      default:
        return value;
    }
  }

  static String _cleanNumber(String value) {
    final number = double.tryParse(value);

    if (number == null) return value;

    if (number == number.roundToDouble()) {
      return number.toInt().toString();
    }

    return number
        .toStringAsFixed(2)
        .replaceFirst(RegExp(r"0+$"), "")
        .replaceFirst(RegExp(r"\.$"), "");
  }

  static String _formatDate(String? value) {
    final date = DateTime.tryParse(value ?? "")?.toLocal();

    if (date == null) return "";

    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    final day = date.day.toString().padLeft(2, "0");

    return "$day ${months[date.month - 1]} ${date.year}";
  }
}