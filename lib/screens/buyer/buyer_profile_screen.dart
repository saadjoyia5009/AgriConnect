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
  static const Color darkGreen = Color(0xff075739);
  static const Color lightGreen = Color(0xff9ff2c1);
  static const Color lightBackground = Color(0xffF9FBFA);
  static const Color darkBackground = Color(0xFF0B1410);

  bool get isDark {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color get accentColor {
    return isDark ? lightGreen : darkGreen;
  }

  Color get primaryText {
    return isDark ? Colors.white : const Color(0xff10291D);
  }

  Color get secondaryText {
    return isDark ? Colors.white60 : const Color(0xff4F5955);
  }

  Color get errorColor {
    return isDark ? Colors.red.shade200 : Colors.red;
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
      0: '/buyerDashboard',
      1: '/buyerFavorites',
      2: '/buyerChats',
      3: '/buyer-inquiries',
      4: '/buyerProfile',
    };

    final String? route = routes[index];

    if (route == null) return;

    Navigator.pushReplacementNamed(context, route);
  }

  Future<void> _openEditProfile() async {
    final ProfileProvider profileProvider = context.read<ProfileProvider>();

    final profile = profileProvider.profile;

    if (profile == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditBuyerProfileScreen(profile: profile),
      ),
    );

    if (!mounted) return;

    await profileProvider.fetchProfile();
  }

  void _handleBackNavigation() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    Navigator.pushReplacementNamed(context, '/buyerDashboard');
  }

  void _openThemeSheet() {
    final ThemeProvider themeProvider = context.read<ThemeProvider>();

    final BuyerLanguageProvider language = context
        .read<BuyerLanguageProvider>();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 5,
                  width: 46,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  language.t('chooseTheme'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 18),
                _themeOption(
                  sheetContext: sheetContext,
                  icon: Icons.light_mode_outlined,
                  title: language.t('lightMode'),
                  selected: themeProvider.themeMode == ThemeMode.light,
                  onTap: () {
                    themeProvider.setLightMode();
                    Navigator.pop(sheetContext);
                  },
                ),
                _sheetDivider(),
                _themeOption(
                  sheetContext: sheetContext,
                  icon: Icons.dark_mode_outlined,
                  title: language.t('darkMode'),
                  selected: themeProvider.themeMode == ThemeMode.dark,
                  onTap: () {
                    themeProvider.setDarkMode();
                    Navigator.pop(sheetContext);
                  },
                ),
                _sheetDivider(),
                _themeOption(
                  sheetContext: sheetContext,
                  icon: Icons.phone_iphone_rounded,
                  title: language.t('systemDefault'),
                  selected: themeProvider.themeMode == ThemeMode.system,
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

  Widget _themeOption({
    required BuildContext sheetContext,
    required IconData icon,
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      onTap: onTap,
      leading: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF263B31) : const Color(0xffE8F5EE),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: accentColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
      trailing: Icon(
        selected ? Icons.check_circle_rounded : Icons.circle_outlined,
        color: selected ? accentColor : secondaryText,
      ),
    );
  }

  void _openLanguageSheet() {
    final BuyerLanguageProvider buyerLanguage = context
        .read<BuyerLanguageProvider>();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return ChangeNotifierProvider<BuyerLanguageProvider>.value(
          value: buyerLanguage,
          child: Consumer<BuyerLanguageProvider>(
            builder: (context, language, child) {
              return SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 5,
                        width: 46,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white24 : Colors.black12,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        language.t('chooseLanguage'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _languageOption(
                        sheetContext,
                        language: language,
                        code: 'en',
                        label: language.t('languageEnglish'),
                      ),
                      _sheetDivider(),
                      _languageOption(
                        sheetContext,
                        language: language,
                        code: 'ur',
                        label: language.t('languageUrdu'),
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
    final bool selected = language.locale.languageCode == code;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF263B31) : const Color(0xffE8F5EE),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(Icons.language_rounded, color: accentColor),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
      trailing: Icon(
        selected ? Icons.check_circle_rounded : Icons.circle_outlined,
        color: selected ? accentColor : secondaryText,
      ),
      onTap: () async {
        await language.changeLanguage(code);

        if (!sheetContext.mounted) return;

        Navigator.pop(sheetContext);
      },
    );
  }

  Widget _sheetDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark ? Colors.white12 : Colors.grey.shade300,
    );
  }

  void _openHelpDialog() {
    final BuyerLanguageProvider language = context
        .read<BuyerLanguageProvider>();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF263B31)
                      : const Color(0xffE8F5EE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.headset_mic_rounded, color: accentColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  language.t('helpSupport'),
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            language.t('aboutAgriConnectDescription'),
            style: TextStyle(
              color: primaryText,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                language.t('okay'),
                style: const TextStyle(
                  color: darkGreen,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    final AuthProvider authProvider = context.read<AuthProvider>();

    final ProfileProvider profileProvider = context.read<ProfileProvider>();

    await authProvider.logout();

    profileProvider.clearProfile();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final BuyerLanguageProvider language = context
        .watch<BuyerLanguageProvider>();

    final ProfileProvider profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: isDark ? darkBackground : lightBackground,
      bottomNavigationBar: BuyerBottomNavBar(currentIndex: 4, onTap: _onNavTap),
      body: SafeArea(
        top: false,
        child: _buildContent(language, profileProvider),
      ),
    );
  }

  Widget _buildContent(
    BuyerLanguageProvider language,
    ProfileProvider profileProvider,
  ) {
    if (profileProvider.isLoading && profileProvider.profile == null) {
      return Center(child: CircularProgressIndicator(color: accentColor));
    }

    if (profileProvider.errorMessage != null &&
        profileProvider.profile == null) {
      return _errorView(profileProvider);
    }

    final profile = profileProvider.profile;

    if (profile == null) {
      return _errorView(profileProvider);
    }

    return RefreshIndicator(
      color: darkGreen,
      onRefresh: _refreshProfile,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            BuyerProfileHeader(
              profile: profile,
              onCameraTap: _openEditProfile,
              onBackTap: _handleBackNavigation,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 28),
              child: Column(
                children: [
                  _personalInformationCard(
                    profile: profile,
                    language: language,
                  ),
                  const SizedBox(height: 24),
                  _accountSettingsCard(language),
                  const SizedBox(height: 28),
                  _logoutButton(language),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorView(ProfileProvider profileProvider) {
    return RefreshIndicator(
      color: darkGreen,
      onRefresh: _refreshProfile,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.22),
          Icon(Icons.person_off_outlined, size: 65, color: errorColor),
          const SizedBox(height: 18),
          Text(
            profileProvider.errorMessage ?? 'Unable to load profile.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: primaryText,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: profileProvider.fetchProfile,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _personalInformationCard({
    required dynamic profile,
    required BuyerLanguageProvider language,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _cardTitle(
            icon: Icons.person,
            title: language.t('personalInformation'),
          ),
          const SizedBox(height: 12),
          _informationRow(
            icon: Icons.email,
            title: language.t('emailAddress'),
            value: profile.email.trim().isEmpty
                ? 'No email found'
                : profile.email,
            forceLtr: true,
          ),
          _cardDivider(),
          _informationRow(
            icon: Icons.phone,
            title: language.t('phoneNumber'),
            value: profile.displayPhone.trim().isEmpty
                ? 'No phone found'
                : profile.displayPhone,
            forceLtr: true,
          ),
          _cardDivider(),
          _informationRow(
            icon: Icons.location_on,
            title: language.t('location'),
            value: profile.displayAddress.trim().isEmpty
                ? 'No location found'
                : profile.displayAddress,
          ),
        ],
      ),
    );
  }

  Widget _accountSettingsCard(BuyerLanguageProvider language) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _cardTitle(icon: Icons.settings, title: language.t('settings')),
          const SizedBox(height: 14),
          BuyerProfileMenuTile(
            icon: Icons.person,
            title: language.t('editProfile'),
            onTap: _openEditProfile,
          ),
          _cardDivider(),
          BuyerProfileMenuTile(
            icon: Icons.language,
            title: language.t('language'),
            subtitle: language.isUrdu
                ? language.t('languageUrdu')
                : language.t('languageEnglish'),
            onTap: _openLanguageSheet,
          ),
          _cardDivider(),
          BuyerProfileMenuTile(
            icon: Icons.notifications,
            title: language.t('notifications'),
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
          _cardDivider(),
          BuyerProfileMenuTile(
            icon: isDark ? Icons.dark_mode : Icons.light_mode,
            title: language.t('settings'),
            subtitle: isDark ? language.t('darkMode') : language.t('lightMode'),
            onTap: _openThemeSheet,
          ),
          _cardDivider(),
          BuyerProfileMenuTile(
            icon: Icons.chat_bubble_outline,
            title: language.t('myInquiries'),
            onTap: () {
              Navigator.pushNamed(context, '/buyer-inquiries');
            },
          ),
          _cardDivider(),
          BuyerProfileMenuTile(
            icon: Icons.favorite_border,
            title: language.t('favoriteCrops'),
            onTap: () {
              Navigator.pushNamed(context, '/buyerFavorites');
            },
          ),
          _cardDivider(),
          BuyerProfileMenuTile(
            icon: Icons.headset_mic,
            title: language.t('helpSupport'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/customerSupport',
              );
            },
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: isDark ? Colors.white10 : const Color(0xffE3EBE6),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.06),
          blurRadius: 22,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  Widget _cardTitle({required IconData icon, required String title}) {
    return Row(
      children: [
        _profileIconBox(icon),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: accentColor,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _informationRow({
    required IconData icon,
    required String title,
    required String value,
    bool forceLtr = false,
  }) {
    final Widget valueText = Text(
      value,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: primaryText,
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          _profileIconBox(icon),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                forceLtr
                    ? Directionality(
                        textDirection: TextDirection.ltr,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: valueText,
                        ),
                      )
                    : valueText,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileIconBox(IconData icon) {
    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF263B31) : const Color(0xffE8F5EE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: accentColor, size: 23),
    );
  }

  Widget _cardDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark ? Colors.white12 : Colors.grey.shade300,
    );
  }

  Widget _logoutButton(BuyerLanguageProvider language) {
    return SizedBox(
      height: 58,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _logout,
        icon: const Icon(Icons.logout, color: Colors.red, size: 28),
        label: Text(
          language.t('logout'),
          style: const TextStyle(
            color: Colors.red,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
