class AdminDashboardStatsModel {
  final int totalFarmers;
  final int totalBuyers;
  final int totalCrops;
  final int totalInquiries;
  final int activeListings;
  final int pendingReports;

  AdminDashboardStatsModel({
    required this.totalFarmers,
    required this.totalBuyers,
    required this.totalCrops,
    required this.totalInquiries,
    required this.activeListings,
    required this.pendingReports,
  });

  factory AdminDashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminDashboardStatsModel(
      totalFarmers: json['total_farmers'] ?? 0,
      totalBuyers: json['total_buyers'] ?? 0,
      totalCrops: json['total_crops'] ?? 0,
      totalInquiries: json['total_inquiries'] ?? 0,
      activeListings: json['active_listings'] ?? 0,
      pendingReports: json['pending_reports'] ?? 0,
    );
  }
}
