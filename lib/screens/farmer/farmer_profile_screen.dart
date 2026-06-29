import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/farmer_bottom_navbar.dart';
import 'edit_profile_screen.dart';

class FarmerProfileScreen extends StatelessWidget {
  const FarmerProfileScreen({super.key});

  static const Color darkGreen = Color(0xff075739);
  static const Color lightGreen = Color(0xffEAF6EF);
  static const Color bgColor = Color(0xffF4F8F5);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: const FarmerBottomNavbar(currentIndex: 4),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                child: Column(
                  children: [
                    _profileHero(context, authProvider),
                    const SizedBox(height: 22),
                    _accountCard(context, authProvider),
                    const SizedBox(height: 22),
                    _logoutButton(context, authProvider),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.agriculture_rounded, color: darkGreen, size: 26),
          SizedBox(width: 10),
          Text(
            "AgriConnect",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: darkGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileHero(BuildContext context, AuthProvider authProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff075739),
            Color(0xff0E7A4E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withOpacity(0.25),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 86,
            width: 86,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            authProvider.userName.isEmpty
                ? "Farmer User"
                : authProvider.userName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              authProvider.selectedRole,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EditProfileScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: const Text("Edit Profile"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: darkGreen,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountCard(BuildContext context, AuthProvider authProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Account Information",
            style: TextStyle(
              color: darkGreen,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          _infoTile(
            icon: Icons.email_outlined,
            title: "Email Address",
            value: authProvider.email.isEmpty
                ? "No email found"
                : authProvider.email,
          ),
          _divider(),
          _infoTile(
            icon: Icons.phone_outlined,
            title: "Phone Number",
            value: authProvider.phone.isEmpty
                ? "No phone found"
                : authProvider.phone,
          ),
          _divider(),
          _infoTile(
            icon: Icons.location_on_outlined,
            title: "Farm Location",
            value: authProvider.location,
          ),
          _divider(),
          _infoTile(
            icon: Icons.lock_reset_rounded,
            title: "Change Password",
            value: "Update your account password",
            showArrow: true,
            onTap: () => _showChangePasswordDialog(context, authProvider),
          ),
        ],
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
    bool showArrow = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: darkGreen, size: 23),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xff1F2D24),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            if (showArrow)
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.black38,
              ),
          ],
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context, AuthProvider authProvider) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: () {
          authProvider.logout();
          Navigator.pushReplacementNamed(context, '/login');
        },
        icon: const Icon(Icons.logout_rounded),
        label: const Text("Logout"),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Color(0xffF2B8B5)),
          backgroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
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
          insetPadding: const EdgeInsets.symmetric(horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            "Change Password",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: darkGreen,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _passwordField(
                controller: currentController,
                label: "Current Password",
                icon: Icons.lock_outline,
              ),
              const SizedBox(height: 12),
              _passwordField(
                controller: newController,
                label: "New Password",
                icon: Icons.lock_reset,
              ),
              const SizedBox(height: 12),
              _passwordField(
                controller: confirmController,
                label: "Confirm Password",
                icon: Icons.verified_outlined,
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                if (newController.text.trim().isEmpty ||
                    confirmController.text.trim().isEmpty) {
                  _showSnackBar(context, "Please enter new password");
                  return;
                }

                if (newController.text.trim() !=
                    confirmController.text.trim()) {
                  _showSnackBar(
                    context,
                    "New password and confirm password do not match",
                  );
                  return;
                }

                final success = authProvider.changePassword(
                  currentPassword: currentController.text.trim(),
                  newPassword: newController.text.trim(),
                );

                if (!success) {
                  _showSnackBar(context, "Current password is incorrect");
                  return;
                }

                Navigator.pop(dialogContext);
                _showSnackBar(context, "Password updated successfully");
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: darkGreen),
        filled: true,
        fillColor: const Color(0xffF4F8F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xffDDE8E1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: darkGreen, width: 1.4),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade200,
    );
  }
}