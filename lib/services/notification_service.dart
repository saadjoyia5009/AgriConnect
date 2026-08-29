import '../models/notification_model.dart';
import 'api_service.dart';

class NotificationService {
  static const String _endpoint = '/notifications/';

  /// Fetch notifications for the currently authenticated user.
  static Future<List<NotificationModel>> getNotifications() async {
    final response = await ApiService.get(
      _endpoint,
      auth: true,
    );

    if (response is! List) {
      throw Exception('Invalid notifications response from server.');
    }

    return response
        .map(
          (item) => NotificationModel.fromJson(
        Map<String, dynamic>.from(item as Map),
      ),
    )
        .toList();
  }

  /// Mark one notification as read.
  static Future<NotificationModel> markAsRead(
      String notificationId,
      ) async {
    final response = await ApiService.patch(
      '$_endpoint$notificationId/read/',
      {},
      auth: true,
    );

    if (response is! Map) {
      throw Exception('Invalid mark-as-read response from server.');
    }

    final dynamic data = response['data'];

    if (data is! Map) {
      throw Exception('Notification data was not returned by server.');
    }

    return NotificationModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  /// Mark all unread notifications as read.
  static Future<int> markAllAsRead() async {
    final response = await ApiService.patch(
      '${_endpoint}mark-all-read/',
      {},
      auth: true,
    );

    if (response is! Map) {
      throw Exception('Invalid mark-all-read response from server.');
    }

    final dynamic updatedCount = response['updated_count'];

    if (updatedCount is int) {
      return updatedCount;
    }

    return int.tryParse(updatedCount?.toString() ?? '0') ?? 0;
  }
}
