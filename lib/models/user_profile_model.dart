class UserProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String phone;
  final String address;
  final String profileImage;
  final bool isVerified;
  final DateTime? dateJoined;

  const UserProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.phone,
    required this.address,
    required this.profileImage,
    required this.isVerified,
    required this.dateJoined,
  });

  factory UserProfileModel.fromJson(
      Map<String, dynamic> json,
      ) {
    /*
     * Kuch backend responses directly profile return karte hain:
     *
     * {
     *   "id": 1,
     *   "username": "Muhammad Saad"
     * }
     *
     * Aur kuch nested data return karte hain:
     *
     * {
     *   "data": {
     *     "id": 1,
     *     "username": "Muhammad Saad"
     *   }
     * }
     */
    final Map<String, dynamic> profileData = _extractProfileData(json);

    final Map<String, dynamic> userData =
    profileData["user"] is Map
        ? Map<String, dynamic>.from(profileData["user"])
        : <String, dynamic>{};

    final String parsedName = _firstNonEmpty([
      profileData["full_name"],
      profileData["username"],
      profileData["name"],
      userData["full_name"],
      userData["username"],
      userData["name"],
    ]);

    final String parsedEmail = _firstNonEmpty([
      profileData["email"],
      userData["email"],
    ]);

    final String parsedRole = _firstNonEmpty([
      profileData["role"],
      userData["role"],
    ]);

    final String parsedId = _firstNonEmpty([
      profileData["id"],
      profileData["user_id"],
      userData["id"],
    ]);

    final String parsedProfileImage = _firstNonEmpty([
      profileData["profile_image"],
      profileData["profile_image_url"],
      profileData["image"],
      userData["profile_image"],
    ]);

    return UserProfileModel(
      id: parsedId,
      fullName: parsedName,
      email: parsedEmail,
      role: parsedRole.toLowerCase(),
      phone: _firstNonEmpty([
        profileData["phone"],
        userData["phone"],
      ]),
      address: _firstNonEmpty([
        profileData["address"],
        profileData["location"],
        userData["address"],
        userData["location"],
      ]),
      profileImage: parsedProfileImage,
      isVerified: _parseBoolean(
        profileData["is_verified"] ??
            profileData["is_email_verified"] ??
            userData["is_verified"] ??
            userData["is_email_verified"],
      ),
      dateJoined: _parseDate([
        profileData["date_joined"],
        profileData["created_at"],
        userData["date_joined"],
        userData["created_at"],
      ]),
    );
  }

  static Map<String, dynamic> _extractProfileData(
      Map<String, dynamic> json,
      ) {
    final dynamic data = json["data"];

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    final dynamic profile = json["profile"];

    if (profile is Map) {
      return Map<String, dynamic>.from(profile);
    }

    return json;
  }

  static String _firstNonEmpty(List<dynamic> values) {
    for (final value in values) {
      if (value == null) continue;

      final String text = value.toString().trim();

      if (text.isNotEmpty && text.toLowerCase() != "null") {
        return text;
      }
    }

    return "";
  }

  static bool _parseBoolean(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    final String text = value?.toString().trim().toLowerCase() ?? "";

    return text == "true" ||
        text == "1" ||
        text == "yes" ||
        text == "verified";
  }

  static DateTime? _parseDate(List<dynamic> values) {
    for (final value in values) {
      if (value == null) continue;

      final DateTime? parsed = DateTime.tryParse(
        value.toString(),
      );

      if (parsed != null) {
        return parsed;
      }
    }

    return null;
  }

  String get displayName {
    final String cleanName = fullName.trim();

    if (cleanName.isNotEmpty) {
      return cleanName;
    }

    return "User";
  }

  String get displayRole {
    final String cleanRole = role.trim();

    if (cleanRole.isEmpty) {
      return "User";
    }

    return cleanRole[0].toUpperCase() +
        cleanRole.substring(1).toLowerCase();
  }

  String get displayPhone {
    if (phone.trim().isEmpty) {
      return "No phone added";
    }

    return phone.trim();
  }

  String get displayAddress {
    if (address.trim().isEmpty) {
      return "No location added";
    }

    return address.trim();
  }

  String get initials {
    final List<String> parts = displayName
        .split(RegExp(r"\s+"))
        .where((part) => part.trim().isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return "U";
    }

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return "${parts.first[0]}${parts.last[0]}".toUpperCase();
  }

  String get memberSince {
    if (dateJoined == null) {
      return "";
    }

    const List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    return "${months[dateJoined!.month - 1]} ${dateJoined!.year}";
  }
}