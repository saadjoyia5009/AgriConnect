import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/auth/auth_background.dart';
import '../../widgets/auth/auth_input_field.dart';
import '../../widgets/auth/auth_role_dropdown.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';
import 'package:animations/animations.dart';

import '../farmer/farmer_dashboard_screen.dart';
import '../buyer/buyer_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  static const Color darkGreen = Color(0xFF0E5A3C);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Route _animatedRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, animation, secondaryAnimation) => page,
      transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
          ) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
    );
  }

  void _openForgotPassword() {
    Navigator.push(
      context,
      _animatedRoute(const ForgotPasswordScreen()),
    );
  }

  void _openSignup() {
    Navigator.push(
      context,
      _animatedRoute(const SignupScreen()),
    );
  }

  void _navigateByRole(String role) {
    Widget? screen;

    switch (role.toLowerCase()) {
      case "farmer":
        screen = const FarmerDashboardScreen();
        break;

      case "buyer":
        screen = const BuyerDashboardScreen();
        break;

      case "admin":
        Navigator.pushReplacementNamed(context, '/adminDashboard');
        return;
    }

    if (screen == null) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, __, ___) => screen!,
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

  Future<void> _login(AuthProvider authProvider) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter email and password first"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await authProvider.login(
      email: email,
      password: password,
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? "Invalid email or password"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _navigateByRole(authProvider.role);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

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
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.74),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.55),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _logo(),
                        const SizedBox(height: 30),

                        const Center(
                          child: Text(
                            "Welcome back",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1D1D1D),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Center(
                          child: Text(
                            "Please enter your details to sign in.",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF4A4A4A),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        _label("Email"),
                        const SizedBox(height: 8),
                        AuthInputField(
                          controller: emailController,
                          hintText: "farmer@example.com",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 18),

                        _label("Password"),
                        const SizedBox(height: 8),
                        AuthInputField(
                          controller: passwordController,
                          hintText: "••••••••",
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

                        const SizedBox(height: 16),

                        _label("Select Your Role"),
                        const SizedBox(height: 8),
                        AuthRoleDropdown(
                          value: authProvider.selectedRole,
                          onChanged: authProvider.selectRole,
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Spacer(),
                            TextButton(
                              onPressed: authProvider.isLoading
                                  ? null
                                  : _openForgotPassword,
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: darkGreen,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: authProvider.isLoading
                                ? null
                                : () => _login(authProvider),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: darkGreen,
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: darkGreen.withOpacity(0.20),
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
                                : const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Center(
                          child: GestureDetector(
                            onTap: authProvider.isLoading ? null : _openSignup,
                            child: const Text.rich(
                              TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Sign Up",
                                    style: TextStyle(
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

  Widget _logo() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: darkGreen,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.eco,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            "AgriConnect",
            style: TextStyle(
              color: darkGreen,
              fontSize: 28,
              fontWeight: FontWeight.w900,
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