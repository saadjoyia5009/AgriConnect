import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/crop_provider.dart';
import '../../widgets/buyer/buyer_bottom_navbar.dart';
import '../../widgets/buyer/buyer_category_card.dart';
import '../../widgets/buyer/buyer_crop_card.dart';
import '../../widgets/buyer/buyer_search_bar.dart';
import '../../widgets/buyer/buyer_section_header.dart';
import '../../providers/buyer_favorite_provider.dart';
import 'buyer_crop_detail_screen.dart';

class BuyerDashboardScreen extends StatefulWidget {
  const BuyerDashboardScreen({super.key});

  @override
  State<BuyerDashboardScreen> createState() => _BuyerDashboardScreenState();
}

class _BuyerDashboardScreenState extends State<BuyerDashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CropProvider>().fetchCrops();
    });
  }

  void _onNavTap(int index) {
    if (index == 1) {
      Navigator.pushReplacementNamed(
        context,
        '/buyerFavorites',
      );
    }

    if (index == 2) {
      Navigator.pushReplacementNamed(context, '/buyer-inquiries');
    }

    if (index == 3) {
      Navigator.pushReplacementNamed(
        context,
        '/buyerProfile',
      );
    }

    setState(() => _selectedIndex = index);
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
        child: Consumer<CropProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topBar(),
                  const SizedBox(height: 34),
                  const Text(
                    'Good morning, Buyer.',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      color: Color(0xff1F2722),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Find the freshest produce today.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff5F675F),
                    ),
                  ),
                  const SizedBox(height: 16),
                  BuyerSearchBar(
                    hintText: 'Search for crops or sellers...',
                    onChanged: (value) {
                      print("SEARCH: $value");
                      provider.searchCrops(value);
                    },
                  ),
                  const SizedBox(height: 34),
                  const BuyerSectionHeader(title: 'Browse Categories'),
                  const SizedBox(height: 14),
                  _categoryGrid(provider),
                  const SizedBox(height: 34),
                  BuyerSectionHeader(
                    title: 'Recommended for You',
                    actionText: 'See more',
                    onActionTap: () {},
                  ),
                  const SizedBox(height: 14),
                  _recommendedCrops(provider),
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
      children: [
        const Icon(Icons.menu, size: 25, color: Color(0xff26342D)),
        const Spacer(),
        const Text(
          'AgriConnect',
          style: TextStyle(
            color: Color(0xff0F5C3A),
            fontWeight: FontWeight.w900,
            fontSize: 21,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none,
            color: Color(0xff26342D),
          ),
        ),
      ],
    );
  }

  Widget _categoryGrid(CropProvider provider){
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.35,
      children: [
        BuyerCategoryCard(
          title: 'Grains',
          subtitle: '120 Listings',
          imageUrl:
          'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=600',
          onTap: () => provider.filterByCategory('Grains'),
        ),
        BuyerCategoryCard(
          title: 'Vegetables',
          subtitle: '85 Listings',
          imageUrl:
          'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600',
          onTap: () => provider.filterByCategory('Vegetables'),
        ),
        BuyerCategoryCard(
          title: 'Fruits',
          subtitle: '64 Listings',
          imageUrl:
          'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=600',
          onTap: () => provider.filterByCategory('Fruits'),
        ),
        BuyerCategoryCard(
          title: 'View All',
          subtitle: '',
          icon: Icons.category_outlined,
          onTap: provider.clearFilters,
        ),
      ],
    );
  }

  Widget _recommendedCrops(CropProvider provider){
    if (provider.isLoading) {
      return const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.errorMessage != null) {
      return SizedBox(
        height: 180,
        child: Center(
          child: Text(
            provider.errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (provider.recommendedCrops.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text('No crops found')),
      );
    }

    return SizedBox(
      height: 245,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: provider.recommendedCrops.length,
        itemBuilder: (context, index) {
          final crop = provider.recommendedCrops[index];

          return Consumer<BuyerFavoriteProvider>(
            builder: (context, favoriteProvider, _) {
              return BuyerCropCard(
                crop: crop,
                isFavorite:
                favoriteProvider.isFavorite(crop.id),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BuyerCropDetailScreen(crop: crop),
                    ),
                  );
                },
                onAddTap: () {},
                onFavoriteTap: () async {
                  await favoriteProvider.toggleFavorite(crop);
                },
              );
            },
          );
        },
      ),
    );
  }
}