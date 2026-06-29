import 'package:flutter/material.dart';
import '../models/admin_user_model.dart';

class AdminUsersProvider extends ChangeNotifier {
  bool isLoading = false;
  String selectedFilter = "All";
  String searchQuery = "";

  final List<AdminUserModel> _users = [];

  List<AdminUserModel> get users {
    return _users.where((user) {
      final matchesFilter =
          selectedFilter == "All" || user.role == selectedFilter;

      final matchesSearch =
          user.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              user.email.toLowerCase().contains(searchQuery.toLowerCase()) ||
              user.phone.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();
  }

  Future<void> fetchUsers() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _users.clear();
    _users.addAll([
      AdminUserModel(
        id: "1",
        name: "Ahmed Khan",
        email: "ahmed@example.com",
        phone: "+92 300 1111111",
        role: "Farmer",
        isActive: true,
        joinedDate: "12 Jun 2026",
      ),
      AdminUserModel(
        id: "2",
        name: "Ali Raza",
        email: "ali@example.com",
        phone: "+92 301 2222222",
        role: "Buyer",
        isActive: true,
        joinedDate: "14 Jun 2026",
      ),
      AdminUserModel(
        id: "3",
        name: "Usman Malik",
        email: "usman@example.com",
        phone: "+92 302 3333333",
        role: "Farmer",
        isActive: false,
        joinedDate: "18 Jun 2026",
      ),
    ]);

    isLoading = false;
    notifyListeners();
  }

  void changeFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  void updateSearch(String value) {
    searchQuery = value;
    notifyListeners();
  }

  void toggleUserStatus(String id) {
    final index = _users.indexWhere((user) => user.id == id);
    if (index == -1) return;

    final old = _users[index];

    _users[index] = AdminUserModel(
      id: old.id,
      name: old.name,
      email: old.email,
      phone: old.phone,
      role: old.role,
      isActive: !old.isActive,
      joinedDate: old.joinedDate,
    );

    notifyListeners();
  }
}