import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/inquiry_model.dart';
import '../../providers/inquiry_provider.dart';
import '../../widgets/farmer_bottom_navbar.dart';

class FarmerInquiriesScreen extends StatelessWidget {
  const FarmerInquiriesScreen({super.key});

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final inquiryProvider = Provider.of<InquiryProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xfff9fbfa),
      bottomNavigationBar: const FarmerBottomNavbar(currentIndex: 2),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Received Inquiries",
                      style: TextStyle(
                        color: darkGreen,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Manage and respond to buyer requests for\nyour harvest.",
                      style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 15,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        _filterChip(
                          context,
                          title: "Pending",
                          selected: inquiryProvider.selectedFilter == "Pending",
                        ),
                        const SizedBox(width: 10),
                        _filterChip(
                          context,
                          title: "Active",
                          selected: inquiryProvider.selectedFilter == "Active",
                        ),
                        const SizedBox(width: 10),
                        _filterChip(
                          context,
                          title: "History",
                          selected: inquiryProvider.selectedFilter == "History",
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    ListView.builder(
                      itemCount: inquiryProvider.inquiries.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final inquiry = inquiryProvider.inquiries[index];

                        return _InquiryCard(
                          inquiry: inquiry,
                          onReject: () {
                            inquiryProvider.rejectInquiry(inquiry.id);
                          },
                          onAccept: () {
                            inquiryProvider.acceptInquiry(inquiry.id);
                          },
                        );
                      },
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

  Widget _topBar() {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xffe4eee8)),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.menu, color: darkGreen, size: 25),
          const Expanded(
            child: Center(
              child: Text(
                "AgriConnect",
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          CircleAvatar(
            radius: 17,
            backgroundColor: darkGreen,
            child: ClipOval(
              child: Image.network(
                "https://i.pravatar.cc/100?img=15",
                fit: BoxFit.cover,
                width: 34,
                height: 34,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(
      BuildContext context, {
        required String title,
        required bool selected,
      }) {
    final provider = Provider.of<InquiryProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        provider.changeFilter(title);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? darkGreen : const Color(0xffdff3e8),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : darkGreen,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _InquiryCard extends StatelessWidget {
  final InquiryModel inquiry;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _InquiryCard({
    required this.inquiry,
    required this.onAccept,
    required this.onReject,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffd8e6de)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _imageHeader(),
          _buyerDetails(),
          Divider(color: Colors.grey.shade300, height: 1),
          _priceAndActions(),
        ],
      ),
    );
  }

  Widget _imageHeader() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(12),
          ),
          child: Image.network(
            inquiry.cropImage,
            width: double.infinity,
            height: 125,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: 125,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.60),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Positioned(
          left: 14,
          bottom: 14,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                inquiry.cropName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                inquiry.cropGrade,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xffffcc54).withOpacity(0.85),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              inquiry.status,
              style: const TextStyle(
                color: Color(0xff8a5a00),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buyerDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Row(
        children: [
          Expanded(
            child: _detailBlock(
              title: "Buyer",
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: const Color(0xffb8efcf),
                    child: Text(
                      inquiry.buyerInitials,
                      style: const TextStyle(
                        color: darkGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      inquiry.buyerName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xff222222),
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _detailBlock(
            title: "Requested",
            crossAxisAlignment: CrossAxisAlignment.end,
            child: Text(
              inquiry.requestedQuantity,
              style: const TextStyle(
                color: darkGreen,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceAndActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      child: Row(
        children: [
          Expanded(
            child: _detailBlock(
              title: "Proposed Price",
              child: Text(
                inquiry.proposedPrice,
                style: const TextStyle(
                  color: darkGreen,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          _circleButton(
            icon: Icons.close,
            filled: false,
            onTap: onReject,
          ),
          const SizedBox(width: 12),
          _circleButton(
            icon: Icons.check,
            filled: true,
            onTap: onAccept,
          ),
        ],
      ),
    );
  }

  Widget _detailBlock({
    required String title,
    required Widget child,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xff333333),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        child,
      ],
    );
  }

  Widget _circleButton({
    required IconData icon,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        height: 43,
        width: 43,
        decoration: BoxDecoration(
          color: filled ? darkGreen : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: darkGreen),
        ),
        child: Icon(
          icon,
          color: filled ? Colors.white : darkGreen,
          size: 25,
        ),
      ),
    );
  }
}