import 'package:agriconnect/services/api_service.dart';

class InquiryService {
  static const String _endpoint = "/inquiries/";

  static Future<List<dynamic>> fetchInquiries() async {
    final response = await ApiService.get(_endpoint, auth: true);
    return response as List<dynamic>;
  }

  static Future<dynamic> sendInquiry(Map<String, dynamic> data) async {
    final response = await ApiService.post(
      _endpoint,
      data,
      auth: true,
    );
    return response;
  }

  static Future<dynamic> acceptInquiry(String id) async {
    final response = await ApiService.patch(
      "$_endpoint$id/accept/",
      {},
      auth: true,
    );
    return response;
  }

  static Future<dynamic> rejectInquiry(String id) async {
    final response = await ApiService.patch(
      "$_endpoint$id/reject/",
      {},
      auth: true,
    );
    return response;
  }
}
