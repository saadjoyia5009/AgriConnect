import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/responsive/app_breakpoints.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../providers/crop_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/buyer_favorite_provider.dart';
import '../../widgets/buyer/buyer_bottom_navbar.dart';
import '../../widgets/buyer/buyer_category_card.dart';
import '../../widgets/buyer/buyer_crop_card.dart';
import '../../widgets/buyer/buyer_search_bar.dart';
import '../../widgets/buyer/buyer_section_header.dart';
import 'buyer_notification_screen.dart';
import 'buyer_crop_detail_screen.dart';

class BuyerDashboardScreen extends StatefulWidget {
  const BuyerDashboardScreen({super.key});

  @override
  State<BuyerDashboardScreen> createState() => _BuyerDashboardScreenState();
}

class _BuyerDashboardScreenState extends State<BuyerDashboardScreen> {
  static const Color darkGreen = Color(0xff0F5C3A);
  static const Color lightBackground = Color(0xffF8FAF7);
  static const Color darkBackground = Color(0xFF0B1410);
  static const Color lightGreen = Color(0xff9ff2c1);

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get accentColor => isDark ? lightGreen : darkGreen;
  Color get primaryText => isDark ? Colors.white : const Color(0xff1F2722);
  Color get secondaryText => isDark ? Colors.white70 : const Color(0xff5F675F);
  Color get iconColor => isDark ? Colors.white70 : const Color(0xff26342D);

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CropProvider>().fetchMarketplaceCrops();
    });
  }

  void _onNavTap(int index) {
    if (index == 0) return;

    final routes = {
      0: '/buyerDashboard',
      1: '/buyerFavorites',
      2: '/buyerChats',
      3: '/buyer-inquiries',
      4: '/buyerProfile',
    };

    final route = routes[index];
    if (route != null) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Directionality(
      textDirection: lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: isDark ? darkBackground : lightBackground,
        bottomNavigationBar: BuyerBottomNavBar(
          currentIndex: 0,
          onTap: _onNavTap,
        ),
        body: ResponsiveLayout(
          child: SafeArea(
            child: Consumer<CropProvider>(
              builder: (context, provider, _) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _topBar(lang),
                      const SizedBox(height: 34),

                      Text(
                        lang.t("buyerGreeting"),
                        textAlign: lang.isUrdu
                            ? TextAlign.right
                            : TextAlign.left,
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          color: primaryText,
                          fontFamily: lang.isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        lang.t("buyerDashboardSubtitle"),
                        textAlign: lang.isUrdu
                            ? TextAlign.right
                            : TextAlign.left,
                        style: TextStyle(
                          fontSize: 15,
                          color: secondaryText,
                          height: 1.5,
                          fontFamily: lang.isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                      ),

                      const SizedBox(height: 16),

                      BuyerSearchBar(
                        hintText: lang.t("searchCropsSellers"),
                        onChanged: provider.searchCrops,
                      ),

                      const SizedBox(height: 34),

                      BuyerSectionHeader(title: lang.t("browseCategories")),

                      const SizedBox(height: 14),

                      _categoryGrid(provider, lang),

                      const SizedBox(height: 34),

                      BuyerSectionHeader(
                        title: lang.t("recommendedForYou"),
                        actionText: lang.t("seeMore"),
                        onActionTap: () {},
                      ),

                      const SizedBox(height: 14),

                      _recommendedCrops(provider, lang),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar(LanguageProvider lang) {
    return Row(
      children: [
        const Spacer(),

        Text(
          lang.t("appName"),
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.w900,
            fontSize: 21,
            fontFamily: lang.isUrdu ? 'NotoNastaliqUrdu' : null,
          ),
        ),

        const Spacer(),

        IconButton(
          tooltip: lang.t("notifications"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const BuyerNotificationScreen(),
              ),
            );
          },
          icon: Icon(Icons.notifications_none, color: iconColor),
        ),
      ],
    );
  }

  Widget _categoryGrid(CropProvider provider, LanguageProvider lang) {
    return ResponsiveGrid(
      mobileColumns: 2,
      tabletColumns: 2,
      desktopColumns: 4,
      wideDesktopColumns: 4,
      spacing: 14,
      childAspectRatio: 1.35,
      children: [
        BuyerCategoryCard(
          title: lang.t("grains"),
          subtitle: lang.t("listingsCount").replaceAll("{count}", "120"),
          imageUrl:
              'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=600',
          onTap: () => provider.filterByCategory('Grains'),
        ),

        BuyerCategoryCard(
          title: lang.t("vegetables"),
          subtitle: lang.t("listingsCount").replaceAll("{count}", "85"),
          imageUrl:
              'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600',
          onTap: () => provider.filterByCategory('Vegetables'),
        ),

        BuyerCategoryCard(
          title: lang.t("fruits"),
          subtitle: lang.t("listingsCount").replaceAll("{count}", "64"),
          imageUrl:
              'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=600',
          onTap: () => provider.filterByCategory('Fruits'),
        ),

        BuyerCategoryCard(
          title: lang.t("viewAll"),
          subtitle: '',
          icon: Icons.category_outlined,
          onTap: provider.clearFilters,
        ),
      ],
    );
  }

  Widget _recommendedCrops(CropProvider provider, LanguageProvider lang) {
    if (provider.isLoading) {
      return SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator(color: accentColor)),
      );
    }

    if (provider.errorMessage != null) {
      return SizedBox(
        height: 180,
        child: Center(
          child: Text(
            lang.tDynamic(provider.errorMessage!),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.red.shade200 : Colors.red,
              fontWeight: FontWeight.w600,
              fontFamily: lang.isUrdu ? 'NotoNastaliqUrdu' : null,
            ),
          ),
        ),
      );
    }

    if (provider.recommendedCrops.isEmpty) {
      return SizedBox(
        height: 180,
        child: Center(
          child: Text(
            lang.t("noCropsFound"),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondaryText,
              fontWeight: FontWeight.w600,
              fontFamily: lang.isUrdu ? 'NotoNastaliqUrdu' : null,
            ),
          ),
        ),
      );
    }

    Widget cardAt(int index) {
      final crop = provider.recommendedCrops[index];

      return Consumer<BuyerFavoriteProvider>(
        builder: (context, favoriteProvider, _) {
          return BuyerCropCard(
            crop: crop,
            isFavorite: favoriteProvider.isFavorite(crop.id),
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
    }

    if (AppBreakpoints.isMobile(context)) {
      return SizedBox(
        height: 245,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          reverse: lang.isUrdu,
          itemCount: provider.recommendedCrops.length,
          itemBuilder: (context, index) => cardAt(index),
        ),
      );
    }

    return ResponsiveGrid(
      mobileColumns: 1,
      tabletColumns: 3,
      desktopColumns: 4,
      wideDesktopColumns: 4,
      spacing: 16,
      childAspectRatio: .78,
      children: List.generate(provider.recommendedCrops.length, cardAt),
    );
  }
}
