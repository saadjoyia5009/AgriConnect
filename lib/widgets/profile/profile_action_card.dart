import 'package:flutter/material.dart';

import 'profile_action_tile.dart';

class ProfileActionCard extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;
  final VoidCallback onLanguage;
  final VoidCallback onNotifications;
  final VoidCallback onAppearance;
  final VoidCallback onHelpSupport;
  final VoidCallback onAboutApp;
  final String language;
  final bool isDarkMode;

  const ProfileActionCard({
    super.key,
    required this.onEditProfile,
    required this.onChangePassword,
    required this.onLanguage,
    required this.onNotifications,
    required this.onAppearance,
    required this.onHelpSupport,
    required this.onAboutApp,
    required this.language,
    required this.isDarkMode,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _iconBox(Icons.settings),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  "Account Settings",
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          ProfileActionTile(
            icon: Icons.person,
            title: "Edit Profile",
            onTap: onEditProfile,
          ),
          _divider(),

          ProfileActionTile(
            icon: Icons.language,
            title: "Language",
            trailingText: language,
            onTap: onLanguage,
          ),
          _divider(),

          ProfileActionTile(
            icon: Icons.notifications,
            title: "Notifications",
            onTap: onNotifications,
          ),
          _divider(),

          ProfileActionTile(
            icon: Icons.lock,
            title: "Change Password",
            onTap: onChangePassword,
          ),
          _divider(),

          ProfileActionTile(
            icon: Icons.dark_mode,
            title: "Appearance",
            trailingText: isDarkMode ? "Dark Mode" : "Light Mode",
            onTap: onAppearance,
          ),
          _divider(),

          ProfileActionTile(
            icon: Icons.headset_mic,
            title: "Help & Support",
            onTap: onHelpSupport,
          ),
          _divider(),

          ProfileActionTile(
            icon: Icons.info,
            title: "About AgriConnect",
            onTap: onAboutApp,
          ),
        ],
      ),
    );
  }

  Widget _iconBox(IconData icon) {
    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        color: const Color(0xffe8f5ee),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.settings,
        color: darkGreen,
        size: 24,
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade300,
    );
  }
}