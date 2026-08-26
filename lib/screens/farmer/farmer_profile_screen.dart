import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/farmer_bottom_navbar.dart';
import '../../widgets/profile/farmer_profile_header.dart';
import '../../widgets/profile/personal_information_card.dart';
import '../../widgets/profile/profile_action_card.dart';
import '../../widgets/profile/profile_logout_button.dart';
import 'edit_profile_screen.dart';

class FarmerProfileScreen extends StatefulWidget {
  const FarmerProfileScreen({super.key});

  @override
  State<FarmerProfileScreen> createState() {
    return _FarmerProfileScreenState();
  }
}

class _FarmerProfileScreenState
    extends State<FarmerProfileScreen> {
  static const Color darkGreen = Color(0xff075739);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<ProfileProvider>().fetchProfile();
    });
  }

  Future<void> _refreshProfile() async {
    await context.read<ProfileProvider>().fetchProfile();
  }

  Future<void> _openEditProfile() async {
    final profileProvider =
    context.read<ProfileProvider>();

    if (profileProvider.profile == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EditProfileScreen(),
      ),
    );

    if (!mounted) return;

    await profileProvider.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider =
    context.watch<ThemeProvider>();

    final languageProvider =
    context.watch<LanguageProvider>();

    final profileProvider =
    context.watch<ProfileProvider>();

    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? Theme.of(context).scaffoldBackgroundColor
          : const Color(0xfff9fbfa),
      bottomNavigationBar:
      const FarmerBottomNavbar(currentIndex: 4),
      body: SafeArea(
        top: false,
        child: _buildContent(
          context,
          profileProvider,
          themeProvider,
          languageProvider,
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      ProfileProvider profileProvider,
      ThemeProvider themeProvider,
      LanguageProvider languageProvider,
      ) {
    if (
    profileProvider.isLoading &&
        profileProvider.profile == null
    ) {
      return const Center(
        child: CircularProgressIndicator(
          color: darkGreen,
        ),
      );
    }

    if (
    profileProvider.errorMessage != null &&
        profileProvider.profile == null
    ) {
      return _errorView(
        profileProvider,
        languageProvider,
      );
    }

    final profile = profileProvider.profile;

    if (profile == null) {
      return _errorView(
        profileProvider,
        languageProvider,
      );
    }

    return RefreshIndicator(
      color: darkGreen,
      onRefresh: _refreshProfile,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            FarmerProfileHeader(
              profile: profile,
              onCameraTap: _openEditProfile,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                18,
                22,
                18,
                28,
              ),
              child: Column(
                children: [
                  PersonalInformationCard(
                    profile: profile,
                  ),
                  const SizedBox(height: 24),
                  ProfileActionCard(
                    language: languageProvider.isUrdu
                        ? languageProvider.t("urdu")
                        : languageProvider.t("english"),
                    isDarkMode:
                    themeProvider.isDarkMode,
                    onEditProfile: _openEditProfile,
                    onLanguage: () {
                      _showLanguageSheet(
                        context,
                        languageProvider,
                      );
                    },
                    onNotifications: () {
                      Navigator.pushNamed(
                        context,
                        "/notifications",
                      );
                    },
                    onChangePassword: () {
                      _showChangePasswordDialog(
                        context,
                        context.read<AuthProvider>(),
                      );
                    },
                    onAppearance: () async {
                      await themeProvider.toggleTheme();
                    },
                    onHelpSupport: () {
                      Navigator.pushNamed(
                        context,
                        "/customerSupport",
                      );
                    },
                    onAboutApp: () {
                      _showAboutAppDialog(context);
                    },
                  ),
                  const SizedBox(height: 28),
                  ProfileLogoutButton(
                    onTap: _logout,
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorView(
      ProfileProvider profileProvider,
      LanguageProvider languageProvider,
      ) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return RefreshIndicator(
      color: darkGreen,
      onRefresh: _refreshProfile,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          SizedBox(
            height:
            MediaQuery.sizeOf(context).height * 0.22,
          ),
          Icon(
            Icons.person_off_outlined,
            color: isDark
                ? Colors.red.shade200
                : Colors.red,
            size: 65,
          ),
          const SizedBox(height: 18),
          Text(
            profileProvider.errorMessage ??
                languageProvider.t("somethingWentWrong"),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.color,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: profileProvider.fetchProfile,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final authProvider =
    context.read<AuthProvider>();

    final profileProvider =
    context.read<ProfileProvider>();

    await authProvider.logout();
    profileProvider.clearProfile();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      "/login",
          (route) => false,
    );
  }

  void _showLanguageSheet(
      BuildContext context,
      LanguageProvider languageProvider,
      ) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark
          ? Theme.of(context).cardColor
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            22,
            20,
            22,
            28,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                languageProvider.t("selectLanguage"),
                style: TextStyle(
                  color: isDark
                      ? Colors.white
                      : darkGreen,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 18),
              _languageTile(
                sheetContext,
                languageProvider,
                languageName: languageProvider.t("english"),
                languageCode: "en",
              ),
              _languageTile(
                sheetContext,
                languageProvider,
                languageName: languageProvider.t("urdu"),
                languageCode: "ur",
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _languageTile(
      BuildContext sheetContext,
      LanguageProvider languageProvider, {
        required String languageName,
        required String languageCode,
      }) {
    final isSelected =
        languageProvider.locale.languageCode ==
            languageCode;

    return ListTile(
      tileColor: isSelected
          ? (Theme.of(sheetContext).brightness == Brightness.dark
          ? darkGreen.withValues(alpha: 0.14)
          : const Color(0xffeef8f2))
          : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onTap: () async {
        await languageProvider.changeLanguage(
          languageCode,
        );

        if (!sheetContext.mounted) return;

        Navigator.pop(sheetContext);

        if (!mounted) return;

        _showSnackBar(
          context,
          languageProvider
              .t("languageChanged")
              .replaceAll(
            "{value}",
            languageName,
          ),
        );
      },
      leading: Icon(
        Icons.language,
        color: isSelected
            ? darkGreen
            : Colors.grey,
      ),
      title: Text(
        languageName,
        style: TextStyle(
          fontWeight: isSelected
              ? FontWeight.w900
              : FontWeight.w600,
          color: isSelected
              ? darkGreen
              : Theme.of(sheetContext)
              .textTheme
              .bodyLarge
              ?.color,
        ),
      ),
      trailing: isSelected
          ? const Icon(
        Icons.check_circle,
        color: darkGreen,
      )
          : null,
    );
  }

  void _showAboutAppDialog(
      BuildContext context,
      ) {
    final languageProvider =
    context.read<LanguageProvider>();

    showAboutDialog(
      context: context,
      applicationName: "AgriConnect",
      applicationVersion: "1.0.0",
      applicationIcon: Icon(
        Icons.agriculture,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : darkGreen,
        size: 35,
      ),
      children: [
        Text(
          languageProvider.t(
            "farmerAppDescription",
          ),
        ),
      ],
    );
  }

  void _showChangePasswordDialog(
      BuildContext context,
      AuthProvider authProvider,
      ) {
    final currentController =
    TextEditingController();

    final newController =
    TextEditingController();

    final confirmController =
    TextEditingController();

    final languageProvider =
    context.read<LanguageProvider>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          scrollable: true,
          insetPadding:
          const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          title: Text(
            languageProvider.t("changePassword"),
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Theme.of(dialogContext).brightness == Brightness.dark
                  ? Colors.white
                  : darkGreen,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: languageProvider.t(
                    "currentPassword",
                  ),
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Theme.of(dialogContext).brightness == Brightness.dark
                        ? Colors.white70
                        : darkGreen,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: languageProvider.t(
                    "newPassword",
                  ),
                  prefixIcon: Icon(
                    Icons.lock_reset,
                    color: Theme.of(dialogContext).brightness == Brightness.dark
                        ? Colors.white70
                        : darkGreen,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: languageProvider.t(
                    "confirmPassword",
                  ),
                  prefixIcon: Icon(
                    Icons.verified_outlined,
                    color: Theme.of(dialogContext).brightness == Brightness.dark
                        ? Colors.white70
                        : darkGreen,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                languageProvider.t("cancel"),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final currentPassword =
                currentController.text.trim();

                final newPassword =
                newController.text.trim();

                final confirmPassword =
                confirmController.text.trim();

                if (
                currentPassword.isEmpty ||
                    newPassword.isEmpty ||
                    confirmPassword.isEmpty
                ) {
                  _showSnackBar(
                    context,
                    languageProvider.t(
                      "pleaseEnterNewPassword",
                    ),
                  );
                  return;
                }

                if (
                newPassword != confirmPassword
                ) {
                  _showSnackBar(
                    context,
                    languageProvider.t(
                      "passwordsDoNotMatch",
                    ),
                  );
                  return;
                }

                final success =
                authProvider.changePassword(
                  currentPassword:
                  currentPassword,
                  newPassword: newPassword,
                );

                if (!success) {
                  _showSnackBar(
                    context,
                    languageProvider.t(
                      "currentPasswordIncorrect",
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext);

                _showSnackBar(
                  context,
                  languageProvider.t(
                    "passwordUpdatedSuccessfully",
                  ),
                );
              },
              child: Text(
                languageProvider.t("update"),
              ),
            ),
          ],
        );
      },
    ).whenComplete(() {
      currentController.dispose();
      newController.dispose();
      confirmController.dispose();
    });
  }

  void _showSnackBar(
      BuildContext context,
      String message,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
        Theme.of(context).brightness == Brightness.dark
            ? const Color(0xff17432f)
            : darkGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}