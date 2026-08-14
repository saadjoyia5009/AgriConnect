import '../models/support_request_model.dart';

class SupportService {
  /// Submit a new customer support request.
  ///
  /// Abhi dummy implementation hai.
  /// Backend API ready hone ke baad isi method mein
  /// actual HTTP POST request add karenge.
  Future<SupportRequestModel> submitRequest({
    required String message,
  }) async {
    // Temporary delay to simulate API request.
    await Future.delayed(const Duration(milliseconds: 800));

    // Temporary dummy response.
    return SupportRequestModel(
      id: DateTime.now().millisecondsSinceEpoch,
      message: message,
      status: 'pending',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Get support requests of the current user.
  ///
  /// Backend integration ke waqt yahan GET API connect hogi.
  Future<List<SupportRequestModel>> getMyRequests() async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Temporary empty list.
    return [];
  }
}