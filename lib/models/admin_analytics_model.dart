class AdminAnalyticsModel {
  final int totalUsers;
  final int totalCrops;
  final int totalInquiries;
  final int completedDeals;

  final Map<String, double> userGrowth;
  final Map<String, double> cropCategories;
  final Map<String, double> inquiryStats;
  final Map<String, double> userRoles;
  final Map<String, double> cropStatuses;
  final Map<String, double> inquiryMonthlyTrend;
  final Map<String, double> topListedCrops;

  const AdminAnalyticsModel({
    required this.totalUsers,
    required this.totalCrops,
    required this.totalInquiries,
    required this.completedDeals,
    required this.userGrowth,
    required this.cropCategories,
    required this.inquiryStats,
    required this.userRoles,
    required this.cropStatuses,
    required this.inquiryMonthlyTrend,
    required this.topListedCrops,
  });

  factory AdminAnalyticsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final userRoles = _distributionToMap(
      json["user_role_distribution"],
    );

    final userGrowth = _monthlyTrendToMap(
      json["user_registration_monthly_trend"],
    );

    final cropStatuses = _distributionToMap(
      json["crop_status_distribution"],
    );

    final cropCategories = _distributionToMap(
      json["crop_category_distribution"],
    );

    final inquiryStats = _distributionToMap(
      json["inquiry_status_distribution"],
    );

    final inquiryMonthlyTrend = _monthlyTrendToMap(
      json["inquiry_monthly_trend"],
    );

    final topListedCrops = _topCropsToMap(
      json["top_listed_crop_names"],
    );

    return AdminAnalyticsModel(
      totalUsers: _sumValues(userRoles),
      totalCrops: _sumValues(cropStatuses),
      totalInquiries: _sumValues(inquiryStats),
      completedDeals: _findValue(
        inquiryStats,
        "completed",
      ),
      userGrowth: userGrowth,
      cropCategories: cropCategories,
      inquiryStats: inquiryStats,
      userRoles: userRoles,
      cropStatuses: cropStatuses,
      inquiryMonthlyTrend: inquiryMonthlyTrend,
      topListedCrops: topListedCrops,
    );
  }

  static Map<String, double> _distributionToMap(
      dynamic value,
      ) {
    final result = <String, double>{};

    if (value is! List) {
      return result;
    }

    for (final item in value) {
      final map = _toMap(item);

      final label = map["label"]?.toString().trim() ?? "";
      final amount = _toDouble(map["value"]);

      if (label.isNotEmpty) {
        result[label] = amount;
      }
    }

    return result;
  }

  static Map<String, double> _monthlyTrendToMap(
      dynamic value,
      ) {
    final result = <String, double>{};

    if (value is! List) {
      return result;
    }

    for (final item in value) {
      final map = _toMap(item);

      final rawMonth =
          map["month"]?.toString().trim() ?? "";

      if (rawMonth.isEmpty) continue;

      final label = _formatMonth(rawMonth);
      result[label] = _toDouble(map["value"]);
    }

    return result;
  }

  static Map<String, double> _topCropsToMap(
      dynamic value,
      ) {
    final result = <String, double>{};

    if (value is! List) {
      return result;
    }

    for (final item in value) {
      final map = _toMap(item);

      final name = map["name"]?.toString().trim() ?? "";
      final count = _toDouble(map["count"]);

      if (name.isNotEmpty) {
        result[name] = count;
      }
    }

    return result;
  }

  static int _sumValues(Map<String, double> values) {
    return values.values.fold<double>(
      0,
          (total, value) => total + value,
    ).round();
  }

  static int _findValue(
      Map<String, double> values,
      String expectedKey,
      ) {
    for (final entry in values.entries) {
      if (entry.key.trim().toLowerCase() ==
          expectedKey.trim().toLowerCase()) {
        return entry.value.round();
      }
    }

    return 0;
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

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString() ?? "",
    ) ??
        0;
  }

  static String _formatMonth(String value) {
    final parts = value.split("-");

    if (parts.length != 2) {
      return value;
    }

    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);

    if (year == null ||
        month == null ||
        month < 1 ||
        month > 12) {
      return value;
    }

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

    return "${months[month - 1]} ${year.toString().substring(2)}";
  }
}