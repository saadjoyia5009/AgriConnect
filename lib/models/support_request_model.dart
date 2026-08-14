class SupportRequestModel {
  final int? id;
  final String message;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SupportRequestModel({
    this.id,
    required this.message,
    this.status = 'pending',
    this.createdAt,
    this.updatedAt,
  });

  factory SupportRequestModel.fromJson(Map<String, dynamic> json) {
    return SupportRequestModel(
      id: json['id'],
      message: json['message'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}