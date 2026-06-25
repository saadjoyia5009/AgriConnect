import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/farmer_bottom_navbar.dart';

class FarmerProfileScreen extends StatelessWidget {
  const FarmerProfileScreen({super.key});

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xfff9fbfa),
      bottomNavigationBar: const FarmerBottomNavbar(currentIndex: 3),
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
                    _profileCard(authProvider),
                    const SizedBox(height: 34),
                    _sectionTitle("ACCOUNT INFORMATION"),
                    const SizedBox(height: 14),
                    _settingsCard(
                      children: [
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
                        _settingTile(
                          icon: Icons.lock_reset,
                          title: "Change Password",
                          subtitle: "Update your account password",
                          onTap: () {
                            _showChangePasswordDialog(context, authProvider);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 34),
                    _sectionTitle("FARMER TOOLS"),
                    const SizedBox(height: 14),
                    _settingsCard(
                      children: [
                        _settingTile(
                          icon: Icons.verified_user_outlined,
                          title: "Verification Status",
                          subtitle: "Certified farmer profile",
                          onTap: () {},
                        ),
                        _divider(),
                        _settingTile(
                          icon: Icons.eco_outlined,
                          title: "Crop Preferences",
                          subtitle: "Manage crop categories",
                          onTap: () {},
                        ),
                        _divider(),
                        _settingTile(
                          icon: Icons.location_on_outlined,
                          title: "Farm Location",
                          subtitle: "Update farm address",
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 34),
                    _sectionTitle("SUPPORT"),
                    const SizedBox(height: 14),
                    _settingsCard(
                      children: [
                        _settingTile(
                          icon: Icons.help_outline,
                          title: "Help & Support",
                          subtitle: "Get help with your account",
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 70),
                    Center(
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
                    ),
                  ],
                ),
              ),
            ),
          ],
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter new password"),
                    ),
                  );
                  return;
                }

                if (newController.text.trim() !=
                    confirmController.text.trim()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "New password and confirm password do not match",
                      ),
                    ),
                  );
                  return;
                }

                final success = authProvider.changePassword(
                  currentPassword: currentController.text.trim(),
                  newPassword: newController.text.trim(),
                );

                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Current password is incorrect"),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Password updated successfully"),
                  ),
                );
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
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

  Widget _profileCard(AuthProvider authProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 34, 18, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=300",
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: const BoxDecoration(
                    color: darkGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            authProvider.userName.isEmpty
                ? "Farmer User"
                : authProvider.userName,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: Color(0xff202525),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xffdff3e8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Certified Organic Farmer",
              style: TextStyle(
                color: darkGreen,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 20,
                color: Color(0xff4f5955),
              ),
              SizedBox(width: 5),
              Text(
                "Sahiwal, Punjab",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff4f5955),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xff4f5955),
        fontSize: 15,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _settingsCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 17),
      child: Row(
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: const Color(0xfff0f1f0),
            child: Icon(icon, color: darkGreen, size: 24),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff4f5955),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xff202525),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 17),
        child: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: const Color(0xfff0f1f0),
              child: Icon(icon, color: darkGreen, size: 24),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff202525),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xff4f5955),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 30, color: Color(0xff333333)),
          ],
        ),
      ),
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