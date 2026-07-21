  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';

  import '../../widgets/buyer/buyer_bottom_navbar.dart';
  import '../../providers/buyer_inquiry_provider.dart';
  import '../../providers/language_provider.dart';
  import '../../widgets/inquiry/buyer_inquiry_card.dart';
  import 'buyer_inquiry_detail_screen.dart';
  import 'buyer_farmer_chat_screen.dart';

  class BuyerInquiriesScreen extends StatelessWidget {
    const BuyerInquiriesScreen({super.key});

    static const Color darkGreen = Color(0xFF0E5D3B);
    static const Color lightBackground = Color(0xFFF7FAF7);
    static const Color darkBackground = Color(0xFF0B1410);
    static const Color darkCard = Color(0xFF15251E);
    static const Color lightGreen = Color(0xff9ff2c1);

    bool _isDark(BuildContext context) {
      return Theme.of(context).brightness == Brightness.dark;
    }

    Color _accent(BuildContext context) {
      return _isDark(context) ? lightGreen : darkGreen;
    }

    Color _primaryText(BuildContext context) {
      return _isDark(context) ? Colors.white : const Color(0xFF1F2D25);
    }

    Color _secondaryText(BuildContext context) {
      return _isDark(context) ? Colors.white70 : const Color(0xFF4A5D52);
    }

    @override
    Widget build(BuildContext context) {
      final isDark = _isDark(context);
      final lang = context.watch<LanguageProvider>();

      return Directionality(
          textDirection: lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
        backgroundColor: isDark ? darkBackground : lightBackground,
        bottomNavigationBar: BuyerBottomNavBar(
          currentIndex: 3,
          onTap: (index) => _onNavTap(context, index),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _appBar(context),
              _tabs(),
              Expanded(
                child: Consumer<BuyerInquiryProvider>(
                  builder: (context, provider, _) {
                    final inquiries = provider.filteredInquiries;

                    if (inquiries.isEmpty) {
                      return Center(
                        child: Text(
                          context.watch<LanguageProvider>().t("noInquiriesFound"),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _secondaryText(context),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: inquiries.length,
                      itemBuilder: (context, index) {
                        return BuyerInquiryCard(
                          inquiry: inquiries[index],
                          onViewDetails: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BuyerInquiryDetailScreen(
                                  inquiry: inquiries[index],
                                ),
                              ),
                            );
                          },
                          onMessageFarmer: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BuyerFarmerChatScreen(
                                  inquiry: inquiries[index],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
          ),
      );
    }

    Widget _appBar(BuildContext context) {
      final isDark = _isDark(context);

      return Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: isDark ? darkCard : const Color(0xFFF4F7F5),
          border: Border(
            bottom: BorderSide(
              color: isDark ? Colors.white10 : const Color(0xFFDDE5DF),
            ),
          ),
        ),
        child: Row(
          children: [
            const Spacer(),
              Text(
                context.watch<LanguageProvider>().t("myInquiries"),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _accent(context),
                ),
              ),

            const Spacer(),
          ],
        ),
      );
    }

    void _onNavTap(BuildContext context, int index) {
      if (index == 3) return;

      final routes = <int, String>{
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

    Widget _tabs() {
      return Consumer<BuyerInquiryProvider>(
        builder: (context, provider, _) {
          final isDark = _isDark(context);

          return Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 14),
            decoration: BoxDecoration(
              color: isDark ? darkBackground : lightBackground,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.white10 : const Color(0xFFDDE5DF),
                ),
              ),
            ),
            child: Row(
              children: [
                _tabItem(context, "Active", provider.selectedTab),
                const SizedBox(width: 30),
                _tabItem(context, "Completed", provider.selectedTab),
              ],
            ),
          );
        },
      );
    }

    Widget _tabItem(
        BuildContext context,
        String title,
        String selectedTab,
        ) {
      final isSelected = title == selectedTab;

      return GestureDetector(
        onTap: () {
          context.read<BuyerInquiryProvider>().changeTab(title);
        },
        child: Column(
          children: [
            Text(
              context.watch<LanguageProvider>().tDynamic(title),
              style: TextStyle(
                color: isSelected ? _accent(context) : _primaryText(context),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 2,
              width: 70,
              color: isSelected ? _accent(context) : Colors.transparent,
            ),
          ],
        ),
      );
    }
  }
