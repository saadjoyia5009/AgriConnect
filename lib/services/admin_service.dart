import '../models/admin_dashboard_stats_model.dart';
import 'api_service.dart';

class AdminService {
  static const String _adminEndpoint = "/admin/";

  static Future<AdminDashboardStatsModel> fetchDashboardStats() async {
    final response = await ApiService.get(
      "${_adminEndpoint}dashboard/",
      auth: true,
    );

    if (response is Map<String, dynamic>) {
      return AdminDashboardStatsModel.fromJson(response);
    }

    if (response is Map) {
      return AdminDashboardStatsModel.fromJson(
        Map<String, dynamic>.from(response),
      );
    }

    throw Exception("Invalid admin dashboard response.");
  }
}
