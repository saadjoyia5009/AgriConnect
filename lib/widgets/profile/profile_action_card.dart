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
    final lang = context.watch<LanguageProvider>();

    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        22,
        22,
        22,
        18,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xff171d19)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white12
              : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.18 : 0.06,
            ),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // =====================================================
          // HEADER
          // =====================================================

          Row(
            children: [
              _iconBox(
                Icons.settings,
                isDark,
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  lang.t("accountSettings"),
                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : darkGreen,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // =====================================================
          // EDIT PROFILE
          // =====================================================

          ProfileActionTile(
            icon: Icons.person,
            title: lang.t("editProfile"),
            onTap: onEditProfile,
          ),

          _divider(isDark),

          // =====================================================
          // LANGUAGE
          // =====================================================

          ProfileActionTile(
            icon: Icons.language,
            title: lang.t("language"),
            trailingText: language,
            onTap: onLanguage,
          ),

          _divider(isDark),

          // =====================================================
          // NOTIFICATIONS
          // =====================================================

          ProfileActionTile(
            icon: Icons.notifications,
            title: lang.t("notifications"),
            onTap: onNotifications,
          ),

          _divider(isDark),

          // =====================================================
          // CHANGE PASSWORD
          // =====================================================

          ProfileActionTile(
            icon: Icons.lock,
            title: lang.t("changePassword"),
            onTap: onChangePassword,
          ),

          _divider(isDark),

          // =====================================================
          // APPEARANCE
          // =====================================================

          ProfileActionTile(
            icon: Icons.dark_mode,
            title: lang.t("appearance"),
            trailingText: isDarkMode
                ? lang.t("darkMode")
                : lang.t("lightMode"),
            onTap: onAppearance,
          ),

          _divider(isDark),

          // =====================================================
          // HELP & SUPPORT
          // =====================================================

          ProfileActionTile(
            icon: Icons.headset_mic,
            title: lang.t("helpSupport"),
            onTap: onHelpSupport,
          ),

          _divider(isDark),

          // =====================================================
          // ABOUT AGRICONNECT
          // =====================================================

          ProfileActionTile(
            icon: Icons.info,
            title: lang.t("aboutAgriConnect"),
            onTap: onAboutApp,
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // HEADER ICON
  // ===========================================================

  Widget _iconBox(
      IconData icon,
      bool isDark,
      ) {
    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xff20372b)
            : const Color(0xffe8f5ee),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: isDark
            ? const Color(0xff65c98e)
            : darkGreen,
        size: 24,
      ),
    );
  }

  // ===========================================================
  // DIVIDER
  // ===========================================================

  Widget _divider(
      bool isDark,
      ) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark
          ? Colors.white12
          : Colors.grey.shade300,
    );
  }
}