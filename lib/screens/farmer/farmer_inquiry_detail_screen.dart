import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/inquiry_model.dart';
import '../../providers/inquiry_provider.dart';

class FarmerInquiryDetailScreen extends StatelessWidget {
  final String inquiryId;

  const FarmerInquiryDetailScreen({
    super.key,
    required this.inquiryId,
  });

  static const Color darkGreen = Color(0xff075739);
  static const Color lightGreen = Color(0xffe9f7ef);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InquiryProvider>(context);
    final InquiryModel? inquiry = provider.getInquiryById(inquiryId);

    if (inquiry == null) {
      return Scaffold(
        backgroundColor: const Color(0xfff9fbfa),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Inquiry Details",
            style: TextStyle(
              color: darkGreen,
              fontWeight: FontWeight.w900,
            ),
          ),
          iconTheme: const IconThemeData(color: darkGreen),
        ),
        body: const Center(
          child: Text(
            "Inquiry not found",
            style: TextStyle(
              color: darkGreen,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }

    final bool isPending = inquiry.status.toLowerCase() == "pending";

    return Scaffold(
      backgroundColor: const Color(0xfff9fbfa),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: darkGreen),
        title: const Text(
          "Inquiry Details",
          style: TextStyle(
            color: darkGreen,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buyerCard(inquiry),
            const SizedBox(height: 22),
            _cropCard(inquiry),
            const SizedBox(height: 28),
            const Text(
              "Message",
              style: TextStyle(
                color: Color(0xff222222),
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            _messageBox(inquiry.message),
            const SizedBox(height: 28),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 14),

            if (isPending) ...[
              _fullButton(
                title: "Accept Inquiry",
                icon: Icons.check_circle_outline,
                backgroundColor: darkGreen,
                textColor: Colors.white,
                onTap: () async {
                  await provider.acceptInquiry(inquiry.id);
                  _showSnack(context, "Inquiry accepted successfully");
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              _fullButton(
                title: "Decline",
                icon: Icons.cancel_outlined,
                backgroundColor: Colors.white,
                textColor: darkGreen,
                borderColor: const Color(0xff49c982),
                onTap: () async {
                  await provider.rejectInquiry(inquiry.id);
                  _showSnack(context, "Inquiry declined");
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
            ],

            _fullButton(
              title: "Message Buyer",
              icon: Icons.message_outlined,
              backgroundColor: const Color(0xffe7e8e5),
              textColor: const Color(0xff222222),
              onTap: () {
                _showSnack(context, "Chat screen will be connected later");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buyerCard(InquiryModel inquiry) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffcfe5d8)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: lightGreen,
            backgroundImage:
            inquiry.buyerImage.isNotEmpty ? NetworkImage(inquiry.buyerImage) : null,
            child: inquiry.buyerImage.isEmpty
                ? Text(
              inquiry.buyerInitials,
              style: const TextStyle(
                color: darkGreen,
                fontWeight: FontWeight.w900,
              ),
            )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inquiry.buyerName,
                  style: const TextStyle(
                    color: Color(0xff222222),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Color(0xff444444),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      inquiry.buyerLocation,
                      style: const TextStyle(
                        color: Color(0xff444444),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xffd9f3df),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  "New Buyer",
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                inquiry.timeAgo,
                style: const TextStyle(
                  color: Color(0xff444444),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cropCard(InquiryModel inquiry) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffcfe5d8)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(14)),
                child: Image.network(
                  inquiry.cropImage,
                  width: double.infinity,
                  height: 135,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      height: 135,
                      color: lightGreen,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: darkGreen,
                          size: 38,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: 135,
                decoration: BoxDecoration(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.65),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inquiry.cropName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Requested ${inquiry.requestedQuantity}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                Expanded(
                  child: _infoText(
                    title: "PROPOSED PRICE",
                    value: inquiry.proposedPrice,
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xfff1f3f1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: darkGreen,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "View Listing",
                        style: TextStyle(
                          color: darkGreen,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoText({
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xff444444),
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: darkGreen,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _messageBox(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffcfe5d8)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Color(0xff3d4a43),
          fontSize: 16,
          height: 1.55,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _fullButton({
    required String title,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 21),
        label: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
            side: BorderSide(
              color: borderColor ?? backgroundColor,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: darkGreen,
      ),
    );
  }
}