import 'package:agriconnect/services/api_service.dart';

class InquiryService {
  static const String _endpoint = "/inquiries/";

  static Future<List<dynamic>> fetchInquiries() async {
    final response = await ApiService.get(_endpoint, auth: true);

    if (response is List) {
      return response;
    }

    if (response is Map) {
      if (response["results"] is List) {
        return response["results"] as List<dynamic>;
      }

      if (response["data"] is List) {
        return response["data"] as List<dynamic>;
      }
    }

    return [];
  }

  static Future<Map<String, dynamic>> sendInquiry({
    required String cropId,
    required String quantity,
    required String offeredPrice,
    required String deliveryDate,
    required String message,
  }) async {
    final response = await ApiService.post(_endpoint, {
      "crop": cropId,
      "quantity_requested": quantity,
      "offered_price": offeredPrice,
      "delivery_date": deliveryDate,
      "message": message,
    }, auth: true);

    if (response is Map<String, dynamic>) {
      return response;
    }

    if (response is Map) {
      return Map<String, dynamic>.from(response);
    }

    throw Exception("Invalid inquiry response received.");
  }

  static Future<Map<String, dynamic>> acceptInquiry(String id) async {
    final response = await ApiService.patch(
      "$_endpoint$id/accept/",
      {},
      auth: true,
    );

    if (response is Map<String, dynamic>) {
      return response;
    }

    if (response is Map) {
      return Map<String, dynamic>.from(response);
    }

    throw Exception("Invalid accept inquiry response.");
  }

  static Future<Map<String, dynamic>> rejectInquiry(String id) async {
    final response = await ApiService.patch(
      "$_endpoint$id/reject/",
      {},
      auth: true,
    );

    if (response is Map<String, dynamic>) {
      return response;
    }

    if (response is Map) {
      return Map<String, dynamic>.from(response);
    }

    throw Exception("Invalid reject inquiry response.");
  }
}
