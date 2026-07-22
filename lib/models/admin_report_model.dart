class AdminReportModel {
  final String id;
  final String title;
  final String description;
  final String reportedBy;
  final String targetType;
  final String targetName;
  final String status;
  final String date;

  AdminReportModel({
    required this.id,
    required this.title,
    required this.description,
    required this.reportedBy,
    required this.targetType,
    required this.targetName,
    required this.status,
    required this.date,
  });

  factory AdminReportModel.fromJson(Map<String, dynamic> json) {
    return AdminReportModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      reportedBy: json['reported_by'] ?? '',
      targetType: json['target_type'] ?? '',
      targetName: json['target_name'] ?? '',
      status: json['status'] ?? 'Pending',
      date: json['date'] ?? '',
    );
  }
}
