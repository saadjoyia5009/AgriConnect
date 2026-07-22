class BuyerProfileModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final String imageUrl;

  final int totalInquiries;
  final int acceptedDeals;
  final int favoriteCrops;

  BuyerProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.imageUrl,
    required this.totalInquiries,
    required this.acceptedDeals,
    required this.favoriteCrops,
  });
}
