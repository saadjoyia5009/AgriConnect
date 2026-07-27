import '../models/admin_crop_model.dart';
import '../models/admin_dashboard_stats_model.dart';
import '../models/admin_user_model.dart';
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

  static Future<List<AdminUserModel>> fetchUsers({
    String search = "",
    String role = "",
  }) async {
    final parameters = <String, String>{
      "ordering": "-date_joined",
      "page_size": "100",
    };

    if (search.trim().isNotEmpty) {
      parameters["search"] = search.trim();
    }

    final cleanedRole = role.trim().toLowerCase();

    if (cleanedRole.isNotEmpty && cleanedRole != "all") {
      parameters["role"] = cleanedRole;
    }

    final query = Uri(queryParameters: parameters).query;

    final response = await ApiService.get(
      "${_adminEndpoint}users/?$query",
      auth: true,
    );

    final rawUsers = _extractResults(response);

    return rawUsers
        .whereType<Map>()
        .map(
          (item) => AdminUserModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  static Future<AdminUserModel> updateUserStatus({
    required String userId,
    required bool isActive,
  }) async {
    final response = await ApiService.patch(
      "${_adminEndpoint}users/$userId/status/",
      {"is_active": isActive},
      auth: true,
    );

    return AdminUserModel.fromJson(
      _toMap(response),
    );
  }

  static Future<List<AdminCropModel>> fetchCrops({
    String search = "",
    String status = "",
  }) async {
    final parameters = <String, String>{
      "ordering": "-created_at",
      "page_size": "100",
    };

    if (search.trim().isNotEmpty) {
      parameters["search"] = search.trim();
    }

    final backendStatus = _cropBackendStatus(status);

    if (backendStatus.isNotEmpty) {
      parameters["status"] = backendStatus;
    }

    final query = Uri(queryParameters: parameters).query;

    final response = await ApiService.get(
      "${_adminEndpoint}crops/?$query",
      auth: true,
    );

    final rawCrops = _extractResults(response);

    return rawCrops
        .whereType<Map>()
        .map(
          (item) => AdminCropModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  static Future<AdminCropModel> updateCropStatus({
    required String cropId,
    required String status,
  }) async {
    final response = await ApiService.patch(
      "${_adminEndpoint}crops/$cropId/status/",
      {"status": status},
      auth: true,
    );

    return AdminCropModel.fromJson(
      _toMap(response),
    );
  }

  static Future<void> deleteCrop({
    required String cropId,
  }) async {
    await ApiService.delete(
      "${_adminEndpoint}crops/$cropId/",
      auth: true,
    );
  }

  static List<dynamic> _extractResults(dynamic response) {
    if (response is List) {
      return response;
    }

    if (response is Map) {
      final results = response["results"] ?? response["data"];

      if (results is List) {
        return results;
      }
    }

    throw Exception("Invalid paginated response.");
  }

  static Map<String, dynamic> _toMap(dynamic response) {
    if (response is Map<String, dynamic>) {
      return response;
    }

    if (response is Map) {
      return Map<String, dynamic>.from(response);
    }

    throw Exception("Invalid server response.");
  }

  static String _cropBackendStatus(String value) {
    switch (value.trim().toLowerCase()) {
      case "active":
        return "active";
      case "sold out":
        return "sold_out";
      case "draft":
        return "draft";
      default:
        return "";
    }
  }
}