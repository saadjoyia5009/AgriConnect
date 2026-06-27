import 'package:flutter/material.dart';
import '../../models/buyer_inquiry_model.dart';

class BuyerInquiryCard extends StatelessWidget {
  final BuyerInquiryModel inquiry;
  final VoidCallback? onViewDetails;
  final VoidCallback? onMessageFarmer;

  const BuyerInquiryCard({
    super.key,
    required this.inquiry,
    this.onViewDetails,
    this.onMessageFarmer,
  });

  Color get statusColor {
    switch (inquiry.status) {
      case "Accepted":
        return const Color(0xFF9BE7B7);
      case "Declined":
        return const Color(0xFFFFD6D6);
      case "Completed":
        return const Color(0xFFD7E8FF);
      default:
        return const Color(0xFFE6ECE8);
    }
  }

  Color get statusTextColor {
    switch (inquiry.status) {
      case "Accepted":
        return const Color(0xFF0E7A3E);
      case "Declined":
        return const Color(0xFFD33A2C);
      case "Completed":
        return const Color(0xFF1D5FA7);
      default:
        return const Color(0xFF4E6B59);
    }
  }

  bool get isAccepted => inquiry.status == "Accepted";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDEFE3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          _topSection(),
          const Divider(height: 1),
          _infoSection(),
          _actionButton(),
        ],
      ),
    );
  }

  Widget _topSection() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Image.network(
              inquiry.imageUrl,
              width: 58,
              height: 58,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 58,
                  height: 58,
                  color: const Color(0xFFEAF7EF),
                  child: const Icon(Icons.image_not_supported_outlined),
                );
              },
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inquiry.cropName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F2D25),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  inquiry.farmerName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF40584B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFE9EEEB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              inquiry.date,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4B5650),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _infoSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      child: Row(
        children: [
          Expanded(
            child: _infoItem(
              title: "PROPOSED QUANTITY",
              value: inquiry.quantity,
            ),
          ),
          _statusChip(),
        ],
      ),
    );
  }

  Widget _infoItem({
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w700,
            color: Color(0xFF656F68),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E2722),
          ),
        ),
      ],
    );
  }

  Widget _statusChip() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          "STATUS",
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w700,
            color: Color(0xFF656F68),
          ),
        ),
        const SizedBox(height: 7),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            inquiry.status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: statusTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
      child: SizedBox(
        width: double.infinity,
        height: 38,
        child: OutlinedButton(
          onPressed: isAccepted ? onMessageFarmer : onViewDetails,
          style: OutlinedButton.styleFrom(
            backgroundColor:
            isAccepted ? const Color(0xFF0E5D3B) : Colors.white,
            side: const BorderSide(color: Color(0xFF0E5D3B)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          child: Text(
            isAccepted ? "Message Farmer" : "View Details",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: isAccepted ? Colors.white : const Color(0xFF0E5D3B),
            ),
          ),
        ),
      ),
    );
  }
}