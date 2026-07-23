import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/admin/admin_profile_option_tile.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  static const Color darkGreen = Color(0xFF0E5A3C);
  static const Color lightBackground = Color(0xFFF4F8F5);
  static const Color darkBackground = Color(0xFF0B1410);
  static const Color darkCard = Color(0xFF15251E);
  static const Color lightGreen = Color(0xff9ff2c1);

  bool _isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _isDark(context);
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: isDark ? darkBackground : lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? darkCard : darkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context.watch<LanguageProvider>().t("adminProfile"),
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          _profileHeader(context),
          const SizedBox(height: 22),

          AdminProfileOptionTile(
            icon: Icons.admin_panel_settings_rounded,
            title: context.watch<LanguageProvider>().t("adminRole"),
            subtitle: context.watch<LanguageProvider>().t("adminRoleSubtitle"),
            color: isDark ? lightGreen : darkGreen,
            onTap: () {
              _showInfoDialog(
                context,
                context.read<LanguageProvider>().t("adminRole"),
                context.read<LanguageProvider>().t("adminRoleDescription"),
              );
            },
          ),

          AdminProfileOptionTile(
            icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            title: context.watch<LanguageProvider>().t("appTheme"),
            subtitle: isDark
                ? context.watch<LanguageProvider>().t("darkModeEnabled")
                : context.watch<LanguageProvider>().t("lightModeEnabled"),
            color: isDark ? lightGreen : darkGreen,
            onTap: () {
              _showThemeSheet(context, themeProvider);
            },
          ),

          AdminProfileOptionTile(
            icon: Icons.security_rounded,
            title: context.watch<LanguageProvider>().t("security"),
            subtitle: context.watch<LanguageProvider>().t(
              "adminSecuritySubtitle",
            ),
            color: Colors.blue,
            onTap: () {
              Navigator.pushNamed(context, '/forgotPassword');
            },
          ),

          AdminProfileOptionTile(
            icon: Icons.notifications_active_rounded,
            title: context.watch<LanguageProvider>().t("notifications"),
            subtitle: context.watch<LanguageProvider>().t(
              "adminNotificationsSubtitle",
            ),
            color: Colors.orange,
            onTap: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),

          AdminProfileOptionTile(
            icon: Icons.info_rounded,
            title: context.watch<LanguageProvider>().t("aboutAgriConnect"),
            subtitle: context.watch<LanguageProvider>().t(
              "aboutAgriConnectSubtitle",
            ),
            color: Colors.purple,
            onTap: () {
              _showInfoDialog(
                context,
                context.read<LanguageProvider>().t("aboutAgriConnect"),
                context.read<LanguageProvider>().t(
                  "aboutAgriConnectDescription",
                ),
              );
            },
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout_rounded),
              label: Text(
                context.watch<LanguageProvider>().t("logout"),
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeSheet(BuildContext context, ThemeProvider themeProvider) {
    final isDark = _isDark(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? darkCard : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20,
              18,
              20,
              26 + MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.watch<LanguageProvider>().t("chooseTheme"),
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF123524),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),

                _themeOption(
                  context: context,
                  icon: Icons.light_mode_rounded,
                  title: context.watch<LanguageProvider>().t("lightMode"),
                  selected: themeProvider.themeMode == ThemeMode.light,
                  onTap: () async {
                    await themeProvider.setLightMode();
                    if (context.mounted) Navigator.pop(context);
                  },
                ),

                _themeOption(
                  context: context,
                  icon: Icons.dark_mode_rounded,
                  title: context.watch<LanguageProvider>().t("darkMode"),
                  selected: themeProvider.themeMode == ThemeMode.dark,
                  onTap: () async {
                    await themeProvider.setDarkMode();
                    if (context.mounted) Navigator.pop(context);
                  },
                ),

                _themeOption(
                  context: context,
                  icon: Icons.phone_iphone_rounded,
                  title: context.watch<LanguageProvider>().t("systemDefault"),
                  selected: themeProvider.themeMode == ThemeMode.system,
                  onTap: () async {
                    await themeProvider.setSystemMode();
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _themeOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final isDark = _isDark(context);

    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: selected
            ? (isDark ? lightGreen : darkGreen)
            : (isDark ? Colors.white70 : Colors.grey.shade700),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF123524),
          fontWeight: FontWeight.w800,
        ),
      ),
      trailing: selected
          ? Icon(Icons.check_circle, color: isDark ? lightGreen : darkGreen)
          : null,
    );
  }

  void _showInfoDialog(BuildContext context, String title, String message) {
    final isDark = _isDark(context);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: isDark ? darkCard : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF123524),
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              height: 1.4,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                context.read<LanguageProvider>().t("okay"),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: isDark ? lightGreen : darkGreen,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _profileHeader(BuildContext context) {
    final isDark = _isDark(context);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [Color(0xFF123524), Color(0xFF0E5A3C)]
              : const [Color(0xFF0E5A3C), Color(0xFF157A52)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.35)
                : darkGreen.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 68,
            width: 68,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(isDark ? 0.14 : 0.18),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withOpacity(isDark ? 0.10 : 0),
              ),
            ),
            child: const Icon(
              Icons.admin_panel_settings_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.watch<LanguageProvider>().t("agriConnectAdmin"),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "admin@agriconnect.com",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  context.watch<LanguageProvider>().t("systemAdministrator"),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 450.ms).slideY(begin: -0.12, end: 0);
  }
}
