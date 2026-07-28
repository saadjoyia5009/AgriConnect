class AdminUserModel {
  final String id;
  final String username;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String role;
  final bool isActive;
  final bool isEmailVerified;
  final bool isStaff;
  final String joinedDate;

  const AdminUserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.role,
    required this.isActive,
    required this.isEmailVerified,
    required this.isStaff,
    required this.joinedDate,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    final firstName = json["first_name"]?.toString().trim() ?? "";
    final lastName = json["last_name"]?.toString().trim() ?? "";
    final username = json["username"]?.toString().trim() ?? "";

    final fullName = [
      firstName,
      lastName,
    ].where((value) => value.isNotEmpty).join(" ").trim();

    return AdminUserModel(
      id: json["id"]?.toString() ?? "",
      username: username,
      name: fullName.isNotEmpty ? fullName : username,
      email: json["email"]?.toString() ?? "",
      phone: json["phone"]?.toString() ?? "",
      address: json["address"]?.toString() ?? "",
      role: _formatRole(json["role"]?.toString()),
      isActive: json["is_active"] == true,
      isEmailVerified: json["is_email_verified"] == true,
      isStaff: json["is_staff"] == true,
      joinedDate: _formatDate(json["date_joined"]?.toString()),
    );
  }

  AdminUserModel copyWith({
    String? id,
    String? username,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? role,
    bool? isActive,
    bool? isEmailVerified,
    bool? isStaff,
    String? joinedDate,
  }) {
    return AdminUserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isStaff: isStaff ?? this.isStaff,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }

  static String _formatRole(String? value) {
    final role = value?.trim().toLowerCase() ?? "";

    if (role.isEmpty) return "Unknown";

    return "${role[0].toUpperCase()}${role.substring(1)}";
  }

  static String _formatDate(String? value) {
    final date = DateTime.tryParse(value ?? "")?.toLocal();

    if (date == null) return "";

    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    final day = date.day.toString().padLeft(2, "0");

    return "$day ${months[date.month - 1]} ${date.year}";
  }
}