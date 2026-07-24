import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/buyer_language_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/buyer/buyer_bottom_navbar.dart';
import '../../widgets/buyer/profile/buyer_profile_header.dart';
import '../../widgets/buyer/profile/buyer_profile_menu_tile.dart';
import 'buyer_notification_screen.dart';
import 'edit_buyer_profile_screen.dart';

class BuyerProfileScreen extends StatefulWidget {
  const BuyerProfileScreen({super.key});

  @override
  State<BuyerProfileScreen> createState() {
    return _BuyerProfileScreenState();
  }
}

class _BuyerProfileScreenState extends State<BuyerProfileScreen> {
  static const Color darkGreen = Color(0xff0F5C3A);
  static const Color lightBackground = Color(0xffF8FAF7);
  static const Color darkBackground = Color(0xFF0B1410);
  static const Color lightGreen = Color(0xff9ff2c1);

  bool get isDark {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color get accentColor {
    return isDark ? lightGreen : darkGreen;
  }

  Color get iconColor {
    return isDark
        ? Colors.white70
        : const Color(0xff26342D);
  }

  Color get primaryText {
    return isDark
        ? Colors.white
        : const Color(0xff10291D);
  }

  Color get errorColor {
    return isDark
        ? Colors.red.shade200
        : Colors.red;
  }

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

  void _onNavTap(int index) {
    if (index == 4) return;

    final Map<int, String> routes = {
      0: "/buyerDashboard",
      1: "/buyerFavorites",
      2: "/buyerChats",
      3: "/buyer-inquiries",
      4: "/buyerProfile",
    };

    final String? route = routes[index];

    if (route == null) return;

    Navigator.pushReplacementNamed(
      context,
      route,
    );
  }

  Future<void> _openEditProfile() async {
    final profileProvider =
    context.read<ProfileProvider>();

    final profile = profileProvider.profile;

    if (profile == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditBuyerProfileScreen(
          profile: profile,
        ),
      ),
    );

    if (!mounted) return;

    await profileProvider.fetchProfile();
  }

  void _openThemeSheet() {
    final ThemeProvider themeProvider =
    context.read<ThemeProvider>();

    final BuyerLanguageProvider language =
    context.read<BuyerLanguageProvider>();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark
          ? const Color(0xFF15251E)
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  language.t("chooseTheme"),
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                ListTile(
                  leading: Icon(
                    Icons.light_mode_outlined,
                    color: accentColor,
                  ),
                  title: Text(
                    language.t("lightMode"),
                    style: TextStyle(
                      color: primaryText,
                    ),
                  ),
                  onTap: () {
                    themeProvider.setLightMode();
                    Navigator.pop(sheetContext);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.dark_mode_outlined,
                    color: accentColor,
                  ),
                  title: Text(
                    language.t("darkMode"),
                    style: TextStyle(
                      color: primaryText,
                    ),
                  ),
                  onTap: () {
                    themeProvider.setDarkMode();
                    Navigator.pop(sheetContext);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.phone_iphone,
                    color: accentColor,
                  ),
                  title: Text(
                    language.t("systemDefault"),
                    style: TextStyle(
                      color: primaryText,
                    ),
                  ),
                  onTap: () {
                    themeProvider.setSystemMode();
                    Navigator.pop(sheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openLanguageSheet() {
    final BuyerLanguageProvider buyerLanguage =
    context.read<BuyerLanguageProvider>();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark
          ? const Color(0xFF15251E)
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return ChangeNotifierProvider<
            BuyerLanguageProvider>.value(
          value: buyerLanguage,
          child: Consumer<BuyerLanguageProvider>(
            builder: (
                context,
                language,
                child,
                ) {
              return SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    18,
                    20,
                    28,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        language.t("chooseLanguage"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _languageOption(
                        sheetContext,
                        language: language,
                        code: "en",
                        label: language.t(
                          "languageEnglish",
                        ),
                      ),
                      _languageOption(
                        sheetContext,
                        language: language,
                        code: "ur",
                        label: language.t(
                          "languageUrdu",
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _languageOption(
      BuildContext sheetContext, {
        required BuyerLanguageProvider language,
        required String code,
        required String label,
      }) {
    final bool selected =
        language.locale.languageCode == code;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      leading: Icon(
        Icons.translate_rounded,
        color: accentColor,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: primaryText,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: selected
          ? Icon(
        Icons.check_circle_rounded,
        color: accentColor,
      )
          : Icon(
        Icons.circle_outlined,
        color: iconColor,
      ),
      onTap: () async {
        await language.changeLanguage(code);

        if (!sheetContext.mounted) return;

        Navigator.pop(sheetContext);
      },
    );
  }

  void _openHelpDialog() {
    final BuyerLanguageProvider language =
    context.read<BuyerLanguageProvider>();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          scrollable: true,
          title: Text(
            language.t("helpSupport"),
          ),
          content: Text(
            language.t(
              "aboutAgriConnectDescription",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                language.t("okay"),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    final AuthProvider authProvider =
    context.read<AuthProvider>();

    final ProfileProvider profileProvider =
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

  @override
  Widget build(BuildContext context) {
    final BuyerLanguageProvider language =
    context.watch<BuyerLanguageProvider>();

    final ProfileProvider profileProvider =
    context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: isDark
          ? darkBackground
          : lightBackground,
      bottomNavigationBar: BuyerBottomNavBar(
        currentIndex: 4,
        onTap: _onNavTap,
      ),
      body: SafeArea(
        child: _buildContent(
          language,
          profileProvider,
        ),
      ),
    );
  }

  Widget _buildContent(
      BuyerLanguageProvider language,
      ProfileProvider profileProvider,
      ) {
    if (profileProvider.isLoading &&
        profileProvider.profile == null) {
      return Center(
        child: CircularProgressIndicator(
          color: accentColor,
        ),
      );
    }

    if (profileProvider.errorMessage != null &&
        profileProvider.profile == null) {
      return RefreshIndicator(
        color: accentColor,
        onRefresh: _refreshProfile,
        child: ListView(
          physics:
          const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 120),
            Icon(
              Icons.person_off_outlined,
              size: 64,
              color: errorColor,
            ),
            const SizedBox(height: 18),
            Text(
              profileProvider.errorMessage ??
                  "Unable to load profile.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryText,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed:
                profileProvider.fetchProfile,
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

    final profile = profileProvider.profile;

    if (profile == null) {
      return Center(
        child: Text(
          language.t("noProfileFound"),
          style: TextStyle(
            color: primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: accentColor,
      onRefresh: _refreshProfile,
      child: SingleChildScrollView(
        physics:
        const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          18,
          18,
          18,
          24,
        ),
        child: Column(
          children: [
            _topBar(language),
            const SizedBox(height: 24),
            BuyerProfileHeader(
              profile: profile,
              onCameraTap: _openEditProfile,
            ),
            const SizedBox(height: 28),
            _personalInformationCard(profile),
            const SizedBox(height: 24),
            BuyerProfileMenuTile(
              icon: Icons.edit_outlined,
              title: language.t("editProfile"),
              onTap: _openEditProfile,
            ),
            BuyerProfileMenuTile(
              icon: isDark
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              title: language.t("settings"),
              subtitle: isDark
                  ? language.t("darkMode")
                  : language.t("lightMode"),
              onTap: _openThemeSheet,
            ),
            BuyerProfileMenuTile(
              icon: Icons.language_rounded,
              title: language.t("language"),
              subtitle: language.isUrdu
                  ? language.t("languageUrdu")
                  : language.t("languageEnglish"),
              onTap: _openLanguageSheet,
            ),
            BuyerProfileMenuTile(
              icon: Icons.chat_bubble_outline,
              title: language.t("myInquiries"),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  "/buyer-inquiries",
                );
              },
            ),
            BuyerProfileMenuTile(
              icon: Icons.favorite_border,
              title: language.t("favoriteCrops"),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  "/buyerFavorites",
                );
              },
            ),
            BuyerProfileMenuTile(
              icon: Icons.notifications_none,
              title: language.t("notifications"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return const BuyerNotificationScreen();
                    },
                  ),
                );
              },
            ),
            BuyerProfileMenuTile(
              icon: Icons.help_outline_rounded,
              title: language.t("helpSupport"),
              onTap: _openHelpDialog,
            ),
            BuyerProfileMenuTile(
              icon: Icons.logout,
              title: language.t("logout"),
              iconColor: Colors.red,
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _personalInformationCard(dynamic profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF15251E)
            : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white12
              : const Color(0xffDCE7DD),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Personal Information",
            style: TextStyle(
              color: accentColor,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),
          _informationRow(
            icon: Icons.email_outlined,
            title: "Email Address",
            value: profile.email,
          ),
          const Divider(height: 28),
          _informationRow(
            icon: Icons.phone_outlined,
            title: "Phone Number",
            value: profile.displayPhone,
          ),
          const Divider(height: 28),
          _informationRow(
            icon: Icons.location_on_outlined,
            title: "Location",
            value: profile.displayAddress,
          ),
        ],
      ),
    );
  }

  Widget _informationRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white10
                : const Color(0xffEAF7F0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: accentColor,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: iconColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value.trim().isEmpty
                    ? "Not available"
                    : value,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _topBar(
      BuyerLanguageProvider language,
      ) {
    return Row(
      children: [
        const Spacer(),
        Text(
          language.t("profile"),
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.w900,
            fontSize: 21,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}