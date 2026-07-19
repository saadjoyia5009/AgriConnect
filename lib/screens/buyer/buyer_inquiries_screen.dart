import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/buyer_inquiry_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/buyer/buyer_bottom_navbar.dart';
import '../../widgets/inquiry/buyer_inquiry_card.dart';
import 'buyer_farmer_chat_screen.dart';
import 'buyer_inquiry_detail_screen.dart';

class BuyerInquiriesScreen extends StatefulWidget {
  const BuyerInquiriesScreen({super.key});

  @override
  State<BuyerInquiriesScreen> createState() =>
      _BuyerInquiriesScreenState();
}

class _BuyerInquiriesScreenState
    extends State<BuyerInquiriesScreen> {
  static const Color darkGreen = Color(0xFF0E5D3B);
  static const Color lightBackground = Color(0xFFF7FAF7);
  static const Color darkBackground = Color(0xFF0B1410);
  static const Color darkCard = Color(0xFF15251E);
  static const Color lightGreen = Color(0xff9ff2c1);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context
          .read<BuyerInquiryProvider>()
          .fetchBuyerInquiries();
    });
  }

  bool _isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color _accent(BuildContext context) {
    return _isDark(context) ? lightGreen : darkGreen;
  }

  Color _primaryText(BuildContext context) {
    return _isDark(context)
        ? Colors.white
        : const Color(0xFF1F2D25);
  }

  Color _secondaryText(BuildContext context) {
    return _isDark(context)
        ? Colors.white70
        : const Color(0xFF4A5D52);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _isDark(context);
    final lang = context.watch<LanguageProvider>();

    return Directionality(
      textDirection:
      lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor:
        isDark ? darkBackground : lightBackground,
        bottomNavigationBar: BuyerBottomNavBar(
          currentIndex: 2,
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
                    return _buildContent(
                      context,
                      provider,
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

  Widget _buildContent(
      BuildContext context,
      BuyerInquiryProvider provider,
      ) {
    if (provider.isLoading && provider.allInquiries.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          color: _accent(context),
        ),
      );
    }

    if (
    provider.errorMessage != null &&
        provider.allInquiries.isEmpty
    ) {
      return _errorState(
        context,
        provider.errorMessage!,
      );
    }

    final inquiries = provider.filteredInquiries;

    return RefreshIndicator(
      color: _accent(context),
      onRefresh: provider.fetchBuyerInquiries,
      child: inquiries.isEmpty
          ? _emptyState(context)
          : ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: inquiries.length,
        itemBuilder: (context, index) {
          final inquiry = inquiries[index];

          return BuyerInquiryCard(
            inquiry: inquiry,
            onViewDetails: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      BuyerInquiryDetailScreen(
                        inquiry: inquiry,
                      ),
                ),
              );
            },
            onMessageFarmer: () {
              if (!inquiry.chatAvailable) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Chat is not available yet.",
                    ),
                  ),
                );
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      BuyerFarmerChatScreen(
                        inquiry: inquiry,
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _errorState(
      BuildContext context,
      String message,
      ) {
    return RefreshIndicator(
      color: _accent(context),
      onRefresh: () {
        return context
            .read<BuyerInquiryProvider>()
            .fetchBuyerInquiries();
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.2,
          ),
          Icon(
            Icons.error_outline,
            size: 58,
            color: _isDark(context)
                ? Colors.red.shade200
                : Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _secondaryText(context),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                context
                    .read<BuyerInquiryProvider>()
                    .fetchBuyerInquiries();
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.2,
        ),
        Icon(
          Icons.mark_email_unread_outlined,
          size: 62,
          color: _accent(context),
        ),
        const SizedBox(height: 16),
        Text(
          context
              .watch<LanguageProvider>()
              .t("noInquiriesFound"),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: _secondaryText(context),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Pull down to refresh",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: _secondaryText(context),
          ),
        ),
      ],
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
            color: isDark
                ? Colors.white10
                : const Color(0xFFDDE5DF),
          ),
        ),
      ),
      child: Row(
        children: [
          const Spacer(),
          Text(
            context
                .watch<LanguageProvider>()
                .t("myInquiries"),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: _accent(context),
            ),
          ),
          const Spacer(),
          Consumer<BuyerInquiryProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _accent(context),
                  ),
                );
              }

              return IconButton(
                tooltip: "Refresh",
                onPressed: provider.fetchBuyerInquiries,
                icon: Icon(
                  Icons.refresh,
                  color: _accent(context),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
    return Consumer<BuyerInquiryProvider>(
      builder: (context, provider, _) {
        final isDark = _isDark(context);

        return Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 14,
          ),
          decoration: BoxDecoration(
            color:
            isDark ? darkBackground : lightBackground,
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? Colors.white10
                    : const Color(0xFFDDE5DF),
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _tabItem(
                  context,
                  "Active",
                  provider.selectedTab,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _tabItem(
                  context,
                  "Completed",
                  provider.selectedTab,
                ),
              ),
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

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        context
            .read<BuyerInquiryProvider>()
            .changeTab(title);
      },
      child: Column(
        children: [
          Text(
            context
                .watch<LanguageProvider>()
                .tDynamic(title),
            style: TextStyle(
              color: isSelected
                  ? _accent(context)
                  : _primaryText(context),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 2,
            width: double.infinity,
            color: isSelected
                ? _accent(context)
                : Colors.transparent,
          ),
        ],
      ),
    );
  }

  void _onNavTap(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(
        context,
        '/buyerDashboard',
      );
    } else if (index == 1) {
      Navigator.pushReplacementNamed(
        context,
        '/buyerFavorites',
      );
    } else if (index == 2) {
      return;
    } else if (index == 3) {
      Navigator.pushReplacementNamed(
        context,
        '/buyerProfile',
      );
    }
  }
}