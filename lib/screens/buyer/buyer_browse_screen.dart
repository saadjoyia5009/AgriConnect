import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/crop_model.dart';
import '../../providers/crop_provider.dart';
import '../../providers/buyer_favorite_provider.dart';
import '../../providers/language_provider.dart';

import '../../widgets/buyer/buyer_bottom_navbar.dart';
import '../buyer/send_inquiry_screen.dart';
import 'buyer_crop_detail_screen.dart';

class BuyerBrowseScreen extends StatefulWidget {
  const BuyerBrowseScreen({super.key});

  @override
  State<BuyerBrowseScreen> createState() => _BuyerBrowseScreenState();
}

class _BuyerBrowseScreenState extends State<BuyerBrowseScreen> {
  static const Color darkGreen = Color(0xff0F5C3A);

  static const Color lightGreen = Color(0xff9ff2c1);

  static const Color lightBackground = Color(0xffF7FAF7);

  static const Color darkBackground = Color(0xff0B1410);

  static const Color darkCard = Color(0xff14231C);

  String _sortBy = 'recommended';

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get accentColor => isDark ? lightGreen : darkGreen;

  Color get primaryText => isDark ? Colors.white : const Color(0xff10291D);

  Color get secondaryText => isDark ? Colors.white70 : const Color(0xff66716B);

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CropProvider>().fetchMarketplaceCrops();

      context.read<BuyerFavoriteProvider>().fetchFavorites();
    });
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void _onNavTap(int index) {
    final routes = <int, String>{
      0: '/buyerDashboard',
      1: '/buyerBrowse',
      2: '/buyerChats',
      3: '/buyer-inquiries',
      4: '/buyerProfile',
    };

    final route = routes[index];

    if (route == null) return;

    Navigator.pushReplacementNamed(context, route);
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Directionality(
      textDirection: lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,

      child: Scaffold(
        backgroundColor: isDark ? darkBackground : lightBackground,

        bottomNavigationBar: BuyerBottomNavBar(
          // Existing navbar does not contain
          // a Browse item, so we don't fake
          // an incorrect active tab.
          currentIndex: 0,
          onTap: _onNavTap,
        ),

        body: SafeArea(
          bottom: false,

          child: Consumer<CropProvider>(
            builder: (context, provider, _) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),

                slivers: [
                  SliverToBoxAdapter(child: _buildHeader(lang)),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                      child: _buildSearchSection(provider, lang),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: _buildCategories(provider, lang),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 24, 18, 14),
                      child: _buildListingHeader(provider, lang),
                    ),
                  ),

                  _buildCropGrid(provider, lang),

                  const SliverToBoxAdapter(child: SizedBox(height: 110)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(LanguageProvider lang) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 4),

      child: Row(
        children: [
          // _headerIconButton(
          //   icon: Icons.arrow_back_rounded,
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  lang.isUrdu ? 'فصلیں براؤز کریں' : 'Browse Crops',

                  style: GoogleFonts.outfit(
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                    color: primaryText,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  lang.isUrdu
                      ? 'قابلِ اعتماد کسانوں سے تازہ فصلیں دریافت کریں'
                      : 'Discover fresh crops from trusted farmers',

                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: GoogleFonts.outfit(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          _headerIconButton(
            icon: Icons.favorite_rounded,
            onTap: () {
              Navigator.pushNamed(context, '/buyerFavorites');
            },
          ),
        ],
      ),
    );
  }

  Widget _headerIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(18),

        child: Container(
          height: 52,
          width: 52,

          decoration: BoxDecoration(
            color: isDark ? darkCard : Colors.white,

            borderRadius: BorderRadius.circular(18),

            border: Border.all(
              color: isDark ? Colors.white10 : const Color(0xffE2EBE4),
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.035),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),

          child: Icon(icon, color: accentColor, size: 25),
        ),
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearchSection(CropProvider provider, LanguageProvider lang) {
    return Container(
      height: 58,

      decoration: BoxDecoration(
        color: isDark ? darkCard : Colors.white,

        borderRadius: BorderRadius.circular(30),

        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xffDDE9E0),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.16 : 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: TextField(
        onChanged: provider.searchCrops,

        textAlignVertical: TextAlignVertical.center,

        style: TextStyle(
          color: primaryText,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),

        cursorColor: accentColor,

        decoration: InputDecoration(
          border: InputBorder.none,

          hintText: lang.isUrdu
              ? 'فصل، پھل یا سبزی تلاش کریں...'
              : 'Search crops, fruits, vegetables...',

          hintStyle: TextStyle(
            color: secondaryText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),

          prefixIcon: Icon(
            Icons.search_rounded,
            size: 27,
            color: isDark ? Colors.white60 : const Color(0xff68756E),
          ),

          contentPadding: const EdgeInsets.symmetric(vertical: 17),
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORIES
  // ============================================================

  Widget _buildCategories(CropProvider provider, LanguageProvider lang) {
    final categories = [
      _CategoryData(
        key: 'All Crops',
        title: lang.isUrdu ? 'تمام فصلیں' : 'All Crops',
        icon: Icons.eco_rounded,
      ),
      _CategoryData(
        key: 'Vegetables',
        title: lang.t("vegetables"),
        icon: Icons.local_florist_rounded,
      ),
      _CategoryData(
        key: 'Fruits',
        title: lang.t("fruits"),
        icon: Icons.apple_rounded,
      ),
      _CategoryData(
        key: 'Grains',
        title: lang.t("grains"),
        icon: Icons.grass_rounded,
      ),
      _CategoryData(
        key: 'Pulses',
        title: lang.isUrdu ? 'دالیں' : 'Pulses',
        icon: Icons.spa_rounded,
      ),
      _CategoryData(
        key: 'More',
        title: lang.isUrdu ? 'مزید' : 'More',
        icon: Icons.grid_view_rounded,
      ),
    ];

    return SizedBox(
      height: 92,

      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 18),

        scrollDirection: Axis.horizontal,

        physics: const BouncingScrollPhysics(),

        itemCount: categories.length,

        separatorBuilder: (_, __) => const SizedBox(width: 10),

        itemBuilder: (context, index) {
          final category = categories[index];

          return _categoryItem(category: category, provider: provider);
        },
      ),
    );
  }

  Widget _categoryItem({
    required _CategoryData category,
    required CropProvider provider,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: () {
          if (category.key == 'All Crops' || category.key == 'More') {
            provider.clearFilters();
          } else {
            provider.filterByCategory(category.key);
          }
        },

        borderRadius: BorderRadius.circular(24),

        child: Container(
          width: 94,

          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),

          decoration: BoxDecoration(
            color: isDark ? darkCard : Colors.white,

            borderRadius: BorderRadius.circular(24),

            border: Border.all(
              color: category.key == 'All Crops'
                  ? accentColor
                  : (isDark ? Colors.white10 : const Color(0xffDDE9E0)),
              width: category.key == 'All Crops' ? 1.5 : 1,
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.025),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                height: 39,
                width: 39,

                decoration: BoxDecoration(
                  color: category.key == 'All Crops'
                      ? darkGreen
                      : (isDark
                            ? const Color(0xff1D3A2D)
                            : const Color(0xffE7F6EC)),
                  shape: BoxShape.circle,
                ),

                child: Icon(
                  category.icon,
                  size: 21,
                  color: category.key == 'All Crops'
                      ? Colors.white
                      : (isDark ? lightGreen : darkGreen),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                category.title,

                maxLines: 1,
                overflow: TextOverflow.ellipsis,

                textAlign: TextAlign.center,

                style: TextStyle(
                  color: primaryText,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LISTING HEADER
  // ============================================================

  Widget _buildListingHeader(CropProvider provider, LanguageProvider lang) {
    final count = provider.recommendedCrops.length;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                lang.isUrdu ? 'تمام فصلیں' : 'All Crops',

                style: GoogleFonts.outfit(
                  color: primaryText,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                lang.isUrdu
                    ? '$count فصلیں دستیاب ہیں'
                    : '$count crops available',

                style: GoogleFonts.outfit(
                  color: secondaryText,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        _sortButton(lang),

        const SizedBox(width: 8),

        Container(
          height: 43,
          width: 43,

          decoration: BoxDecoration(
            color: darkGreen,

            borderRadius: BorderRadius.circular(13),
          ),

          child: const Icon(
            Icons.grid_view_rounded,
            color: Colors.white,
            size: 21,
          ),
        ),
      ],
    );
  }

  Widget _sortButton(LanguageProvider lang) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: () {
          _showSortSheet(lang);
        },

        borderRadius: BorderRadius.circular(14),

        child: Container(
          height: 43,

          padding: const EdgeInsets.symmetric(horizontal: 12),

          decoration: BoxDecoration(
            color: isDark ? darkCard : Colors.white,

            borderRadius: BorderRadius.circular(14),

            border: Border.all(
              color: isDark ? Colors.white10 : const Color(0xffE1E9E3),
            ),
          ),

          child: Row(
            children: [
              Text(
                lang.isUrdu ? 'ترتیب' : 'Sort',

                style: TextStyle(
                  color: primaryText,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(width: 4),

              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: secondaryText,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CROP GRID
  // ============================================================

  Widget _buildCropGrid(CropProvider provider, LanguageProvider lang) {
    if (provider.isLoading) {
      return SliverFillRemaining(
        hasScrollBody: false,

        child: SizedBox(
          height: 400,

          child: Center(child: CircularProgressIndicator(color: accentColor)),
        ),
      );
    }

    if (provider.errorMessage != null) {
      return SliverToBoxAdapter(child: _buildErrorState(provider, lang));
    }

    final crops = List<CropModel>.from(provider.recommendedCrops);

    _sortCrops(crops);

    if (crops.isEmpty) {
      return SliverToBoxAdapter(child: _buildEmptyState(lang));
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 18),

      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final crop = crops[index];

          return Consumer<BuyerFavoriteProvider>(
            builder: (context, favoriteProvider, _) {
              return _BrowseCropCard(
                crop: crop,

                isFavorite: favoriteProvider.isFavorite(crop.id),

                onFavoriteTap: () async {
                  await favoriteProvider.toggleFavorite(crop);
                },

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BuyerCropDetailScreen(crop: crop),
                    ),
                  );
                },

                onInquiryTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SendInquiryScreen(crop: crop),
                    ),
                  );
                },
              );
            },
          );
        }, childCount: crops.length),

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,

          crossAxisSpacing: 12,

          mainAxisSpacing: 14,

          childAspectRatio: 0.78,
        ),
      ),
    );
  }

  // ============================================================
  // SORT
  // ============================================================

  void _sortCrops(List<CropModel> crops) {
    if (_sortBy == 'priceLow') {
      crops.sort((a, b) => _priceValue(a).compareTo(_priceValue(b)));
    } else if (_sortBy == 'priceHigh') {
      crops.sort((a, b) => _priceValue(b).compareTo(_priceValue(a)));
    }
  }

  double _priceValue(CropModel crop) {
    return double.tryParse(crop.price.toString()) ?? 0;
  }

  void _showSortSheet(LanguageProvider lang) {
    showModalBottomSheet(
      context: context,

      backgroundColor: isDark ? darkCard : Colors.white,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),

      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Container(
                  width: 42,
                  height: 4,

                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  lang.isUrdu ? 'فصلوں کو ترتیب دیں' : 'Sort Crops',

                  style: TextStyle(
                    color: primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 12),

                _sortOption(
                  value: 'recommended',
                  title: lang.isUrdu ? 'تجویز کردہ' : 'Recommended',
                ),

                _sortOption(
                  value: 'priceLow',
                  title: lang.isUrdu
                      ? 'قیمت: کم سے زیادہ'
                      : 'Price: Low to High',
                ),

                _sortOption(
                  value: 'priceHigh',
                  title: lang.isUrdu
                      ? 'قیمت: زیادہ سے کم'
                      : 'Price: High to Low',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sortOption({required String value, required String title}) {
    final selected = _sortBy == value;

    return ListTile(
      contentPadding: EdgeInsets.zero,

      onTap: () {
        setState(() {
          _sortBy = value;
        });

        Navigator.pop(context);
      },

      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off,

        color: selected ? accentColor : secondaryText,
      ),

      title: Text(
        title,

        style: TextStyle(
          color: primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildErrorState(CropProvider provider, LanguageProvider lang) {
    return Padding(
      padding: const EdgeInsets.all(30),

      child: Column(
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 48,
            color: isDark ? Colors.red.shade200 : Colors.red,
          ),

          const SizedBox(height: 12),

          Text(
            lang.tDynamic(provider.errorMessage!),

            textAlign: TextAlign.center,

            style: TextStyle(
              color: secondaryText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 15),

          OutlinedButton(
            onPressed: () {
              provider.fetchMarketplaceCrops();
            },

            style: OutlinedButton.styleFrom(
              foregroundColor: accentColor,

              side: BorderSide(color: accentColor),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),

            child: Text(lang.isUrdu ? 'دوبارہ کوشش کریں' : 'Retry'),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmptyState(LanguageProvider lang) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 55, 20, 30),

      child: Column(
        children: [
          Container(
            height: 80,
            width: 80,

            decoration: BoxDecoration(
              color: isDark ? const Color(0xff193326) : const Color(0xffE8F6EC),
              shape: BoxShape.circle,
            ),

            child: Icon(
              Icons.agriculture_rounded,
              size: 40,
              color: accentColor,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            lang.isUrdu ? 'کوئی فصل نہیں ملی' : 'No crops found',

            style: TextStyle(
              color: primaryText,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            lang.isUrdu
                ? 'اس وقت کوئی فصل دستیاب نہیں۔'
                : 'There are no crops available right now.',

            textAlign: TextAlign.center,

            style: TextStyle(color: secondaryText, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CATEGORY MODEL
// ============================================================

class _CategoryData {
  final String key;
  final String title;
  final IconData icon;

  const _CategoryData({
    required this.key,
    required this.title,
    required this.icon,
  });
}

// ============================================================
// BROWSE CROP CARD
// ============================================================

class _BrowseCropCard extends StatelessWidget {
  final CropModel crop;
  final bool isFavorite;

  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onInquiryTap;

  const _BrowseCropCard({
    required this.crop,
    required this.isFavorite,
    this.onTap,
    this.onFavoriteTap,
    this.onInquiryTap,
  });

  static const Color darkGreen = Color(0xff0F5C3A);

  static const Color lightGreen = Color(0xff9ff2c1);

  static const Color darkCard = Color(0xff14231C);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final lang = context.watch<LanguageProvider>();

    return GestureDetector(
      onTap: onTap,

      child: Container(
        decoration: BoxDecoration(
          color: isDark ? darkCard : Colors.white,

          borderRadius: BorderRadius.circular(24),

          border: Border.all(
            color: isDark ? Colors.white10 : const Color(0xffE3ECE6),
            width: 1,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.24 : 0.055),
              blurRadius: 20,
              spreadRadius: -4,
              offset: const Offset(0, 9),
            ),
          ],
        ),

        clipBehavior: Clip.antiAlias,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ----------------------------------------------------
            // IMAGE
            // ----------------------------------------------------
            SizedBox(
              height: 126,
              width: double.infinity,

              child: Stack(
                fit: StackFit.expand,

                children: [
                  Image.network(
                    crop.imageUrl,

                    fit: BoxFit.cover,

                    errorBuilder: (_, __, ___) {
                      return Container(
                        color: isDark
                            ? const Color(0xff1D3027)
                            : const Color(0xffEAF4ED),

                        child: Icon(
                          Icons.agriculture_rounded,
                          size: 45,
                          color: darkGreen,
                        ),
                      );
                    },
                  ),

                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.50),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ORGANIC
                  if (crop.isOrganic)
                    Positioned(
                      left: 9,
                      top: 9,

                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),

                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            const Icon(
                              Icons.eco_rounded,
                              size: 13,
                              color: darkGreen,
                            ),

                            const SizedBox(width: 4),

                            Text(
                              lang.t("organic"),

                              style: const TextStyle(
                                color: darkGreen,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // FAVORITE
                  Positioned(
                    right: 9,
                    top: 9,

                    child: GestureDetector(
                      onTap: onFavoriteTap,

                      child: Container(
                        height: 35,
                        width: 35,

                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.96),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.10),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),

                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,

                          color: isFavorite ? Colors.red : darkGreen,

                          size: 19,
                        ),
                      ),
                    ),
                  ),

                  // CROP NAME
                  Positioned(
                    left: 11,
                    right: 8,
                    bottom: 9,

                    child: Text(
                      crop.name,

                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ----------------------------------------------------
            // DETAILS
            // ----------------------------------------------------
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(11, 8, 11, 9),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      lang.isUrdu ? 'تازہ فصل' : 'Farm Fresh',

                      maxLines: 1,

                      style: TextStyle(
                        color: isDark
                            ? Colors.white60
                            : const Color(0xff68746D),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,

                          size: 14,

                          color: isDark
                              ? Colors.white54
                              : const Color(0xff6D7972),
                        ),

                        const SizedBox(width: 3),

                        Expanded(
                          child: Text(
                            crop.location,

                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,

                            style: TextStyle(
                              color: isDark
                                  ? Colors.white70
                                  : const Color(0xff66716B),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // PRICE + INQUIRE
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Rs. ${crop.price}',

                                  style: TextStyle(
                                    color: isDark ? lightGreen : darkGreen,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),

                                TextSpan(
                                  text: ' ${lang.tDynamic(crop.unit)}',

                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white60
                                        : const Color(0xff68746D),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 5),

                        GestureDetector(
                          onTap: onInquiryTap,

                          child: Container(
                            height: 35,

                            padding: const EdgeInsets.symmetric(horizontal: 9),

                            decoration: BoxDecoration(
                              color: darkGreen,

                              borderRadius: BorderRadius.circular(12),
                            ),

                            child: Row(
                              mainAxisSize: MainAxisSize.min,

                              children: [
                                const Icon(
                                  Icons.chat_bubble_outline_rounded,

                                  color: Colors.white,

                                  size: 14,
                                ),

                                const SizedBox(width: 4),

                                Text(
                                  lang.isUrdu ? 'رابطہ' : 'Inquire',

                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
}
