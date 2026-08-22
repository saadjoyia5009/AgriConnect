class SupportRequestModel {
  final int? id;
  final String message;
  final String status;
  final String statusDisplay;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? resolvedAt;

  const SupportRequestModel({
    this.id,
    required this.message,
    this.status = 'pending',
    this.statusDisplay = 'Pending',
    this.createdAt,
    this.updatedAt,
    this.resolvedAt,
  });

  factory SupportRequestModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return SupportRequestModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(
        json['id']?.toString() ?? '',
      ),
      message: json['message']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      statusDisplay:
      json['status_display']?.toString() ??
          _getStatusDisplay(
            json['status']?.toString(),
          ),
      createdAt: _parseDateTime(
        json['created_at'],
      ),
      updatedAt: _parseDateTime(
        json['updated_at'],
      ),
      resolvedAt: _parseDateTime(
        json['resolved_at'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'status': status,
      'status_display': statusDisplay,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'resolved_at': resolvedAt?.toIso8601String(),
    };
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    return DateTime.tryParse(
      value.toString(),
    );
  }

  static String _getStatusDisplay(String? status) {
    switch (status) {
      case 'in_progress':
        return 'In Progress';

      case 'resolved':
        return 'Resolved';

      case 'pending':
      default:
        return 'Pending';
    }
  }
}