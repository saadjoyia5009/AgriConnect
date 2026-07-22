import 'package:flutter/material.dart';
import '../models/admin_report_model.dart';

class AdminReportsProvider extends ChangeNotifier {
  bool isLoading = false;
  String selectedFilter = "All";

  final List<AdminReportModel> _reports = [];

  List<AdminReportModel> get reports {
    if (selectedFilter == "All") return _reports;
    return _reports.where((report) => report.status == selectedFilter).toList();
  }

  Future<void> fetchReports() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _reports.clear();
    _reports.addAll([
      AdminReportModel(
        id: "1",
        title: "Fake Crop Listing",
        description: "Buyer reported that crop price and quantity look fake.",
        reportedBy: "Ali Raza",
        targetType: "Crop",
        targetName: "Premium Rice",
        status: "Pending",
        date: "24 Jun 2026",
      ),
      AdminReportModel(
        id: "2",
        title: "Spam User",
        description: "User is sending repeated irrelevant inquiries.",
        reportedBy: "Ahmed Khan",
        targetType: "User",
        targetName: "Usman Malik",
        status: "Reviewed",
        date: "25 Jun 2026",
      ),
      AdminReportModel(
        id: "3",
        title: "Wrong Crop Details",
        description: "Listed crop category does not match uploaded details.",
        reportedBy: "Bilal Ahmed",
        targetType: "Crop",
        targetName: "Cotton Crop",
        status: "Resolved",
        date: "26 Jun 2026",
      ),
    ]);

    isLoading = false;
    notifyListeners();
  }

  void changeFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  void updateReportStatus(String id, String status) {
    final index = _reports.indexWhere((report) => report.id == id);
    if (index == -1) return;

    final old = _reports[index];

    _reports[index] = AdminReportModel(
      id: old.id,
      title: old.title,
      description: old.description,
      reportedBy: old.reportedBy,
      targetType: old.targetType,
      targetName: old.targetName,
      status: status,
      date: old.date,
    );

    notifyListeners();
  }
}
