import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../models/admin_profile_model.dart';
import '../../providers/admin_profile_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/admin/admin_profile_option_tile.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() =>
      _AdminProfileScreenState();
}

class _AdminProfileScreenState
    extends State<AdminProfileScreen> {
  static const Color darkGreen = Color(0xFF0E5A3C);
  static const Color lightBackground = Color(0xFFF4F8F5);
  static const Color darkBackground = Color(0xFF0B1410);
  static const Color darkCard = Color(0xFF15251E);
  static const Color lightGreen = Color(0xFF9FF2C1);

  bool _isLoggingOut = false;

  bool get isDark {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context
          .read<AdminProfileProvider>()
          .fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final profileProvider =
    context.watch<AdminProfileProvider>();

    return Scaffold(
      backgroundColor:
      isDark ? darkBackground : lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? darkCard : darkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context
              .watch<LanguageProvider>()
              .t("adminProfile"),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: _buildBody(
        profileProvider,
        themeProvider,
      ),
    );
  }

  Widget _buildBody(
      AdminProfileProvider profileProvider,
      ThemeProvider themeProvider,
      ) {
    if (profileProvider.isLoading &&
        profileProvider.profile == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: darkGreen,
        ),
      );
    }

    if (profileProvider.errorMessage != null &&
        profileProvider.profile == null) {
      return _errorState(profileProvider);
    }

    final profile = profileProvider.profile;

    if (profile == null) {
      return _errorState(profileProvider);
    }

    return RefreshIndicator(
      color: darkGreen,
      backgroundColor:
      isDark ? darkCard : Colors.white,
      onRefresh: profileProvider.refreshProfile,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          110,
        ),
        children: [
          _profileHeader(profile),

          const SizedBox(height: 22),

          AdminProfileOptionTile(
            icon: Icons.edit_rounded,
            title: "Edit Profile",
            subtitle:
            "Update name, phone number and address",
            color: isDark ? lightGreen : darkGreen,
            onTap: () {
              _showEditProfileDialog(
                profileProvider,
                profile,
              );
            },
          ),

          AdminProfileOptionTile(
            icon: Icons.admin_panel_settings_rounded,
            title: context
                .watch<LanguageProvider>()
                .t("adminRole"),
            subtitle: "${profile.role} • "
                "${profile.isActive ? "Active" : "Inactive"}",
            color: isDark ? lightGreen : darkGreen,
            onTap: () {
              _showAdminInformation(profile);
            },
          ),

          AdminProfileOptionTile(
            icon: isDark
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded,
            title: context
                .watch<LanguageProvider>()
                .t("appTheme"),
            subtitle: isDark
                ? context
                .watch<LanguageProvider>()
                .t("darkModeEnabled")
                : context
                .watch<LanguageProvider>()
                .t("lightModeEnabled"),
            color: isDark ? lightGreen : darkGreen,
            onTap: () {
              _showThemeSheet(themeProvider);
            },
          ),

          AdminProfileOptionTile(
            icon: Icons.security_rounded,
            title: context
                .watch<LanguageProvider>()
                .t("security"),
            subtitle: context
                .watch<LanguageProvider>()
                .t("adminSecuritySubtitle"),
            color: Colors.blue,
            onTap: () {
              Navigator.pushNamed(
                context,
                "/forgotPassword",
              );
            },
          ),

          AdminProfileOptionTile(
            icon: Icons.notifications_active_rounded,
            title: context
                .watch<LanguageProvider>()
                .t("notifications"),
            subtitle: context
                .watch<LanguageProvider>()
                .t("adminNotificationsSubtitle"),
            color: Colors.orange,
            onTap: () {
              Navigator.pushNamed(
                context,
                "/notifications",
              );
            },
          ),

          AdminProfileOptionTile(
            icon: Icons.support_agent_rounded,
            title: "Customer Support",
            subtitle: "View farmer and buyer requests",
            color: darkGreen,
            onTap: () {
              Navigator.pushNamed(
                context,
                "/adminSupport",
              );
            },
          ),

          AdminProfileOptionTile(
            icon: Icons.info_rounded,
            title: context
                .watch<LanguageProvider>()
                .t("aboutAgriConnect"),
            subtitle: context
                .watch<LanguageProvider>()
                .t("aboutAgriConnectSubtitle"),
            color: Colors.purple,
            onTap: () {
              _showAboutAgriConnectDialog();
            },
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed:
              _isLoggingOut ? null : _logout,
              icon: _isLoggingOut
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.4,
                ),
              )
                  : const Icon(Icons.logout_rounded),
              label: Text(
                _isLoggingOut
                    ? "Logging out..."
                    : context
                    .watch<LanguageProvider>()
                    .t("logout"),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                disabledBackgroundColor:
                Colors.redAccent.shade100,
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileHeader(
      AdminProfileModel profile,
      ) {
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
              color: Colors.white.withOpacity(
                isDark ? 0.14 : 0.18,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withOpacity(
                  isDark ? 0.10 : 0,
                ),
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
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  profile.fullName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  profile.email.isEmpty
                      ? "No email available"
                      : profile.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(
                      profile.isEmailVerified
                          ? Icons.verified_rounded
                          : Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        profile.isEmailVerified
                            ? "Verified ${profile.role}"
                            : "Unverified ${profile.role}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            tooltip: "Edit Profile",
            onPressed: () {
              final provider =
              context.read<AdminProfileProvider>();

              _showEditProfileDialog(
                provider,
                profile,
              );
            },
            icon: const Icon(
              Icons.edit_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 450.ms)
        .slideY(begin: -0.12, end: 0);
  }

  Widget _errorState(
      AdminProfileProvider provider,
      ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: Colors.redAccent,
              size: 64,
            ),

            const SizedBox(height: 16),

            Text(
              "Unable to load admin profile",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark
                    ? Colors.white
                    : const Color(0xFF123524),
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              provider.errorMessage ??
                  "Something went wrong",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark
                    ? Colors.white70
                    : Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: provider.fetchProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditProfileDialog(
      AdminProfileProvider provider,
      AdminProfileModel profile,
      ) async {
    final formKey = GlobalKey<FormState>();

    final firstNameController = TextEditingController(
      text: profile.firstName,
    );

    final lastNameController = TextEditingController(
      text: profile.lastName,
    );

    final phoneController = TextEditingController(
      text: profile.phone,
    );

    final addressController = TextEditingController(
      text: profile.address,
    );

    await showDialog<void>(
      context: context,
      barrierDismissible: !provider.isUpdating,
      builder: (dialogContext) {
        final dialogIsDark =
            Theme.of(dialogContext).brightness ==
                Brightness.dark;

        return Consumer<AdminProfileProvider>(
          builder: (context, currentProvider, _) {
            return AlertDialog(
              scrollable: true,
              insetPadding:
              const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              backgroundColor:
              dialogIsDark ? darkCard : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(22),
              ),
              title: Text(
                "Edit Admin Profile",
                style: TextStyle(
                  color: dialogIsDark
                      ? Colors.white
                      : const Color(0xFF123524),
                  fontWeight: FontWeight.w900,
                ),
              ),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _profileField(
                      controller:
                      firstNameController,
                      label: "First Name",
                      icon: Icons.person_outline,
                      dialogIsDark: dialogIsDark,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return "First name is required";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    _profileField(
                      controller:
                      lastNameController,
                      label: "Last Name",
                      icon: Icons.person_outline,
                      dialogIsDark: dialogIsDark,
                    ),

                    const SizedBox(height: 14),

                    _profileField(
                      controller: phoneController,
                      label: "Phone Number",
                      icon: Icons.phone_outlined,
                      dialogIsDark: dialogIsDark,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        final phone =
                            value?.trim() ?? "";

                        if (phone.isNotEmpty) {
                          final digitCount = phone
                              .replaceAll(
                            RegExp(r"[^0-9]"),
                            "",
                          )
                              .length;

                          if (digitCount < 7) {
                            return "Enter a valid phone number";
                          }
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    _profileField(
                      controller: addressController,
                      label: "Address",
                      icon:
                      Icons.location_on_outlined,
                      dialogIsDark: dialogIsDark,
                      maxLines: 3,
                    ),

                    if (currentProvider.errorMessage !=
                        null) ...[
                      const SizedBox(height: 14),
                      Text(
                        currentProvider.errorMessage!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: currentProvider.isUpdating
                      ? null
                      : () {
                    FocusManager.instance.primaryFocus?.unfocus();

                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: currentProvider.isUpdating
                      ? null
                      : () async {
                    if (!(formKey.currentState
                        ?.validate() ??
                        false)) {
                      return;
                    }

                    FocusManager.instance.primaryFocus?.unfocus();

                    final success =
                    await currentProvider
                        .updateProfile(
                      firstName:
                      firstNameController.text,
                      lastName:
                      lastNameController.text,
                      phone:
                      phoneController.text,
                      address:
                      addressController.text,
                    );

                    if (!mounted) return;

                    if (success) {
                      if (dialogContext.mounted) {
                        Navigator.pop(
                          dialogContext,
                        );
                      }

                      await Future<void>.delayed(
                        const Duration(milliseconds: 300),
                      );

                      if (!mounted) return;

                      _showSnackBar(
                        "Profile updated successfully",
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: currentProvider.isUpdating
                      ? const SizedBox(
                    height: 19,
                    width: 19,
                    child:
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.3,
                    ),
                  )
                      : const Text("Save Changes"),
                ),
              ],
            );
          },
        );
      },
    );

    provider.clearError();
  }

  Widget _profileField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool dialogIsDark,
    TextInputType keyboardType =
        TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(
        color: dialogIsDark
            ? Colors.white
            : Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color:
          dialogIsDark ? lightGreen : darkGreen,
        ),
        filled: true,
        fillColor: dialogIsDark
            ? const Color(0xFF1D3027)
            : const Color(0xFFF4F8F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: dialogIsDark
                ? Colors.white12
                : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: darkGreen,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  void _showAdminInformation(
      AdminProfileModel profile,
      ) {
    final details = [
      "Role: ${profile.role}",
      "Status: ${profile.isActive ? "Active" : "Inactive"}",
      "Email verified: "
          "${profile.isEmailVerified ? "Yes" : "No"}",
      if (profile.phone.isNotEmpty)
        "Phone: ${profile.phone}",
      if (profile.address.isNotEmpty)
        "Address: ${profile.address}",
      if (profile.joinedDate.isNotEmpty)
        "Member since: ${profile.joinedDate}",
      if (profile.lastLogin.isNotEmpty)
        "Last login: ${profile.lastLogin}",
    ].join("\n");

    _showInfoDialog(
      "Administrator Information",
      details,
    );
  }

  Future<void> _showThemeSheet(
      ThemeProvider themeProvider,
      ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor:
      isDark ? darkCard : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20,
              18,
              20,
              26 +
                  MediaQuery.viewInsetsOf(
                    sheetContext,
                  ).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context
                      .read<LanguageProvider>()
                      .t("chooseTheme"),
                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF123524),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 16),

                _themeOption(
                  context: sheetContext,
                  icon: Icons.light_mode_rounded,
                  title: context
                      .read<LanguageProvider>()
                      .t("lightMode"),
                  selected:
                  themeProvider.themeMode ==
                      ThemeMode.light,
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();

                    await themeProvider.setLightMode();

                    if (sheetContext.mounted) {
                      Navigator.pop(sheetContext);
                    }
                  },
                ),

                _themeOption(
                  context: sheetContext,
                  icon: Icons.dark_mode_rounded,
                  title: context
                      .read<LanguageProvider>()
                      .t("darkMode"),
                  selected:
                  themeProvider.themeMode ==
                      ThemeMode.dark,
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();

                    await themeProvider.setDarkMode();

                    if (sheetContext.mounted) {
                      Navigator.pop(sheetContext);
                    }
                  },
                ),

                _themeOption(
                  context: sheetContext,
                  icon: Icons.phone_iphone_rounded,
                  title: context
                      .read<LanguageProvider>()
                      .t("systemDefault"),
                  selected:
                  themeProvider.themeMode ==
                      ThemeMode.system,
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();

                    await themeProvider.setSystemMode();

                    if (sheetContext.mounted) {
                      Navigator.pop(sheetContext);
                    }
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
    final optionIsDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: selected
            ? (optionIsDark
            ? lightGreen
            : darkGreen)
            : (optionIsDark
            ? Colors.white70
            : Colors.grey.shade700),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: optionIsDark
              ? Colors.white
              : const Color(0xFF123524),
          fontWeight: FontWeight.w800,
        ),
      ),
      trailing: selected
          ? Icon(
        Icons.check_circle,
        color: optionIsDark
            ? lightGreen
            : darkGreen,
      )
          : null,
    );
  }

  void _showInfoDialog(
      String title,
      String message,
      ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final dialogIsDark =
            Theme.of(dialogContext).brightness ==
                Brightness.dark;

        return AlertDialog(
          scrollable: true,
          backgroundColor:
          dialogIsDark ? darkCard : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: dialogIsDark
                  ? Colors.white
                  : const Color(0xFF123524),
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: dialogIsDark
                  ? Colors.white70
                  : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                context
                    .read<LanguageProvider>()
                    .t("okay"),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: dialogIsDark
                      ? lightGreen
                      : darkGreen,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      _isLoggingOut = true;
    });

    try {
      await context.read<AuthProvider>().logout();

      if (!mounted) return;

      context
          .read<AdminProfileProvider>()
          .clearProfile();

      Navigator.pushNamedAndRemoveUntil(
        context,
        "/login",
            (route) => false,
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoggingOut = false;
      });

      _showSnackBar(
        "Unable to logout. Please try again.",
        isError: true,
      );
    }
  }

  void _showAboutAgriConnectDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final dialogIsDark =
            Theme.of(dialogContext).brightness ==
                Brightness.dark;

        return Dialog(
          backgroundColor:
          dialogIsDark ? darkCard : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                22,
                24,
                22,
                20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // AgriConnect Icon
                  Container(
                    height: 76,
                    width: 76,
                    decoration: BoxDecoration(
                      color: dialogIsDark
                          ? const Color(0xFF263B31)
                          : const Color(0xFFE8F5EE),
                      borderRadius:
                      BorderRadius.circular(24),
                    ),
                    child: Icon(
                      Icons.agriculture_rounded,
                      size: 42,
                      color: dialogIsDark
                          ? lightGreen
                          : darkGreen,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // App Name
                  Text(
                    'AgriConnect',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: dialogIsDark
                          ? Colors.white
                          : const Color(0xFF123524),
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'AI-Powered Farmer Marketplace',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: dialogIsDark
                          ? lightGreen
                          : darkGreen,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Description
                  Text(
                    'AgriConnect is a smart agricultural '
                        'marketplace designed to connect farmers '
                        'directly with buyers.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: dialogIsDark
                          ? Colors.white70
                          : Colors.grey.shade700,
                      height: 1.55,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'The platform helps farmers showcase their '
                        'crops, reach potential buyers, access '
                        'weather and market information, and make '
                        'better selling decisions with '
                        'AI-powered insights.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: dialogIsDark
                          ? Colors.white70
                          : Colors.grey.shade700,
                      height: 1.55,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Divider
                  Divider(
                    color: dialogIsDark
                        ? Colors.white12
                        : Colors.grey.shade300,
                  ),

                  const SizedBox(height: 18),

                  Text(
                    'Developed By',
                    style: TextStyle(
                      color: dialogIsDark
                          ? Colors.white
                          : const Color(0xFF123524),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Developers
                  Row(
                    children: [
                      Expanded(
                        child: _developerCard(
                          imagePath:
                          'assets/images/img_4.png',
                          name: 'Muhammad Saad',
                          role: 'Frontend / AI',
                          dialogIsDark:
                          dialogIsDark,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _developerCard(
                          imagePath:
                          'assets/images/img_2.png',
                          name: 'Muhammad Ghous',
                          role: "Backend / Database ",
                          dialogIsDark:
                          dialogIsDark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  Text(
                    'Final Year Project • Version 1.0.0',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: dialogIsDark
                          ? Colors.white54
                          : Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _developerCard({
    required String imagePath,
    required String name,
    required String role,
    required bool dialogIsDark,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        10,
        14,
        10,
        14,
      ),
      decoration: BoxDecoration(
        color: dialogIsDark
            ? const Color(0xFF1D3027)
            : const Color(0xFFF4F8F5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: dialogIsDark
              ? Colors.white10
              : const Color(0xFFE3EBE6),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: dialogIsDark
                ? const Color(0xFF263B31)
                : const Color(0xFFE8F5EE),
            backgroundImage: AssetImage(imagePath),
          ),

          const SizedBox(height: 10),

          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: dialogIsDark
                  ? Colors.white
                  : const Color(0xFF123524),
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            role,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: dialogIsDark
                  ? Colors.white60
                  : Colors.grey.shade600,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(
      String message, {
        bool isError = false,
      }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
          isError ? Colors.redAccent : darkGreen,
        ),
      );
  }
}
