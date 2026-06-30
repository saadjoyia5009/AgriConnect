import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
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
        title: const Text(
          "Admin Profile",
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
            title: "Admin Role",
            subtitle: "View admin permissions and access",
            color: isDark ? lightGreen : darkGreen,
            onTap: () {
              _showInfoDialog(
                context,
                "Admin Role",
                "Admin can manage users, crop listings, reports, analytics, and overall AgriConnect platform activity.",
              );
            },
          ),

          AdminProfileOptionTile(
            icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            title: "App Theme",
            subtitle: isDark ? "Dark mode enabled" : "Light mode enabled",
            color: isDark ? lightGreen : darkGreen,
            onTap: () {
              _showThemeSheet(context, themeProvider);
            },
          ),

          AdminProfileOptionTile(
            icon: Icons.security_rounded,
            title: "Security",
            subtitle: "Update or recover admin password",
            color: Colors.blue,
            onTap: () {
              Navigator.pushNamed(context, '/forgotPassword');
            },
          ),

          AdminProfileOptionTile(
            icon: Icons.notifications_active_rounded,
            title: "Notifications",
            subtitle: "View system alerts and updates",
            color: Colors.orange,
            onTap: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),

          AdminProfileOptionTile(
            icon: Icons.info_rounded,
            title: "About AgriConnect",
            subtitle: "View project and system information",
            color: Colors.purple,
            onTap: () {
              _showInfoDialog(
                context,
                "About AgriConnect",
                "AgriConnect is an AI-powered farmer marketplace that connects farmers directly with buyers and supports crop price prediction, disease detection, notifications, and admin monitoring.",
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
              label: const Text(
                "Logout",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
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

  void _showThemeSheet(
      BuildContext context,
      ThemeProvider themeProvider,
      ) {
    final isDark = _isDark(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? darkCard : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Choose Theme",
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
                title: "Light Mode",
                selected: themeProvider.themeMode == ThemeMode.light,
                onTap: () async {
                  await themeProvider.setLightMode();
                  if (context.mounted) Navigator.pop(context);
                },
              ),

              _themeOption(
                context: context,
                icon: Icons.dark_mode_rounded,
                title: "Dark Mode",
                selected: themeProvider.themeMode == ThemeMode.dark,
                onTap: () async {
                  await themeProvider.setDarkMode();
                  if (context.mounted) Navigator.pop(context);
                },
              ),

              _themeOption(
                context: context,
                icon: Icons.phone_iphone_rounded,
                title: "System Default",
                selected: themeProvider.themeMode == ThemeMode.system,
                onTap: () async {
                  await themeProvider.setSystemMode();
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ],
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
          ? Icon(
        Icons.check_circle,
        color: isDark ? lightGreen : darkGreen,
      )
          : null,
    );
  }

  void _showInfoDialog(
      BuildContext context,
      String title,
      String message,
      ) {
    final isDark = _isDark(context);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
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
                "Okay",
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
              ? const [
            Color(0xFF123524),
            Color(0xFF0E5A3C),
          ]
              : const [
            Color(0xFF0E5A3C),
            Color(0xFF157A52),
          ],
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "AgriConnect Admin",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "admin@agriconnect.com",
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "System Administrator",
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