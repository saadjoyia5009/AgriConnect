class AdminCropModel {
  final String id;
  final String cropName;
  final String farmerName;
  final String category;
  final String location;
  final String price;
  final String quantity;
  final String status;
  final String listedDate;

  AdminCropModel({
    required this.id,
    required this.cropName,
    required this.farmerName,
    required this.category,
    required this.location,
    required this.price,
    required this.quantity,
    required this.status,
    required this.listedDate,
  });

  factory AdminCropModel.fromJson(Map<String, dynamic> json) {
    return AdminCropModel(
      id: json['id'].toString(),
      cropName: json['crop_name'] ?? '',
      farmerName: json['farmer_name'] ?? '',
      category: json['category'] ?? '',
      location: json['location'] ?? '',
      price: json['price'] ?? '',
      quantity: json['quantity'] ?? '',
      status: json['status'] ?? 'Active',
      listedDate: json['listed_date'] ?? '',
    );
  }
}