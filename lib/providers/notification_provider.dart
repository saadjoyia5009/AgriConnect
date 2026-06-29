import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  String selectedFilter = "All";

  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: "1",
      title: "New Inquiry Received",
      message: "Ahmed wants to buy your Organic Wheat crop.",
      type: "inquiry",
      time: "2 min ago",
      isRead: false,
    ),
    NotificationModel(
      id: "2",
      title: "New Chat Message",
      message: "Buyer sent: Can you supply 100kg this week?",
      type: "chat",
      time: "10 min ago",
      isRead: false,
    ),
    NotificationModel(
      id: "3",
      title: "Inquiry Accepted",
      message: "You accepted inquiry for Premium Rice.",
      type: "inquiry",
      time: "Yesterday",
      isRead: true,
    ),
    NotificationModel(
      id: "4",
      title: "System Update",
      message: "Your farmer profile was updated successfully.",
      type: "system",
      time: "2 days ago",
      isRead: true,
    ),
  ];

  List<NotificationModel> get notifications {
    if (selectedFilter == "Unread") {
      return _notifications.where((n) => !n.isRead).toList();
    }

    if (selectedFilter == "Inquiry") {
      return _notifications.where((n) => n.type == "inquiry").toList();
    }

    if (selectedFilter == "Chat") {
      return _notifications.where((n) => n.type == "chat").toList();
    }

    return _notifications;
  }

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void changeFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (final item in _notifications) {
      item.isRead = true;
    }
    notifyListeners();
  }
}