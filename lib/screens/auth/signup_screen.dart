import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/auth/auth_background.dart';
import '../../widgets/auth/auth_input_field.dart';
import '../../widgets/auth/auth_role_dropdown.dart';
import 'verify_email_otp_screen.dart';
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

  static const Color darkGreen = Color(0xFF0E5A3C);

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
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

  Future<void> _signup(AuthProvider authProvider, LanguageProvider lang) async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(lang.t("fillAllFields")),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await authProvider.signup(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? lang.t("signupFailed")),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Account created successfully. Please verify your email.",
        ),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => VerifyEmailOtpScreen(
          email: email,
        ),
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
            child: const Icon(Icons.eco, color: Colors.white, size: 28),
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
}
