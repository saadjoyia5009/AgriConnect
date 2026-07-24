import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_buyer_profile_screen.dart';
import '../../providers/buyer_profile_provider.dart';
import '../../providers/buyer_language_provider.dart';
import '../../widgets/buyer/buyer_bottom_navbar.dart';
import '../../providers/theme_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/buyer/profile/buyer_profile_header.dart';
import '../../widgets/buyer/profile/buyer_profile_stats.dart';
import 'buyer_notification_screen.dart';
import '../../widgets/buyer/profile/buyer_profile_menu_tile.dart';
import '../../widgets/buyer/buyer_app_bar.dart';

class BuyerProfileScreen extends StatefulWidget {
  const BuyerProfileScreen({super.key});

  @override
  State<BuyerProfileScreen> createState() => _BuyerProfileScreenState();
}

class _BuyerProfileScreenState extends State<BuyerProfileScreen> {
  static const Color darkGreen = Color(0xff0F5C3A);
  static const Color lightBackground = Color(0xffF8FAF7);
  static const Color darkBackground = Color(0xFF0B1410);
  static const Color lightGreen = Color(0xff9ff2c1);

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get accentColor => isDark ? lightGreen : darkGreen;
  Color get iconColor => isDark ? Colors.white70 : const Color(0xff26342D);
  Color get primaryText => isDark ? Colors.white : const Color(0xff10291D);
  Color get errorColor => isDark ? Colors.red.shade200 : Colors.red;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<BuyerProfileProvider>().fetchProfile();
    });
  }

  void _onNavTap(int index) {
    if (index == 1) return;

    final routes = <int, String>{
      0: '/buyerDashboard',
      1: '/buyerFavorites',
      2: '/buyerChats',
      3: '/buyer-inquiries',
      4: '/buyerProfile',
    };

    final route = routes[index];

    if (route != null) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  Future<void> _openEditProfile(profile) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditBuyerProfileScreen(profile: profile),
      ),
    );

    if (!mounted) return;

    setState(() {});
  }

  void _openThemeSheet() {
    final themeProvider = context.read<ThemeProvider>();
    final lang = context.read<LanguageProvider>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF15251E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20,
              18,
              20,
              24 + MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  lang.t("chooseTheme"),
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),

                ListTile(
                  leading: Icon(Icons.light_mode_outlined, color: accentColor),
                  title: Text(
                    lang.t("lightMode"),
                    style: TextStyle(color: primaryText),
                  ),
                  onTap: () {
                    themeProvider.setLightMode();
                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading: Icon(Icons.dark_mode_outlined, color: accentColor),
                  title: Text(
                    lang.t("darkMode"),
                    style: TextStyle(color: primaryText),
                  ),
                  onTap: () {
                    themeProvider.setDarkMode();
                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading: Icon(Icons.phone_iphone, color: accentColor),
                  title: Text(
                    lang.t("systemDefault"),
                    style: TextStyle(color: primaryText),
                  ),
                  onTap: () {
                    themeProvider.setSystemMode();
                    Navigator.pop(context);
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
    final buyerLanguage = context.read<BuyerLanguageProvider>();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF15251E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return ChangeNotifierProvider<BuyerLanguageProvider>.value(
          value: buyerLanguage,
          child: Consumer<BuyerLanguageProvider>(
            builder: (context, language, _) {
              return Directionality(
                textDirection: language.locale.languageCode == 'ur'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      18,
                      20,
                      24 + MediaQuery.viewInsetsOf(context).bottom,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          language.t('chooseLanguage'),
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
                          code: 'en',
                          label: language.t('languageEnglish'),
                        ),
                        _languageOption(
                          sheetContext,
                          language: language,
                          code: 'ur',
                          label: language.t('languageUrdu'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _openHelpDialog() {
    final language = context.read<BuyerLanguageProvider>();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => ChangeNotifierProvider.value(
        value: language,
        child: Consumer<BuyerLanguageProvider>(
          builder: (context, currentLanguage, _) => AlertDialog(
            scrollable: true,
            title: Text(currentLanguage.t('helpSupport')),
            content: Text(currentLanguage.t('aboutAgriConnectDescription')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(currentLanguage.t('okay')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languageOption(
    BuildContext sheetContext, {
    required BuyerLanguageProvider language,
    required String code,
    required String label,
  }) {
    final selected = language.locale.languageCode == code;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(Icons.translate_rounded, color: accentColor),
      title: Text(
        label,
        style: TextStyle(color: primaryText, fontWeight: FontWeight.w700),
      ),
      trailing: selected
          ? Icon(Icons.check_circle_rounded, color: accentColor)
          : Icon(Icons.circle_outlined, color: iconColor),
      onTap: () async {
        await language.changeLanguage(code);
        if (sheetContext.mounted) Navigator.pop(sheetContext);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<BuyerLanguageProvider>();

    return Scaffold(
      backgroundColor: isDark ? darkBackground : lightBackground,
      appBar: BuyerAppBar(title: language.t("profile")),
      bottomNavigationBar: BuyerBottomNavBar(currentIndex: 4, onTap: _onNavTap),
      body: SafeArea(
        child: Consumer<BuyerProfileProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return Center(
                child: CircularProgressIndicator(color: accentColor),
              );
            }

            if (provider.errorMessage != null) {
              return Center(
                child: Text(
                  provider.errorMessage!,
                  style: TextStyle(
                    color: errorColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }

            final profile = provider.profile;

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

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
              child: Column(
                children: [
                  BuyerProfileHeader(profile: profile),
                  const SizedBox(height: 24),
                  BuyerProfileStats(profile: profile),
                  const SizedBox(height: 24),
                  BuyerProfileMenuTile(
                    icon: Icons.edit_outlined,
                    title: language.t("editProfile"),
                    onTap: () => _openEditProfile(profile),
                  ),
                  BuyerProfileMenuTile(
                    icon: isDark
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    title: language.t('settings'),
                    subtitle: isDark
                        ? language.t("darkMode")
                        : language.t("lightMode"),
                    onTap: _openThemeSheet,
                  ),
                  BuyerProfileMenuTile(
                    icon: Icons.language_rounded,
                    title: language.t('language'),
                    subtitle: language.isUrdu
                        ? language.t('languageUrdu')
                        : language.t('languageEnglish'),
                    onTap: _openLanguageSheet,
                  ),
                  BuyerProfileMenuTile(
                    icon: Icons.chat_bubble_outline,
                    title: language.t("myInquiries"),
                    onTap: () =>
                        Navigator.pushNamed(context, '/buyer-inquiries'),
                  ),
                  BuyerProfileMenuTile(
                    icon: Icons.favorite_border,
                    title: language.t("favoriteCrops"),
                    onTap: () =>
                        Navigator.pushNamed(context, '/buyerFavorites'),
                  ),
                  BuyerProfileMenuTile(
                    icon: Icons.notifications_none,
                    title: language.t("notifications"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BuyerNotificationScreen(),
                        ),
                      );
                    },
                  ),
                  BuyerProfileMenuTile(
                    icon: Icons.help_outline_rounded,
                    title: language.t('helpSupport'),
                    onTap: _openHelpDialog,
                  ),
                  BuyerProfileMenuTile(
                    icon: Icons.logout,
                    title: language.t("logout"),
                    iconColor: Colors.red,
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
