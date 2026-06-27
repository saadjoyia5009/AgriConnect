class CropModel {
  final String id;

  final String farmerId;
  final String farmerName;

  final String name;
  final String imageUrl;
  final String quantity;
  final String price;
  final String unit;
  final String category;
  final String status;
  final bool isOrganic;
  final bool isReadyToShip;
  final String location;
  final String description;
  final String harvestDate;

  CropModel({
    required this.id,
    this.farmerId = '',
    this.farmerName = '',
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.price,
    required this.unit,
    required this.category,
    required this.status,
    required this.isOrganic,
    required this.isReadyToShip,
    required this.location,
    required this.description,
    required this.harvestDate,
  });

  factory CropModel.fromJson(Map<String, dynamic> json) {
    return CropModel(
      id: json["id"]?.toString() ?? "",
      farmerId: json["farmer_id"]?.toString() ?? json["farmerId"]?.toString() ?? "",
      farmerName: json["farmer_name"]?.toString() ?? json["farmerName"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      imageUrl: json["image_url"]?.toString() ?? json["imageUrl"]?.toString() ?? "",
      quantity: json["quantity"]?.toString() ?? "",
      price: json["price"]?.toString() ?? "",
      unit: json["unit"]?.toString() ?? "",
      category: json["category"]?.toString() ?? "",
      status: json["status"]?.toString() ?? "Active",
      isOrganic: json["is_organic"] ?? json["isOrganic"] ?? false,
      isReadyToShip: json["is_ready_to_ship"] ?? json["isReadyToShip"] ?? false,
      location: json["location"]?.toString() ?? "",
      description: json["description"]?.toString() ?? "",
      harvestDate: json["harvest_date"]?.toString() ?? json["harvestDate"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "farmer_id": farmerId,
      "farmer_name": farmerName,
      "name": name,
      "image_url": imageUrl,
      "quantity": quantity,
      "price": price,
      "unit": unit,
      "category": category,
      "status": status,
      "is_organic": isOrganic,
      "is_ready_to_ship": isReadyToShip,
      "location": location,
      "description": description,
      "harvest_date": harvestDate,
    };
  }

  CropModel copyWith({
    String? id,
    String? farmerId,
    String? farmerName,
    String? name,
    String? imageUrl,
    String? quantity,
    String? price,
    String? unit,
    String? category,
    String? status,
    bool? isOrganic,
    bool? isReadyToShip,
    String? location,
    String? description,
    String? harvestDate,
  }) {
    return CropModel(
      id: id ?? this.id,
      farmerId: farmerId ?? this.farmerId,
      farmerName: farmerName ?? this.farmerName,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      status: status ?? this.status,
      isOrganic: isOrganic ?? this.isOrganic,
      isReadyToShip: isReadyToShip ?? this.isReadyToShip,
      location: location ?? this.location,
      description: description ?? this.description,
      harvestDate: harvestDate ?? this.harvestDate,
    );
  }
}