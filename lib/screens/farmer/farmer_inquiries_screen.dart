import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/inquiry_model.dart';
import '../../providers/inquiry_provider.dart';
import '../../widgets/farmer_bottom_navbar.dart';
import 'farmer_inquiry_detail_screen.dart';

class FarmerInquiriesScreen extends StatefulWidget {
  const FarmerInquiriesScreen({super.key});

  @override
  State<FarmerInquiriesScreen> createState() => _FarmerInquiriesScreenState();
}

class _FarmerInquiriesScreenState extends State<FarmerInquiriesScreen> {
  static const Color darkGreen = Color(0xff075739);

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<InquiryProvider>().fetchFarmerInquiries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff9fbfa),
      bottomNavigationBar: const FarmerBottomNavbar(currentIndex: 2),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: Consumer<InquiryProvider>(
                builder: (context, inquiryProvider, _) {
                  if (inquiryProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: darkGreen),
                    );
                  }

                  if (inquiryProvider.errorMessage != null) {
                    return _ErrorState(
                      message: inquiryProvider.errorMessage!,
                      onRetry: () {
                        inquiryProvider.fetchFarmerInquiries();
                      },
                    );
                  }

                  return RefreshIndicator(
                    color: darkGreen,
                    onRefresh: () async {
                      await inquiryProvider.fetchFarmerInquiries();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
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
                                selected:
                                inquiryProvider.selectedFilter == "Pending",
                              ),
                              const SizedBox(width: 10),
                              _filterChip(
                                context,
                                title: "Active",
                                selected:
                                inquiryProvider.selectedFilter == "Active",
                              ),
                              const SizedBox(width: 10),
                              _filterChip(
                                context,
                                title: "History",
                                selected:
                                inquiryProvider.selectedFilter == "History",
                              ),
                            ],
                          ),

                          const SizedBox(height: 22),

                          if (inquiryProvider.filteredInquiries.isEmpty)
                            const _EmptyState()
                          else
                            ListView.builder(
                              itemCount:
                              inquiryProvider.filteredInquiries.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final inquiry =
                                inquiryProvider.filteredInquiries[index];

                                return _InquiryCard(
                                  inquiry: inquiry,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FarmerInquiryDetailScreen(
                                          inquiryId: inquiry.id,
                                        ),
                                      ),
                                    );
                                  },
                                  onReject: () async {
                                    await inquiryProvider.rejectInquiry(inquiry.id);
                                  },
                                  onAccept: () async {
                                    await inquiryProvider.acceptInquiry(inquiry.id);
                                  },
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  );
                },
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
          bottom: BorderSide(
            color: Color(0xffe4eee8),
          ),
        ),
      ),
      child: Row(
        children: const [
          Icon(
            Icons.agriculture_outlined,
            color: darkGreen,
            size: 22,
          ),
          Expanded(
            child: Center(
              child: Text(
                "AgriConnect",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff075739),
                ),
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
  final Future<void> Function() onAccept;
  final Future<void> Function() onReject;
  final VoidCallback onTap;

  const _InquiryCard({
    required this.inquiry,
    required this.onAccept,
    required this.onReject,
    required this.onTap,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
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
            _priceAndActions(context),
          ],
        ),
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
            errorBuilder: (_, __, ___) {
              return Container(
                width: double.infinity,
                height: 125,
                color: const Color(0xffe8f3ed),
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  color: darkGreen,
                  size: 38,
                ),
              );
            },
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
              color: _statusColor(inquiry.status).withOpacity(0.90),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              inquiry.status,
              style: const TextStyle(
                color: Colors.white,
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

  Widget _priceAndActions(BuildContext context) {
    final bool isPending = inquiry.status.toLowerCase() == "pending";

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
          if (isPending) ...[
            _circleButton(
              icon: Icons.close,
              filled: false,
              onTap: () async {
                await onReject();
                _showMessage(context, "Inquiry rejected");
              },
            ),
            const SizedBox(width: 12),
            _circleButton(
              icon: Icons.check,
              filled: true,
              onTap: () async {
                await onAccept();
                _showMessage(context, "Inquiry accepted");
              },
            ),
          ],
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

  static Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "active":
      case "accepted":
        return darkGreen;
      case "rejected":
      case "cancelled":
        return Colors.red;
      case "completed":
      case "history":
        return Colors.grey;
      default:
        return const Color(0xffff9800);
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: darkGreen,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 38),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffd8e6de)),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.mark_email_unread_outlined,
            color: darkGreen,
            size: 42,
          ),
          SizedBox(height: 14),
          Text(
            "No inquiries found",
            style: TextStyle(
              color: darkGreen,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Buyer requests will appear here when they send inquiries.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff555555),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              color: Colors.red,
              size: 46,
            ),
            const SizedBox(height: 14),
            const Text(
              "Something went wrong",
              style: TextStyle(
                color: darkGreen,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xff555555),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}