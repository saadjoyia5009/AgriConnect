import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  String selectedFilter = "All";

  final List<NotificationModel> _notifications = [
    // Farmer Notifications
    NotificationModel(
      id: "1",
      title: "New Inquiry Received",
      message: "Ahmed wants to buy your Organic Wheat crop.",
      type: "inquiry",
      role: "farmer",
      referenceId: "inq_101",
      navigationType: "inquiry_detail",
      time: "2 min ago",
      isRead: false,
    ),

    NotificationModel(
      id: "2",
      title: "New Chat Message",
      message: "Buyer sent: Can you supply 100kg this week?",
      type: "chat",
      role: "farmer",
      referenceId: "chat_11",
      navigationType: "chat",
      time: "10 min ago",
      isRead: false,
    ),

    // Buyer Notifications
    NotificationModel(
      id: "3",
      title: "Inquiry Accepted",
      message: "Farmer accepted your inquiry for Premium Rice.",
      type: "inquiry",
      role: "buyer",
      referenceId: "inq_102",
      navigationType: "chat",
      time: "5 min ago",
      isRead: false,
    ),

    NotificationModel(
      id: "4",
      title: "New Chat Message",
      message: "Farmer: Yes, crop is available.",
      type: "chat",
      role: "buyer",
      referenceId: "chat_22",
      navigationType: "chat",
      time: "12 min ago",
      isRead: false,
    ),

    NotificationModel(
      id: "5",
      title: "System Update",
      message: "Your profile was updated successfully.",
      type: "system",
      role: "buyer",
      referenceId: null,
      navigationType: null,
      time: "Yesterday",
      isRead: true,
    ),
  ];

  List<NotificationModel> getNotifications(String role) {
    var data = _notifications.where((n) => n.role == role).toList();

    if (selectedFilter == "Unread") {
      data = data.where((n) => !n.isRead).toList();
    }

    if (selectedFilter == "Inquiry") {
      data = data.where((n) => n.type == "inquiry").toList();
    }

    if (selectedFilter == "Chat") {
      data = data.where((n) => n.type == "chat").toList();
    }

    return data;
  }

  int unreadCount(String role) {
    return _notifications.where((n) => n.role == role && !n.isRead).length;
  }

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

  void markAllAsRead(String role) {
    for (final notification in _notifications) {
      if (notification.role == role) {
        notification.isRead = true;
      }
    }

    notifyListeners();
  }

  Future<void> fetchNotifications() async {
    // Future Backend API

    // final response =
    // await NotificationService.getNotifications();

    // _notifications.clear();
    // _notifications.addAll(
    //   response.map((e) => NotificationModel.fromJson(e))
    // );

    notifyListeners();
  }
}
