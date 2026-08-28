import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/inquiry_model.dart';
import '../../providers/language_provider.dart';

class FarmerInquiryBuyerCard extends StatelessWidget {
  final InquiryModel inquiry;

  const FarmerInquiryBuyerCard({
    super.key,
    required this.inquiry,
  });

  static const Color darkGreen = Color(0xff075739);
  static const Color borderGreen = Color(0xffcfe5d8);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff172019) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white12 : borderGreen,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _avatar(context),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inquiry.buyerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : const Color(0xff17211c),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 17,
                      color: isDark
                          ? Colors.white60
                          : const Color(0xff3e4943),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        inquiry.buyerLocation,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark
                              ? Colors.white60
                              : const Color(0xff3e4943),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white10
                      : const Color(0xffdff5e7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  context.watch<LanguageProvider>().t("newBuyer"),
                  style: TextStyle(
                    color: isDark ? Colors.white : darkGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                inquiry.timeAgo,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: isDark
                      ? Colors.white54
                      : const Color(0xff505b55),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _avatar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 74,
      width: 74,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white10
            : const Color(0xffe6f6eb),
        shape: BoxShape.circle,
      ),
      child: inquiry.buyerImage.isNotEmpty
          ? ClipOval(
        child: Image.network(
          inquiry.buyerImage,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              _initialAvatar(inquiry.buyerInitials),
        ),
      )
          : _initialAvatar(inquiry.buyerInitials),
    );
  }

  Widget _initialAvatar(String initials) {
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          color: darkGreen,
          fontSize: 25,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
