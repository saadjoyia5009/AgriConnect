import 'package:flutter/material.dart';

import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  String selectedFilter = "All";

  final List<NotificationModel> _notifications = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<NotificationModel> get notifications =>
      List.unmodifiable(_notifications);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  List<NotificationModel> getNotifications(String role) {
    List<NotificationModel> data = List.from(_notifications);

    if (selectedFilter == "Unread") {
      data = data.where((notification) => !notification.isRead).toList();
    }

    if (selectedFilter == "Inquiry") {
      data = data
          .where((notification) => notification.type == "inquiry")
          .toList();
    }

    if (selectedFilter == "Chat") {
      data = data
          .where((notification) => notification.type == "chat")
          .toList();
    }

    return data;
  }

  int unreadCount(String role) {
    return _notifications.where((notification) => !notification.isRead).length;
  }

  void changeFilter(String filter) {
    if (selectedFilter == filter) return;

    selectedFilter = filter;
    notifyListeners();
  }

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetchedNotifications =
      await NotificationService.getNotifications();

      _notifications
        ..clear()
        ..addAll(fetchedNotifications);

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> markAsRead(String id) async {
    try {
      final updatedNotification =
      await NotificationService.markAsRead(id);

      final index = _notifications.indexWhere(
            (notification) => notification.id == id,
      );

      if (index != -1) {
        _notifications[index] = updatedNotification;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> markAllAsRead(String role) async {
    try {
      await NotificationService.markAllAsRead();

      for (final notification in _notifications) {
        notification.isRead = true;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}