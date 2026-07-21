import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_buyer_profile_screen.dart';
import '../../providers/buyer_profile_provider.dart';
import '../../widgets/buyer/buyer_bottom_navbar.dart';
import '../../providers/theme_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/buyer/profile/buyer_profile_header.dart';
import '../../widgets/buyer/profile/buyer_profile_stats.dart';
import 'buyer_notification_screen.dart';
import '../../widgets/buyer/profile/buyer_profile_menu_tile.dart';

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
      backgroundColor: isDark ? const Color(0xFF15251E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? darkBackground : lightBackground,
      bottomNavigationBar: BuyerBottomNavBar(
        currentIndex: 4,
        onTap: _onNavTap,
      ),
      body: SafeArea(
        child: Consumer<BuyerProfileProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator(color: accentColor));
            }

            if (provider.errorMessage != null) {
              return Center(
                child: Text(
                  provider.errorMessage!,
                  style: TextStyle(color: errorColor, fontWeight: FontWeight.w600),
                ),
              );
            }

            final profile = provider.profile;

            if (profile == null) {
              return Center(
                child: Text(
                  context.watch<LanguageProvider>().t("noProfileFound"),
                  style: TextStyle(color: primaryText, fontWeight: FontWeight.w600),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
              child: Column(
                children: [
                  _topBar(),
                  const SizedBox(height: 24),
                  BuyerProfileHeader(profile: profile),
                  const SizedBox(height: 24),
                  BuyerProfileStats(profile: profile),
                  const SizedBox(height: 24),
                  BuyerProfileMenuTile(
                    icon: Icons.edit_outlined,
                    title: context.watch<LanguageProvider>().t("editProfile"),
                    onTap: () => _openEditProfile(profile),
                  ),
                  BuyerProfileMenuTile(
                    icon: isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                    title: isDark
                        ? context.watch<LanguageProvider>().t("darkMode")
                        : context.watch<LanguageProvider>().t("lightMode"),
                    onTap: _openThemeSheet,
                  ),
                  BuyerProfileMenuTile(
                    icon: Icons.chat_bubble_outline,
                    title: context.watch<LanguageProvider>().t("myInquiries"),
                    onTap: () => Navigator.pushNamed(context, '/buyer-inquiries'),
                  ),
                  BuyerProfileMenuTile(
                    icon: Icons.favorite_border,
                    title: context.watch<LanguageProvider>().t("favoriteCrops"),
                    onTap: () => Navigator.pushNamed(context, '/buyerFavorites'),
                  ),
                  BuyerProfileMenuTile(
                    icon: Icons.notifications_none,
                    title: context.watch<LanguageProvider>().t("notifications"),
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
                    icon: Icons.logout,
                    title: context.watch<LanguageProvider>().t("logout"),
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

  Widget _topBar() {
    return Row(
      children: [

        const Spacer(),
        Text(
          context.watch<LanguageProvider>().t("profile"),
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
