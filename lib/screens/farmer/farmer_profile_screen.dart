import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/farmer_bottom_navbar.dart';
import '../../widgets/profile/profile_header_card.dart';
import '../../widgets/profile/profile_info_tile.dart';
import '../../widgets/profile/profile_section_title.dart';
import '../../widgets/profile/profile_settings_card.dart';
import '../../providers/theme_provider.dart';

class FarmerProfileScreen extends StatelessWidget {
  const FarmerProfileScreen({super.key});

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: const FarmerBottomNavbar(currentIndex: 4),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileHeaderCard(authProvider: authProvider),
                    const SizedBox(height: 34),
                    ProfileSectionTitle(title: lang.t("accountInformation")),
                    const SizedBox(height: 14),
                    ProfileSettingsCard(
                      children: [
                        ProfileInfoTile(
                          icon: Icons.email_outlined,
                          title: lang.t("emailAddress"),
                          value: authProvider.email.isEmpty
                              ? lang.t("noEmailFound")
                              : authProvider.email,
                        ),
                        _divider(),
                        ProfileInfoTile(
                          icon: Icons.phone_outlined,
                          title: lang.t("phoneNumber"),
                          value: authProvider.phone.isEmpty
                              ? lang.t("noPhoneFound")
                              : authProvider.phone,
                        ),
                        _divider(),
                        ProfileInfoTile(
                          icon: Icons.location_on_outlined,
                          title: lang.t("farmLocation"),
                          value: authProvider.location,
                        ),
                        _divider(),
                        ProfileInfoTile(
                          icon: Icons.language_outlined,
                          title: lang.t("language"),
                          value: lang.isUrdu ? "اردو" : "English",
                          subtitle: lang.t("chooseLanguage"),
                          showArrow: true,
                          onTap: () {
                            _showLanguageDialog(context);
                          },
                        ),
                        _divider(),
                        ProfileInfoTile(
                          icon: Icons.lock_reset,
                          title: lang.t("changePassword"),
                          value: "",
                          subtitle: lang.t("updateAccountPassword"),
                          showArrow: true,
                          onTap: () {
                            _showChangePasswordDialog(context, authProvider);
                          },
                        ),

                        _divider(),
                        Consumer<ThemeProvider>(
                          builder: (context, themeProvider, child) {
                            return ProfileInfoTile(
                              icon: themeProvider.isDarkMode
                                  ? Icons.dark_mode_outlined
                                  : Icons.light_mode_outlined,
                              title: lang.t("appearance"),
                              value: themeProvider.isDarkMode
                                  ? lang.t("darkMode")
                                  : lang.t("lightMode"),
                              subtitle: lang.t("switchTheme"),
                              showArrow: true,
                              onTap: () {
                                themeProvider.toggleTheme();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 55),
                    _logoutButton(context, authProvider),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xffd8e6de))),
      ),
      child: Row(
        children: [
          const Icon(Icons.agriculture_outlined, color: darkGreen, size: 26),
          const SizedBox(width: 12),
          Text(
            lang.t("appName"),
            style: const TextStyle(
              color: darkGreen,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.notifications_none,
            color: Color(0xff333333),
            size: 27,
          ),
        ],
      ),
    );
  }

  Widget _logoutButton(BuildContext context, AuthProvider authProvider) {
    final lang = context.watch<LanguageProvider>();

    return Center(
      child: TextButton.icon(
        onPressed: () {
          authProvider.logout();
          Navigator.pushReplacementNamed(context, '/login');
        },
        icon: const Icon(Icons.logout, color: Colors.red),
        label: Text(
          lang.t("logout"),
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(
    BuildContext context,
    AuthProvider authProvider,
  ) {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();
    final lang = context.read<LanguageProvider>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          scrollable: true,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            lang.t("changePassword"),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: darkGreen,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: lang.t("currentPassword"),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: lang.t("newPassword"),
                  prefixIcon: const Icon(Icons.lock_reset),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: lang.t("confirmPassword"),
                  prefixIcon: const Icon(Icons.verified_outlined),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(lang.t("cancel")),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (newController.text.trim().isEmpty ||
                    confirmController.text.trim().isEmpty) {
                  _showSnackBar(context, lang.t("pleaseEnterNewPassword"));
                  return;
                }

                if (newController.text.trim() !=
                    confirmController.text.trim()) {
                  _showSnackBar(context, lang.t("passwordsDoNotMatch"));
                  return;
                }

                final success = authProvider.changePassword(
                  currentPassword: currentController.text.trim(),
                  newPassword: newController.text.trim(),
                );

                if (!success) {
                  _showSnackBar(context, lang.t("currentPasswordIncorrect"));
                  return;
                }

                Navigator.pop(dialogContext);
                _showSnackBar(context, lang.t("passwordUpdatedSuccessfully"));
              },
              child: Text(lang.t("update")),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
  void _showLanguageDialog(BuildContext context) {
    final languageProvider = context.read<LanguageProvider>();
    final lang = context.read<LanguageProvider>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            lang.t("chooseLanguage"),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: darkGreen,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text("English"),
                onTap: () async {
                  await languageProvider.changeLanguage('en');
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text("اردو"),
                onTap: () async {
                  await languageProvider.changeLanguage('ur');
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _divider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey.shade300);
  }
}
