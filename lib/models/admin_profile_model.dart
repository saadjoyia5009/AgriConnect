class AdminProfileModel {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String role;
  final bool isEmailVerified;
  final bool isActive;
  final String joinedDate;
  final String lastLogin;

  const AdminProfileModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.role,
    required this.isEmailVerified,
    required this.isActive,
    required this.joinedDate,
    required this.lastLogin,
  });

  String get fullName {
    final name = [
      firstName,
      lastName,
    ].where((value) => value.trim().isNotEmpty).join(" ").trim();

    if (name.isNotEmpty) {
      return name;
    }

    if (username.isNotEmpty) {
      return username;
    }

    return "AgriConnect Admin";
  }

  factory AdminProfileModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return AdminProfileModel(
      id: json["id"]?.toString() ?? "",
      username: json["username"]?.toString() ?? "",
      firstName: json["first_name"]?.toString() ?? "",
      lastName: json["last_name"]?.toString() ?? "",
      email: json["email"]?.toString() ?? "",
      phone: json["phone"]?.toString() ?? "",
      address: json["address"]?.toString() ?? "",
      role: _formatRole(json["role"]?.toString()),
      isEmailVerified:
      json["is_email_verified"] == true,
      isActive: json["is_active"] == true,
      joinedDate: _formatDate(
        json["date_joined"]?.toString(),
      ),
      lastLogin: _formatDate(
        json["last_login"]?.toString(),
        includeTime: true,
      ),
    );
  }

  AdminProfileModel copyWith({
    String? id,
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? role,
    bool? isEmailVerified,
    bool? isActive,
    String? joinedDate,
    String? lastLogin,
  }) {
    return AdminProfileModel(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role ?? this.role,
      isEmailVerified:
      isEmailVerified ?? this.isEmailVerified,
      isActive: isActive ?? this.isActive,
      joinedDate: joinedDate ?? this.joinedDate,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  static String _formatRole(String? value) {
    final role = value?.trim().toLowerCase() ?? "";

    if (role.isEmpty) {
      return "Administrator";
    }

    return "${role[0].toUpperCase()}${role.substring(1)}";
  }

  static String _formatDate(
      String? value, {
        bool includeTime = false,
      }) {
    final date = DateTime.tryParse(
      value ?? "",
    )?.toLocal();

    if (date == null) {
      return "";
    }

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
    final formattedDate =
        "$day ${months[date.month - 1]} ${date.year}";

    if (!includeTime) {
      return formattedDate;
    }

    final hour = date.hour.toString().padLeft(2, "0");
    final minute = date.minute.toString().padLeft(2, "0");

    return "$formattedDate, $hour:$minute";
  }
}