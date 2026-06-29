import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/farmer_bottom_navbar.dart';
import '../../widgets/profile/profile_header_card.dart';
import '../../widgets/profile/profile_info_tile.dart';
import '../../widgets/profile/profile_section_title.dart';
import '../../widgets/profile/profile_settings_card.dart';

class FarmerProfileScreen extends StatelessWidget {
  const FarmerProfileScreen({super.key});

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xfff9fbfa),
      bottomNavigationBar: const FarmerBottomNavbar(currentIndex: 4),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileHeaderCard(authProvider: authProvider),
                    const SizedBox(height: 34),
                    const ProfileSectionTitle(title: "ACCOUNT INFORMATION"),
                    const SizedBox(height: 14),
                    ProfileSettingsCard(
                      children: [
                        ProfileInfoTile(
                          icon: Icons.email_outlined,
                          title: "Email Address",
                          value: authProvider.email.isEmpty
                              ? "No email found"
                              : authProvider.email,
                        ),
                        _divider(),
                        ProfileInfoTile(
                          icon: Icons.phone_outlined,
                          title: "Phone Number",
                          value: authProvider.phone.isEmpty
                              ? "No phone found"
                              : authProvider.phone,
                        ),
                        _divider(),
                        ProfileInfoTile(
                          icon: Icons.location_on_outlined,
                          title: "Farm Location",
                          value: authProvider.location,
                        ),
                        _divider(),
                        ProfileInfoTile(
                          icon: Icons.lock_reset,
                          title: "Change Password",
                          value: "",
                          subtitle: "Update your account password",
                          showArrow: true,
                          onTap: () {
                            _showChangePasswordDialog(context, authProvider);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 55),
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
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xffd8e6de)),
        ),
      ),
      child: Row(
        children: const [
          Icon(Icons.agriculture_outlined, color: darkGreen, size: 26),
          SizedBox(width: 12),
          Text(
            "AgriConnect",
            style: TextStyle(
              color: darkGreen,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          Spacer(),
          Icon(Icons.notifications_none, color: Color(0xff333333), size: 27),
        ],
      ),
    );
  }

  Widget _logoutButton(BuildContext context, AuthProvider authProvider) {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          authProvider.logout();
          Navigator.pushReplacementNamed(context, '/login');
        },
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text(
          "Logout",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w800,
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
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
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
              TextField(
                controller: currentController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Current Password",
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "New Password",
                  prefixIcon: Icon(Icons.lock_reset),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                  prefixIcon: Icon(Icons.verified_outlined),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
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

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade300,
    );
  }
}