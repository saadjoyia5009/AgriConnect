import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/responsive/app_breakpoints.dart';
import '../../core/responsive/responsive_layout.dart';

import '../../providers/crop_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/buyer_favorite_provider.dart';

import '../../widgets/buyer/buyer_bottom_navbar.dart';
import '../../widgets/buyer/buyer_crop_card.dart';
import '../../widgets/buyer/buyer_search_bar.dart';
import '../../widgets/buyer/buyer_section_header.dart';
import '../../widgets/buyer/buyer_promo_carousel.dart';
import '../../widgets/buyer/buyer_favorites_preview.dart';
import '../../widgets/buyer/buyer_category_card.dart';

import 'buyer_notification_screen.dart';
import 'buyer_crop_detail_screen.dart';

class BuyerDashboardScreen extends StatefulWidget {
  const BuyerDashboardScreen({
    super.key,
  });

  @override
  State<BuyerDashboardScreen> createState() =>
      _BuyerDashboardScreenState();
}

class _BuyerDashboardScreenState
    extends State<BuyerDashboardScreen> {
  static const Color darkGreen =
  Color(0xff0F5C3A);

  static const Color lightGreen =
  Color(0xff9ff2c1);

  static const Color lightBackground =
  Color(0xffF7FAF7);

  static const Color darkBackground =
  Color(0xff0B1410);

  bool get isDark =>
      Theme.of(context).brightness ==
          Brightness.dark;

  Color get accentColor =>
      isDark ? lightGreen : darkGreen;

  Color get primaryText =>
      isDark
          ? Colors.white
          : const Color(0xff18211C);

  Color get secondaryText =>
      isDark
          ? Colors.white70
          : const Color(0xff66716B);

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<CropProvider>()
          .fetchMarketplaceCrops();
    });
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void _onNavTap(int index) {
    if (index == 0) return;

    final routes = {
      0: '/buyerDashboard',
      1: '/buyerBrowse',
      2: '/buyerChats',
      3: '/buyer-inquiries',
      4: '/buyerProfile',
    };

    final route = routes[index];

    if (route != null) {
      Navigator.pushReplacementNamed(
        context,
        route,
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final lang =
    context.watch<LanguageProvider>();

    return Directionality(
      textDirection: lang.isUrdu
          ? TextDirection.rtl
          : TextDirection.ltr,

      child: Scaffold(
        backgroundColor: isDark
            ? darkBackground
            : lightBackground,

        bottomNavigationBar:
        BuyerBottomNavBar(
          currentIndex: 0,
          onTap: _onNavTap,
        ),

        body: ResponsiveLayout(
          child: SafeArea(
            bottom: false,

            child: Consumer<CropProvider>(
              builder: (
                  context,
                  provider,
                  _,
                  ) {
                return SingleChildScrollView(
                  physics:
                  const BouncingScrollPhysics(),

                  padding:
                  const EdgeInsets.fromLTRB(
                    18,
                    12,
                    18,
                    110,
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      // ==================================================
                      // HEADER
                      // ==================================================

                      _buildTopHeader(
                        context,
                        lang,
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // ==================================================
                      // SEARCH
                      // ==================================================

                      BuyerSearchBar(
                        hintText: lang.t(
                          "searchCropsSellers",
                        ),
                        onChanged:
                        provider.searchCrops,
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      // ==================================================
                      // PROMOTIONAL CAROUSEL
                      // ==================================================

                      BuyerPromoCarousel(
                        onBrowseTap: () {
                          provider.clearFilters();
                        },
                      ),

                      const SizedBox(
                        height: 26,
                      ),

                      // ==================================================
                      // BROWSE CATEGORIES
                      // ==================================================

                      BuyerSectionHeader(
                        title: lang.t(
                          "browseCategories",
                        ),
                      ),

                      const SizedBox(
                        height: 13,
                      ),

                      _categoryList(
                        provider,
                        lang,
                      ),

                      const SizedBox(
                        height: 27,
                      ),

                      // ==================================================
                      // RECOMMENDED CROPS
                      // ==================================================

                      BuyerSectionHeader(
                        title: lang.t("recommendedForYou"),
                        actionText: lang.t("seeMore"),
                        onActionTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/buyerBrowse',
                          );
                        },
                      ),

                      const SizedBox(
                        height: 14,
                      ),

                      _recommendedCrops(
                        provider,
                        lang,
                      ),

                      const SizedBox(
                        height: 26,
                      ),

                      // ==================================================
                      // MY FAVORITES
                      // ==================================================

                      BuyerFavoritesPreview(
                        crops:
                        provider.recommendedCrops,

                        onViewAll: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/buyerFavorites',
                          );
                        },
                      ),
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

  // ============================================================
  // PREMIUM HEADER
  // ============================================================

  Widget _buildTopHeader(
      BuildContext context,
      LanguageProvider lang,
      ) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.center,

      children: [

        // ----------------------------------------------------------
        // MENU BUTTON
        // ----------------------------------------------------------

        _roundHeaderButton(
          icon: Icons.menu_rounded,

          onTap: () {
            Scaffold.of(context)
                .openDrawer();
          },
        ),

        const SizedBox(
          width: 13,
        ),

        // ----------------------------------------------------------
        // GREETING
        // ----------------------------------------------------------

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Text(
                _greetingText(lang),

                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,

                style:
                GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight:
                  FontWeight.w600,
                  color:
                  secondaryText,
                ),
              ),

              const SizedBox(
                height: 2,
              ),

              Text(
                lang.t(
                  "buyerGreeting",
                ),

                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,

                style:
                GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight:
                  FontWeight.w900,
                  color:
                  primaryText,
                ),
              ),

              const SizedBox(
                height: 2,
              ),

              Text(
                lang.t(
                  "buyerDashboardSubtitle",
                ),

                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,

                style:
                GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight:
                  FontWeight.w500,
                  color:
                  secondaryText,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(
          width: 10,
        ),

        // ----------------------------------------------------------
        // NOTIFICATION
        // ----------------------------------------------------------

        _notificationButton(
          context,
        ),
      ],
    );
  }

  // ============================================================
  // GREETING
  // ============================================================

  String _greetingText(
      LanguageProvider lang,
      ) {
    final hour =
        DateTime.now().hour;

    if (hour < 12) {
      return lang.t(
        "goodMorning",
      );
    }

    if (hour < 17) {
      return lang.t(
        "goodAfternoon",
      );
    }

    return lang.t(
      "goodEvening",
    );
  }

  // ============================================================
  // HEADER BUTTON
  // ============================================================

  Widget _roundHeaderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color:
      Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius:
        BorderRadius.circular(
          18,
        ),

        child: Container(
          height: 48,
          width: 48,

          decoration:
          BoxDecoration(
            color: isDark
                ? const Color(
              0xff16271F,
            )
                : Colors.white,

            borderRadius:
            BorderRadius.circular(
              18,
            ),

            border: Border.all(
              color: isDark
                  ? Colors.white10
                  : const Color(
                0xffE4ECE6,
              ),
            ),

            boxShadow: [
              BoxShadow(
                color:
                Colors.black.withValues(
                  alpha:
                  isDark
                      ? 0.18
                      : 0.045,
                ),
                blurRadius: 14,
                offset:
                const Offset(
                  0,
                  5,
                ),
              ),
            ],
          ),

          child: Icon(
            icon,
            color:
            accentColor,
            size: 25,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // NOTIFICATION BUTTON
  // ============================================================

  Widget _notificationButton(
      BuildContext context,
      ) {
    return Material(
      color:
      Colors.transparent,

      child: InkWell(
        borderRadius:
        BorderRadius.circular(
          18,
        ),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const BuyerNotificationScreen(),
            ),
          );
        },

        child: Stack(
          clipBehavior:
          Clip.none,

          children: [

            Container(
              height: 48,
              width: 48,

              decoration:
              BoxDecoration(
                color: isDark
                    ? const Color(
                  0xff16271F,
                )
                    : Colors.white,

                borderRadius:
                BorderRadius.circular(
                  18,
                ),

                border:
                Border.all(
                  color: isDark
                      ? Colors.white10
                      : const Color(
                    0xffE4ECE6,
                  ),
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withValues(
                      alpha:
                      isDark
                          ? 0.18
                          : 0.045,
                    ),
                    blurRadius: 14,
                    offset:
                    const Offset(
                      0,
                      5,
                    ),
                  ),
                ],
              ),

              child: Icon(
                Icons
                    .notifications_none_rounded,
                color:
                accentColor,
                size: 25,
              ),
            ),

            // Notification badge

          ],
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORIES
  // ============================================================

  Widget _categoryList(
      CropProvider provider,
      LanguageProvider lang,
      ) {
    return SizedBox(
      height: 118,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          // ALL CROPS
          SizedBox(
            width: 105,
            child: BuyerCategoryCard(
              title: lang.isUrdu
                  ? "تمام فصلیں"
                  : "All Crops",
              subtitle: "",
              icon: Icons.eco_rounded,
              onTap: provider.clearFilters,
            ),
          ),

          const SizedBox(width: 10),

          // VEGETABLES
          SizedBox(
            width: 105,
            child: BuyerCategoryCard(
              title: lang.t("vegetables"),
              subtitle: "",
              icon: Icons.local_florist_rounded,
              onTap: () {
                provider.filterByCategory(
                  "Vegetables",
                );
              },
            ),
          ),

          const SizedBox(width: 10),

          // FRUITS
          SizedBox(
            width: 105,
            child: BuyerCategoryCard(
              title: lang.t("fruits"),
              subtitle: "",
              icon: Icons.apple_rounded,
              onTap: () {
                provider.filterByCategory(
                  "Fruits",
                );
              },
            ),
          ),

          const SizedBox(width: 11),

          // GRAINS
          SizedBox(
            width: 105,
            child: BuyerCategoryCard(
              title: lang.t("grains"),
              subtitle: "",
              icon: Icons.grass_rounded,
              onTap: () {
                provider.filterByCategory(
                  "Grains",
                );
              },
            ),
          ),

          const SizedBox(width: 10),

          // PULSES
          SizedBox(
            width: 105,
            child: BuyerCategoryCard(
              title: lang.isUrdu
                  ? "دالیں"
                  : "Pulses",
              subtitle: "",
              icon: Icons.spa_rounded,
              onTap: () {
                provider.filterByCategory(
                  "Pulses",
                );
              },
            ),
          ),

          const SizedBox(width: 10),

          // MORE
          SizedBox(
            width: 105,
            child: BuyerCategoryCard(
              title: lang.isUrdu
                  ? "مزید"
                  : "More",
              subtitle: "",
              icon: Icons.grid_view_rounded,
              onTap: provider.clearFilters,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RECOMMENDED CROPS
  // ============================================================

  Widget _recommendedCrops(
      CropProvider provider,
      LanguageProvider lang,
      ) {
    // ------------------------------------------------------------
    // LOADING
    // ------------------------------------------------------------

    if (provider.isLoading) {
      return SizedBox(
        height: 245,

        child: Center(
          child:
          CircularProgressIndicator(
            color:
            accentColor,
          ),
        ),
      );
    }

    // ------------------------------------------------------------
    // ERROR
    // ------------------------------------------------------------

    if (provider.errorMessage !=
        null) {
      return SizedBox(
        height: 180,

        child: Center(
          child: Text(
            lang.tDynamic(
              provider
                  .errorMessage!,
            ),

            textAlign:
            TextAlign.center,

            style: TextStyle(
              color: isDark
                  ? Colors.red.shade200
                  : Colors.red,

              fontWeight:
              FontWeight.w600,

              fontFamily:
              lang.isUrdu
                  ? 'NotoNastaliqUrdu'
                  : null,
            ),
          ),
        ),
      );
    }

    // ------------------------------------------------------------
    // EMPTY
    // ------------------------------------------------------------

    if (provider
        .recommendedCrops
        .isEmpty) {
      return SizedBox(
        height: 180,

        child: Center(
          child: Text(
            lang.t(
              "noCropsFound",
            ),

            textAlign:
            TextAlign.center,

            style: TextStyle(
              color:
              secondaryText,

              fontWeight:
              FontWeight.w600,
            ),
          ),
        ),
      );
    }

    // ------------------------------------------------------------
    // CROP CARD
    // ------------------------------------------------------------

    Widget cardAt(
        int index,
        ) {
      final crop =
      provider
          .recommendedCrops[index];

      return Consumer<
          BuyerFavoriteProvider>(
        builder: (
            context,
            favoriteProvider,
            _,
            ) {
          return BuyerCropCard(
            crop: crop,

            isFavorite:
            favoriteProvider
                .isFavorite(
              crop.id,
            ),

            // Existing crop detail navigation
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      BuyerCropDetailScreen(
                        crop: crop,
                      ),
                ),
              );
            },

            // Existing add action
            onAddTap: () {},

            // Existing favorite logic
            onFavoriteTap:
                () async {
              await favoriteProvider
                  .toggleFavorite(
                crop,
              );
            },
          );
        },
      );
    }

    // ------------------------------------------------------------
    // MOBILE
    // ------------------------------------------------------------

    if (AppBreakpoints.isMobile(
      context,
    )) {
      return SizedBox(
        height: 245,

        child: ListView.builder(
          scrollDirection:
          Axis.horizontal,

          reverse:
          lang.isUrdu,

          physics:
          const BouncingScrollPhysics(),

          itemCount: provider
              .recommendedCrops
              .length,

          itemBuilder:
              (context, index) {
            return Padding(
              padding:
              EdgeInsetsDirectional.only(
                end: 14,
              ),

              child:
              cardAt(index),
            );
          },
        ),
      );
    }

    // ------------------------------------------------------------
    // TABLET / DESKTOP
    // ------------------------------------------------------------

    return ResponsiveGrid(
      mobileColumns: 1,
      tabletColumns: 3,
      desktopColumns: 4,
      wideDesktopColumns: 4,

      spacing: 16,

      childAspectRatio:
      .78,

      children:
      List.generate(
        provider
            .recommendedCrops
            .length,
        cardAt,
      ),
    );
  }
}