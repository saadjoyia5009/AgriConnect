class CropModel {
  final String id;
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
}