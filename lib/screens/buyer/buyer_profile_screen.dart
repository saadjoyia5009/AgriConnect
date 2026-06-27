import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_buyer_profile_screen.dart';
import '../../providers/buyer_profile_provider.dart';
import '../../widgets/buyer/buyer_bottom_navbar.dart';
import '../../widgets/buyer/profile/buyer_profile_header.dart';
import '../../widgets/buyer/profile/buyer_profile_stats.dart';
import '../../widgets/buyer/profile/buyer_profile_menu_tile.dart';

class BuyerProfileScreen extends StatefulWidget {
  const BuyerProfileScreen({super.key});

  @override
  State<BuyerProfileScreen> createState() => _BuyerProfileScreenState();
}

class _BuyerProfileScreenState extends State<BuyerProfileScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<BuyerProfileProvider>().fetchProfile();
    });
  }

  void _onNavTap(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/buyerDashboard');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/buyerFavorites');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/buyer-inquiries');
    } else if (index == 3) {
      return;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAF7),
      bottomNavigationBar: BuyerBottomNavBar(
        currentIndex: 3,
        onTap: _onNavTap,
      ),
      body: SafeArea(
        child: Consumer<BuyerProfileProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage != null) {
              return Center(
                child: Text(
                  provider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final profile = provider.profile;

            if (profile == null) {
              return const Center(child: Text("No profile found"));
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
                    title: "Edit Profile",
                    onTap: () => _openEditProfile(profile),
                  ),
                  BuyerProfileMenuTile(
                    icon: Icons.chat_bubble_outline,
                    title: "My Inquiries",
                    onTap: () {
                      Navigator.pushNamed(context, '/buyer-inquiries');
                    },
                  ),
                  BuyerProfileMenuTile(
                    icon: Icons.favorite_border,
                    title: "Favorite Crops",
                    onTap: () {
                      Navigator.pushNamed(context, '/buyerFavorites');
                    },
                  ),
                  BuyerProfileMenuTile(
                    icon: Icons.notifications_none,
                    title: "Notifications",
                    onTap: () {},
                  ),
                  BuyerProfileMenuTile(
                    icon: Icons.logout,
                    title: "Logout",
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
      children: const [
        Icon(Icons.menu, size: 25, color: Color(0xff26342D)),
        Spacer(),
        Text(
          "Buyer Profile",
          style: TextStyle(
            color: Color(0xff0F5C3A),
            fontWeight: FontWeight.w900,
            fontSize: 21,
          ),
        ),
        Spacer(),
        Icon(Icons.settings_outlined, color: Color(0xff26342D)),
      ],
    );
  }
}