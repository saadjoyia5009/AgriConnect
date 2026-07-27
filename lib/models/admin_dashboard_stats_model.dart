class AdminDashboardStatsModel {
  final int totalFarmers;
  final int totalBuyers;
  final int totalCrops;
  final int totalInquiries;
  final int activeListings;
  final int pendingReports;

  const AdminDashboardStatsModel({
    required this.totalFarmers,
    required this.totalBuyers,
    required this.totalCrops,
    required this.totalInquiries,
    required this.activeListings,
    required this.pendingReports,
  });

  factory AdminDashboardStatsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final users = _toMap(json["users"]);
    final crops = _toMap(json["crops"]);
    final inquiries = _toMap(json["inquiries"]);

    return AdminDashboardStatsModel(
      totalFarmers: _toInt(users["farmers"]),
      totalBuyers: _toInt(users["buyers"]),
      totalCrops: _toInt(crops["total"]),
      totalInquiries: _toInt(inquiries["total"]),
      activeListings: _toInt(crops["active"]),

      // Backend mein abhi reports ka separate count nahi aa raha.
      pendingReports: _toInt(json["pending_reports"]),
    );
  }

  static Map<String, dynamic> _toMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return <String, dynamic>{};
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? "") ?? 0;
  }
}