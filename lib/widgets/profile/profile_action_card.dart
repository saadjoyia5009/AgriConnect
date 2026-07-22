import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';

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
              Expanded(
                child: Text(
                  context.watch<LanguageProvider>().t("accountSettings"),
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
            title: context.watch<LanguageProvider>().t("editProfile"),
            onTap: onEditProfile,
          ),
          _divider(),

          ProfileActionTile(
            icon: Icons.language,
            title: context.watch<LanguageProvider>().t("language"),
            trailingText: language,
            onTap: onLanguage,
          ),
          _divider(),

          ProfileActionTile(
            icon: Icons.notifications,
            title: context.watch<LanguageProvider>().t("notifications"),
            onTap: onNotifications,
          ),
          _divider(),

          ProfileActionTile(
            icon: Icons.lock,
            title: context.watch<LanguageProvider>().t("changePassword"),
            onTap: onChangePassword,
          ),
          _divider(),

          ProfileActionTile(
            icon: Icons.dark_mode,
            title: context.watch<LanguageProvider>().t("appearance"),
            trailingText: isDarkMode
                ? context.watch<LanguageProvider>().t("darkMode")
                : context.watch<LanguageProvider>().t("lightMode"),
            onTap: onAppearance,
          ),
          _divider(),

          ProfileActionTile(
            icon: Icons.headset_mic,
            title: context.watch<LanguageProvider>().t("helpSupport"),
            onTap: onHelpSupport,
          ),
          _divider(),

          ProfileActionTile(
            icon: Icons.info,
            title: context.watch<LanguageProvider>().t("aboutAgriConnect"),
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
      child: const Icon(Icons.settings, color: darkGreen, size: 24),
    );
  }

  Widget _divider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey.shade300);
  }
}
