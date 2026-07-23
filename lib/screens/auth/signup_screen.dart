import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import '../../data/pakistan_cities.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/auth/auth_background.dart';
import '../../widgets/auth/auth_input_field.dart';
import '../../widgets/auth/auth_role_dropdown.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final locationController = TextEditingController();
  final citySearchController = TextEditingController();

  final citySearchFocusNode = FocusNode();
  final manualLocationFocusNode = FocusNode();

  String? selectedCity;
  bool enterLocationManually = false;

  static const Color darkGreen = Color(0xFF0E5A3C);

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    locationController.dispose();
    citySearchController.dispose();
    citySearchFocusNode.dispose();
    manualLocationFocusNode.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
      ),
    );
  }

  Future<void> _signup(
      AuthProvider authProvider,
      LanguageProvider lang,
      ) async {
    final name = nameController.text.trim();
    final email = emailController.text.trim().toLowerCase();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    final address = enterLocationManually
        ? locationController.text.trim()
        : (selectedCity ?? '').trim();

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty) {
      _showMessage(
        lang.t("fillAllFields"),
        backgroundColor: Colors.red,
      );
      return;
    }

    if (address.isEmpty) {
      _showMessage(
        lang.t("locationRequired"),
        backgroundColor: Colors.red,
      );
      return;
    }

    final signupSuccess = await authProvider.signup(
      name: name,
      email: email,
      phone: phone,
      password: password,
      address: address,
    );

    if (!mounted) return;

    if (!signupSuccess) {
      _showMessage(
        authProvider.errorMessage ?? lang.t("signupFailed"),
        backgroundColor: Colors.red,
      );
      return;
    }

    _showMessage(
      "Account created successfully. Please login.",
      backgroundColor: Colors.green,
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (route) => false,
    );
  }

  void _showMessage(
      String message, {
        required Color backgroundColor,
      }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AuthBackground(
        child: SizedBox.expand(
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: RepaintBoundary(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 26, 24, 26),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.78),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.50),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.14),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _logo(lang),
                        const SizedBox(height: 20),

                        Center(
                          child: Text(
                            lang.t("createAccount"),
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1D1D1D),
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        Center(
                          child: Text(
                            lang.t("signupSubtitle"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF4A4A4A),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        _label(lang.t("fullName")),
                        const SizedBox(height: 8),
                        AuthInputField(
                          controller: nameController,
                          hintText: lang.t("enterName"),
                          icon: Icons.person_outline,
                        ),

                        const SizedBox(height: 14),

                        _label(lang.t("email")),
                        const SizedBox(height: 8),
                        AuthInputField(
                          controller: emailController,
                          hintText: lang.t("signupEmailHint"),
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 14),

                        _label(lang.t("phoneNumber")),
                        const SizedBox(height: 8),
                        AuthInputField(
                          controller: phoneController,
                          hintText: lang.t("phoneHint"),
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),

                        const SizedBox(height: 14),

                        _label(lang.t("location")),
                        const SizedBox(height: 8),
                        _locationSelector(lang),

                        if (enterLocationManually) ...[
                          const SizedBox(height: 10),
                          AuthInputField(
                            controller: locationController,
                            focusNode: manualLocationFocusNode,
                            hintText: lang.t("enterLocation"),
                            icon: Icons.edit_location_alt_outlined,
                          ),
                        ],

                        const SizedBox(height: 14),

                        _label(lang.t("password")),
                        const SizedBox(height: 8),
                        AuthInputField(
                          controller: passwordController,
                          hintText: lang.t("passwordHint"),
                          icon: Icons.lock_outline,
                          obscureText: authProvider.isPasswordHidden,
                          suffixIcon: IconButton(
                            onPressed: authProvider.togglePasswordVisibility,
                            icon: Icon(
                              authProvider.isPasswordHidden
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        _label(lang.t("selectRole")),
                        const SizedBox(height: 8),
                        AuthRoleDropdown(
                          value: authProvider.selectedRole,
                          onChanged: authProvider.selectRole,
                        ),

                        const SizedBox(height: 22),

                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: authProvider.isLoading
                                ? null
                                : () => _signup(authProvider, lang),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: darkGreen,
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: darkGreen.withValues(alpha: 0.18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: authProvider.isLoading
                                ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.4,
                              ),
                            )
                                : Text(
                              lang.t("signup"),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Center(
                          child: GestureDetector(
                            onTap: authProvider.isLoading ? null : _goToLogin,
                            child: Text.rich(
                              TextSpan(
                                text: lang.t("alreadyHaveAccount"),
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: lang.t("login"),
                                    style: const TextStyle(
                                      color: darkGreen,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _logo(LanguageProvider lang) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: darkGreen,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.eco,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Flexible(
            child: Text(
              lang.t("appName"),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: darkGreen,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w900,
        color: Color(0xFF26332D),
      ),
    );
  }

  Widget _locationSelector(LanguageProvider lang) {
    return Theme(
      data: ThemeData.light(),
      child: InkWell(
        onTap: () => _showCitySelector(lang),
        borderRadius: BorderRadius.circular(14),
        child: InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            prefixIcon: const Icon(
              Icons.location_city,
              color: darkGreen,
            ),
            suffixIcon: const Icon(
              Icons.arrow_drop_down,
              color: darkGreen,
            ),
          ),
          child: Text(
            enterLocationManually
                ? lang.t('otherEnterManually')
                : selectedCity ?? lang.t('selectCity'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: selectedCity == null && !enterLocationManually
                  ? Colors.grey.shade600
                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showCitySelector(LanguageProvider lang) async {
    citySearchController.clear();

    final selection = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final cities = PakistanCities.values.where((city) {
              return city.toLowerCase().contains(
                citySearchController.text.trim().toLowerCase(),
              );
            }).toList();

            return AlertDialog(
              title: Text(lang.t('selectCity')),
              contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              content: SizedBox(
                width: double.maxFinite,
                height: MediaQuery.sizeOf(context).height * 0.55,
                child: Column(
                  children: [
                    TextField(
                      controller: citySearchController,
                      focusNode: citySearchFocusNode,
                      autofocus: true,
                      onChanged: (_) {
                        setDialogState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: lang.t('searchCity'),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.edit_location_alt_outlined,
                        color: darkGreen,
                      ),
                      title: Text(lang.t('otherEnterManually')),
                      onTap: () {
                        Navigator.pop(
                          dialogContext,
                          PakistanCities.other,
                        );
                      },
                    ),

                    const Divider(height: 1),

                    Expanded(
                      child: ListView.builder(
                        itemCount: cities.length,
                        itemBuilder: (context, index) {
                          final city = cities[index];

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.location_on_outlined,
                              color: darkGreen,
                            ),
                            title: Text(city),
                            trailing: selectedCity == city
                                ? const Icon(
                              Icons.check,
                              color: darkGreen,
                            )
                                : null,
                            onTap: () {
                              Navigator.pop(dialogContext, city);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (!mounted || selection == null) return;

    final isManual = selection == PakistanCities.other;

    setState(() {
      enterLocationManually = isManual;
      selectedCity = isManual ? null : selection;

      if (!isManual) {
        locationController.clear();
      }
    });

    if (isManual) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          manualLocationFocusNode.requestFocus();
        }
      });
    }
  }
}