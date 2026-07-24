import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../config/api_config.dart';
import '../utils/token_storage.dart';
import 'api_service.dart';

class ProfileService {
  static const String _endpoint = "/profile/";

  static Future<Map<String, dynamic>> fetchProfile() async {
    final dynamic response = await ApiService.get(
      _endpoint,
      auth: true,
    );

    if (response is Map<String, dynamic>) {
      return _extractProfileData(response);
    }

    if (response is Map) {
      return _extractProfileData(
        Map<String, dynamic>.from(response),
      );
    }

    throw Exception("Invalid profile response received from server.");
  }

  static Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    required String phone,
    required String address,
    XFile? profileImage,
  }) async {
    final String? token =
    await TokenStorage.getAccessToken();

    if (token == null || token.trim().isEmpty) {
      throw Exception(
        "Your session has expired. Please login again.",
      );
    }

    final Uri uri = Uri.parse(
      "${ApiConfig.baseUrl}$_endpoint",
    );

    /*
     * Backend PATCH allow nahi kar raha tha,
     * is liye yahan PUT use kiya gaya hai.
     */
    final http.MultipartRequest request =
    http.MultipartRequest(
      "PUT",
      uri,
    );

    request.headers.addAll({
      "Authorization": "Bearer ${token.trim()}",
      "Accept": "application/json",
    });

    /*
     * Backend mein field username ho sakti hai.
     * full_name bhi bhej rahe hain taa ke dono possible
     * serializer structures support ho sakein.
     */
    request.fields.addAll({
      "username": fullName.trim(),
      "full_name": fullName.trim(),
      "phone": phone.trim(),
      "address": address.trim(),
    });

    if (profileImage != null) {
      final List<int> bytes =
      await profileImage.readAsBytes();

      request.files.add(
        http.MultipartFile.fromBytes(
          "profile_image",
          bytes,
          filename: profileImage.name,
        ),
      );
    }

    final http.StreamedResponse streamedResponse =
    await request.send();

    final http.Response response =
    await http.Response.fromStream(
      streamedResponse,
    );

    final dynamic decoded =
    ApiService.handleResponse(response);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }

    throw Exception(
      "Invalid profile update response received from server.",
    );
  }

  static Map<String, dynamic> _extractProfileData(
      Map<String, dynamic> response,
      ) {
    final dynamic data = response["data"];

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    final dynamic profile = response["profile"];

    if (profile is Map) {
      return Map<String, dynamic>.from(profile);
    }

    return response;
  }
}