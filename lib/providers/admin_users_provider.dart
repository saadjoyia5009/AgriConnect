import 'dart:async';

import 'package:flutter/material.dart';

import '../models/admin_user_model.dart';
import '../services/admin_service.dart';

class AdminUsersProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  String _selectedFilter = "All";
  String _searchQuery = "";

  Timer? _searchDebounce;

  final List<AdminUserModel> _users = [];
  final Set<String> _updatingUserIds = {};

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;

  List<AdminUserModel> get users {
    return List.unmodifiable(_users);
  }

  bool isUpdatingUser(String userId) {
    return _updatingUserIds.contains(userId);
  }

  Future<void> fetchUsers({
    bool showLoading = true,
  }) async {
    if (_isLoading) return;

    try {
      if (showLoading) {
        _isLoading = true;
      }

      _errorMessage = null;
      notifyListeners();

      final loadedUsers = await AdminService.fetchUsers(
        search: _searchQuery,
        role: _selectedFilter,
      );

      _users
        ..clear()
        ..addAll(loadedUsers);
    } catch (error) {
      _errorMessage = _cleanError(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUsers() async {
    await fetchUsers(showLoading: false);
  }

  void changeFilter(String filter) {
    if (_selectedFilter == filter) return;

    _selectedFilter = filter;
    notifyListeners();

    fetchUsers();
  }

  void updateSearch(String value) {
    _searchQuery = value.trim();
    _searchDebounce?.cancel();

    _searchDebounce = Timer(
      const Duration(milliseconds: 500),
          () {
        fetchUsers();
      },
    );
  }

  Future<bool> toggleUserStatus(String id) async {
    if (_updatingUserIds.contains(id)) {
      return false;
    }

    final index = _users.indexWhere(
          (user) => user.id == id,
    );

    if (index == -1) {
      _errorMessage = "User not found.";
      notifyListeners();
      return false;
    }

    final currentUser = _users[index];

    try {
      _updatingUserIds.add(id);
      _errorMessage = null;
      notifyListeners();

      final updatedUser = await AdminService.updateUserStatus(
        userId: id,
        isActive: !currentUser.isActive,
      );

      final updatedIndex = _users.indexWhere(
            (user) => user.id == id,
      );

      if (updatedIndex != -1) {
        _users[updatedIndex] = updatedUser;
      }

      return true;
    } catch (error) {
      _errorMessage = _cleanError(error);
      return false;
    } finally {
      _updatingUserIds.remove(id);
      notifyListeners();
    }
  }

  void clearError() {
    if (_errorMessage == null) return;

    _errorMessage = null;
    notifyListeners();
  }

  void clearUsers() {
    _searchDebounce?.cancel();
    _users.clear();
    _updatingUserIds.clear();
    _errorMessage = null;
    _isLoading = false;
    _selectedFilter = "All";
    _searchQuery = "";
    notifyListeners();
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst("Exception: ", "")
        .trim();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}