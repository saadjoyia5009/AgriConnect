import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/buyer_favorite_provider.dart';
import '../../widgets/buyer/buyer_bottom_navbar.dart';
import '../buyer/send_inquiry_screen.dart';
import '../../widgets/buyer/buyer_favorite_crop_card.dart';

class BuyerFavoritesScreen extends StatefulWidget {
  const BuyerFavoritesScreen({super.key});

  @override
  State<BuyerFavoritesScreen> createState() => _BuyerFavoritesScreenState();
}

class _BuyerFavoritesScreenState extends State<BuyerFavoritesScreen> {
  int _selectedIndex = 1;

  final List<String> categories = [
    "All Favorites",
    "Vegetables",
    "Fruits",
    "Grains",
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<BuyerFavoriteProvider>().fetchFavorites();
    });
  }

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/buyerDashboard');
    } else if (index == 1) {
      return;
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/buyer-inquiries');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/buyerProfile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAF7),
      bottomNavigationBar: BuyerBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
      body: SafeArea(
        child: Consumer<BuyerFavoriteProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                _topBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Favorite Crops",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff0F5C3A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Your saved items from local growers.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xff5F675F),
                          ),
                        ),
                        const SizedBox(height: 22),
                        _categoryChips(provider),
                        const SizedBox(height: 18),
                        _favoriteList(provider),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
      child: Row(
        children: [
          const Icon(Icons.menu, color: Color(0xff26342D)),
          const Spacer(),
          const Text(
            "AgriConnect",
            style: TextStyle(
              color: Color(0xff0F5C3A),
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const Spacer(),
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage("https://i.pravatar.cc/100?img=12"),
          ),
        ],
      ),
    );
  }

  Widget _categoryChips(BuyerFavoriteProvider provider) {
    return SizedBox(
      height: 35,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = provider.selectedCategory == category;

          return ChoiceChip(
            label: Text(category),
            selected: selected,
            onSelected: (_) => provider.changeCategory(category),
            selectedColor: const Color(0xffBDF2CE),
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: selected ? const Color(0xff0F5C3A) : Colors.black87,
            ),
            side: const BorderSide(color: Color(0xffDCE7DD)),
            showCheckmark: false,
          );
        },
      ),
    );
  }

  Widget _favoriteList(BuyerFavoriteProvider provider) {
    if (provider.isLoading) {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.favoriteCrops.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(child: Text("No favorite crops found")),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.favoriteCrops.length,
      itemBuilder: (context, index) {
        final crop = provider.favoriteCrops[index];

        return BuyerFavoriteCropCard(
          crop: crop,
          onRemoveTap: () => provider.removeFavorite(crop.id),
          onInquireTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SendInquiryScreen(
                  crop: crop,
                ),
              ),
            );
          },
        );
      },
    );
  }
}