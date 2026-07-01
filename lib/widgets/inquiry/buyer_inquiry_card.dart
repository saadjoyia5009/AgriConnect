import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/buyer_inquiry_model.dart';
import '../../providers/language_provider.dart';

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

  static const Color darkGreen = Color(0xFF0E5D3B);
  static const Color darkCard = Color(0xFF15251E);
  static const Color lightGreen = Color(0xff9ff2c1);

  bool get isAccepted => inquiry.status == "Accepted";

  Color statusColor(bool isDark) {
    switch (inquiry.status) {
      case "Accepted":
        return isDark ? darkGreen.withOpacity(0.35) : const Color(0xFF9BE7B7);
      case "Declined":
        return isDark ? Colors.red.withOpacity(0.18) : const Color(0xFFFFD6D6);
      case "Completed":
        return isDark ? Colors.blue.withOpacity(0.18) : const Color(0xFFD7E8FF);
      default:
        return isDark ? Colors.white10 : const Color(0xFFE6ECE8);
    }
  }

  Color statusTextColor(bool isDark) {
    switch (inquiry.status) {
      case "Accepted":
        return isDark ? lightGreen : const Color(0xFF0E7A3E);
      case "Declined":
        return isDark ? Colors.red.shade200 : const Color(0xFFD33A2C);
      case "Completed":
        return isDark ? Colors.blue.shade200 : const Color(0xFF1D5FA7);
      default:
        return isDark ? Colors.white70 : const Color(0xFF4E6B59);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;


    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        color: isDark ? darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFDDEFE3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.20 : 0.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _topSection(context),
          Divider(
            height: 1,
            color: isDark ? Colors.white10 : Colors.black12,
          ),
          _infoSection(context),
          _actionButton(context),
        ],
      ),
    );
  }

  Widget _topSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                  color: isDark ? const Color(0xff1E1E1E) : const Color(0xFFEAF7EF),
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: isDark ? Colors.white60 : darkGreen,
                  ),
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
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF1F2D25),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  inquiry.farmerName,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : const Color(0xFF40584B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : const Color(0xFFE9EEEB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              inquiry.date,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white70 : const Color(0xFF4B5650),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoSection(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      child: Row(
        children: [
          Expanded(
            child: _infoItem(
              context: context,
              title: lang.t("proposedQuantityCaps"),
              value: lang.tDynamic(inquiry.quantity),
            ),
          ),
          _statusChip(context),
        ],
      ),
    );
  }

  Widget _infoItem({
    required BuildContext context,
    required String title,
    required String value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white54 : const Color(0xFF656F68),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF1E2722),
          ),
        ),
      ],
    );
  }

  Widget _statusChip(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          lang.t("statusCaps"),
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white54 : const Color(0xFF656F68),
          ),
        ),
        const SizedBox(height: 7),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor(isDark),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            lang.tDynamic(inquiry.status),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: statusTextColor(isDark),
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
      child: SizedBox(
        width: double.infinity,
        height: 38,
        child: OutlinedButton(
          onPressed: isAccepted ? onMessageFarmer : onViewDetails,
          style: OutlinedButton.styleFrom(
            backgroundColor: isAccepted
                ? darkGreen
                : (isDark ? const Color(0xff1E1E1E) : Colors.white),
            side: BorderSide(
              color: isDark ? lightGreen : darkGreen,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          child: Text(
            isAccepted ? lang.t("messageFarmer") : lang.t("viewDetails"),
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: isAccepted
                  ? Colors.white
                  : (isDark ? lightGreen : darkGreen),
            ),
          ),
        ),
      ),
    );
  }
}
