import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/farmer_bottom_navbar.dart';
import '../../widgets/profile/farmer_profile_header.dart';
import '../../widgets/profile/personal_information_card.dart';
import '../../widgets/profile/profile_action_card.dart';
import '../../widgets/profile/profile_logout_button.dart';
import 'edit_profile_screen.dart';

class FarmerProfileScreen extends StatelessWidget {
  const FarmerProfileScreen({super.key});

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xfff9fbfa),
      bottomNavigationBar: const FarmerBottomNavbar(currentIndex: 4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FarmerProfileHeader(authProvider: authProvider),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 28),
                child: Column(
                  children: [
                    PersonalInformationCard(authProvider: authProvider),
                    const SizedBox(height: 24),
                    ProfileActionCard(
                      language: languageProvider.isUrdu ? "Urdu" : "English",
                      isDarkMode: themeProvider.isDarkMode,
                      onEditProfile: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        );
                      },
                      onLanguage: () {
                        _showLanguageSheet(context, languageProvider);
                      },
                      onNotifications: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.read<LanguageProvider>().t(
                                "notificationsComingSoon",
                              ),
                            ),
                          ),
                        );
                      },
                      onChangePassword: () {
                        _showChangePasswordDialog(context, authProvider);
                      },
                      onAppearance: () async {
                        await themeProvider.toggleTheme();
                      },
                      onHelpSupport: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.read<LanguageProvider>().t(
                                "helpSupportComingSoon",
                              ),
                            ),
                          ),
                        );
                      },
                      onAboutApp: () {
                        _showAboutAppDialog(context);
                      },
                    ),
                    const SizedBox(height: 28),
                    ProfileLogoutButton(
                      onTap: () {
                        authProvider.logout();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageSheet(
    BuildContext context,
    LanguageProvider languageProvider,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              22,
              20,
              22,
              28 + MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.watch<LanguageProvider>().t("selectLanguage"),
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 18),
                _languageTile(
                  context,
                  languageProvider,
                  languageName: "English",
                  languageCode: "en",
                ),
                _languageTile(
                  context,
                  languageProvider,
                  languageName: "Urdu",
                  languageCode: "ur",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _languageTile(
    BuildContext context,
    LanguageProvider languageProvider, {
    required String languageName,
    required String languageCode,
  }) {
    final isSelected = languageProvider.locale.languageCode == languageCode;

    return ListTile(
      onTap: () async {
        await languageProvider.changeLanguage(languageCode);
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context
                  .read<LanguageProvider>()
                  .t("languageChanged")
                  .replaceAll('{value}', languageName),
            ),
          ),
        );
      },
      leading: Icon(
        Icons.language,
        color: isSelected ? darkGreen : Colors.grey,
      ),
      title: Text(
        languageName,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
          color: isSelected ? darkGreen : const Color(0xff202525),
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: darkGreen)
          : null,
    );
  }

  void _showAboutAppDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: "AgriConnect",
      applicationVersion: "1.0.0",
      applicationIcon: const Icon(
        Icons.agriculture,
        color: darkGreen,
        size: 35,
      ),
      children: [
        Text(context.watch<LanguageProvider>().t("farmerAppDescription")),
      ],
    );
  }

  void _showChangePasswordDialog(
    BuildContext context,
    AuthProvider authProvider,
  ) {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          scrollable: true,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            context.read<LanguageProvider>().t("changePassword"),
            style: TextStyle(fontWeight: FontWeight.w900, color: darkGreen),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: context.read<LanguageProvider>().t(
                    "currentPassword",
                  ),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: context.read<LanguageProvider>().t("newPassword"),
                  prefixIcon: Icon(Icons.lock_reset),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: context.read<LanguageProvider>().t(
                    "confirmPassword",
                  ),
                  prefixIcon: Icon(Icons.verified_outlined),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(context.read<LanguageProvider>().t("cancel")),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (newController.text.trim().isEmpty ||
                    confirmController.text.trim().isEmpty) {
                  _showSnackBar(
                    context,
                    context.read<LanguageProvider>().t(
                      "pleaseEnterNewPassword",
                    ),
                  );
                  return;
                }

                if (newController.text.trim() !=
                    confirmController.text.trim()) {
                  _showSnackBar(
                    context,
                    context.read<LanguageProvider>().t("passwordsDoNotMatch"),
                  );
                  return;
                }

                final success = authProvider.changePassword(
                  currentPassword: currentController.text.trim(),
                  newPassword: newController.text.trim(),
                );

                if (!success) {
                  _showSnackBar(
                    context,
                    context.read<LanguageProvider>().t(
                      "currentPasswordIncorrect",
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext);
                _showSnackBar(
                  context,
                  context.read<LanguageProvider>().t(
                    "passwordUpdatedSuccessfully",
                  ),
                );
              },
              child: Text(context.read<LanguageProvider>().t("update")),
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
}
