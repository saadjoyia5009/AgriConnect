import '../models/support_request_model.dart';
import 'api_service.dart';

class SupportService {
  static const String _baseEndpoint = '/support/tickets/';

  /// Submit a new customer support request.
  ///
  /// Backend:
  /// POST /api/support/tickets/
  Future<SupportRequestModel> submitRequest({
    required String message,
  }) async {
    final response = await ApiService.post(
      _baseEndpoint,
      {
        'message': message,
      },
      auth: true,
    );

    if (response is! Map<String, dynamic>) {
      throw Exception(
        'Invalid support request response.',
      );
    }

    return SupportRequestModel.fromJson(response);
  }

  /// Get support requests of the current user.
  ///
  /// Backend:
  /// GET /api/support/tickets/
  Future<List<SupportRequestModel>> getMyRequests() async {
    final response = await ApiService.get(
      _baseEndpoint,
      auth: true,
    );

    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map(SupportRequestModel.fromJson)
          .toList();
    }

    if (response is Map<String, dynamic>) {
      final results = response['results'];

      if (results is List) {
        return results
            .whereType<Map<String, dynamic>>()
            .map(SupportRequestModel.fromJson)
            .toList();
      }
    }

    throw Exception(
      'Invalid support requests response.',
    );
  }

  /// Get a specific support request.
  ///
  /// Backend:
  /// GET /api/support/tickets/<id>/
  Future<SupportRequestModel> getRequest(
      int id,
      ) async {
    final response = await ApiService.get(
      '$_baseEndpoint$id/',
      auth: true,
    );

    if (response is! Map<String, dynamic>) {
      throw Exception(
        'Invalid support request response.',
      );
    }

    return SupportRequestModel.fromJson(response);
  }
}