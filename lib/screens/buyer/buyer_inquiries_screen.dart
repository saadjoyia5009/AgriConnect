import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/buyer/buyer_bottom_navbar.dart';
import '../../providers/buyer_inquiry_provider.dart';
import '../../widgets/inquiry/buyer_inquiry_card.dart';

class BuyerInquiriesScreen extends StatelessWidget {
  const BuyerInquiriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BuyerInquiryProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7FAF7),

        bottomNavigationBar: BuyerBottomNavBar(
          currentIndex: 2,
          onTap: (index) => _onNavTap(context, index),
        ),

        body: SafeArea(
          child: Column(
            children: [
              _appBar(),
              _tabs(),
              Expanded(
                child: Consumer<BuyerInquiryProvider>(
                  builder: (context, provider, _) {
                    final inquiries = provider.filteredInquiries;

                    if (inquiries.isEmpty) {
                      return const Center(
                        child: Text(
                          "No inquiries found",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4A5D52),
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
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget _appBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
        color: Color(0xFFF4F7F5),
        border: Border(
          bottom: BorderSide(color: Color(0xFFDDE5DF)),
        ),
      ),
      child: Row(
        children: const [
          Icon(Icons.menu, color: Color(0xFF0E5D3B)),
          SizedBox(width: 22),
          Expanded(
            child: Text(
              "My Inquiries",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0E4F35),
              ),
            ),
          ),
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300",
            ),
          ),
        ],
      ),
    );
  }

  void _onNavTap(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/buyerDashboard');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/buyerFavorites');
    } else if (index == 2) {
      return;
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/buyerProfile');
    }
  }

  Widget _tabs() {
    return Consumer<BuyerInquiryProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 14),
          decoration: const BoxDecoration(
            color: Color(0xFFF7FAF7),
            border: Border(
              bottom: BorderSide(color: Color(0xFFDDE5DF)),
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
            title,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF0E5D3B)
                  : const Color(0xFF1F2D25),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 2,
            width: 70,
            color: isSelected ? const Color(0xFF0E5D3B) : Colors.transparent,
          ),
        ],
      ),
    );
  }
}