import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/buyer_inquiry_model.dart';
import '../../providers/language_provider.dart';
import '../chat/chat_detail_screen.dart';
import '../../widgets/buyer/buyer_app_bar.dart';

class BuyerInquiryDetailScreen extends StatelessWidget {
  final BuyerInquiryModel inquiry;

  const BuyerInquiryDetailScreen({super.key, required this.inquiry});

  static const Color darkGreen = Color(0xff0F5C3A);
  static const Color lightBackground = Color(0xffF8FAF7);
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
    return _isDark(context) ? Colors.white : const Color(0xff10291D);
  }

  Color _secondaryText(BuildContext context) {
    return _isDark(context) ? Colors.white70 : const Color(0xff5F675F);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _isDark(context);
    final lang = context.watch<LanguageProvider>();

    return Directionality(
      textDirection: lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: isDark ? darkBackground : lightBackground,
        appBar: BuyerAppBar(
          title: lang.t("inquiryDetails"),
          showBackButton: true,
        ),
        bottomNavigationBar: _bottomButton(context),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cropCard(context),
              const SizedBox(height: 18),
              _infoCard(context),
              const SizedBox(height: 18),
              _messageCard(context),
              const SizedBox(height: 18),
              _timelineCard(context),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cropCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(context),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              inquiry.imageUrl,
              height: 86,
              width: 86,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  height: 86,
                  width: 86,
                  color: _isDark(context)
                      ? const Color(0xff1E1E1E)
                      : const Color(0xffEAF7EF),
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: _accent(context),
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: _primaryText(context),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 17,
                      color: _secondaryText(context),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        inquiry.farmerName.trim().isNotEmpty
                            ? inquiry.farmerName
                            : "Farmer",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _secondaryText(context),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _statusChip(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Column(
        children: [
          _detailRow(
            context,
            context.watch<LanguageProvider>().t("quantity"),
            inquiry.displayQuantity,
            Icons.inventory_2_outlined,
          ),
          _divider(context),
          _detailRow(
            context,
            context.watch<LanguageProvider>().t("offerPrice"),
            _formatPrice(),
            Icons.sell_outlined,
          ),
          _divider(context),
          _detailRow(
            context,
            context.watch<LanguageProvider>().t("deliveryDate"),
            _formatDate(inquiry.deliveryDate),
            Icons.local_shipping_outlined,
          ),
          _divider(context),
          _detailRow(
            context,
            context.watch<LanguageProvider>().t("inquiryDate"),
            _formatDate(inquiry.date),
            Icons.calendar_month_outlined,
          ),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Divider(
      height: 25,
      color: _isDark(context) ? Colors.white10 : const Color(0xffE4EAE5),
    );
  }

  Widget _detailRow(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            color: _isDark(context)
                ? darkGreen.withValues(alpha: 0.25)
                : const Color(0xffEAF7EF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 19, color: _accent(context)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: _secondaryText(context),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value.trim().isEmpty ? "—" : value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: _primaryText(context),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _messageCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.message_outlined, color: _accent(context)),
              const SizedBox(width: 8),
              Text(
                context.watch<LanguageProvider>().t("buyerMessage"),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: _primaryText(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            inquiry.message.trim().isEmpty
                ? context.watch<LanguageProvider>().t("noMessageProvided")
                : inquiry.message,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: _secondaryText(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.watch<LanguageProvider>().t("inquiryTimeline"),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: _primaryText(context),
            ),
          ),
          const SizedBox(height: 16),
          _timelineItem(
            context,
            context.watch<LanguageProvider>().t("inquirySent"),
            true,
          ),
          _timelineItem(
            context,
            context.watch<LanguageProvider>().t("farmerResponse"),
            inquiry.isAccepted || inquiry.isRejected || inquiry.isCompleted,
          ),
          _timelineItem(
            context,
            context.watch<LanguageProvider>().t("dealCompleted"),
            inquiry.isCompleted,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _timelineItem(
    BuildContext context,
    String title,
    bool completed, {
    bool isLast = false,
  }) {
    final isDark = _isDark(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              completed ? Icons.check_circle : Icons.radio_button_unchecked,
              color: completed
                  ? _accent(context)
                  : (isDark ? Colors.white30 : Colors.grey),
              size: 22,
            ),
            if (!isLast)
              Container(
                height: 34,
                width: 2,
                color: completed
                    ? _accent(context)
                    : (isDark ? Colors.white12 : Colors.grey.shade300),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: completed
                  ? _primaryText(context)
                  : (isDark ? Colors.white38 : Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusChip(BuildContext context) {
    final isDark = _isDark(context);

    Color backgroundColor = isDark ? Colors.white10 : const Color(0xffE6ECE8);

    Color textColor = isDark ? Colors.white70 : const Color(0xff4E6B59);

    switch (inquiry.normalizedStatus) {
      case "accepted":
        backgroundColor = isDark
            ? darkGreen.withValues(alpha: 0.35)
            : const Color(0xffA8F0C8);
        textColor = isDark ? lightGreen : darkGreen;
        break;

      case "rejected":
        backgroundColor = isDark
            ? Colors.red.withValues(alpha: 0.18)
            : const Color(0xffFFD6D6);
        textColor = isDark ? Colors.red.shade200 : Colors.red;
        break;

      case "completed":
        backgroundColor = isDark
            ? Colors.blue.withValues(alpha: 0.18)
            : const Color(0xffD7E8FF);
        textColor = isDark ? Colors.blue.shade200 : Colors.blue;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        context.watch<LanguageProvider>().tDynamic(inquiry.status),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: textColor,
        ),
      ),
    );
  }

  Widget _bottomButton(BuildContext context) {
    final isDark = _isDark(context);
    final canOpenChat = inquiry.chatAvailable;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
      decoration: BoxDecoration(
        color: isDark ? darkCard : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white10 : const Color(0xffDCE7DD),
          ),
        ),
      ),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            if (canOpenChat) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatDetailScreen(
                    conversationId: inquiry.conversationId ?? '',
                    inquiryId: inquiry.id,
                    currentUserId: inquiry.buyerId,
                    otherUserId: inquiry.farmerId,
                    otherUserName: inquiry.farmerName,
                    cropName: inquiry.cropName,
                    cropImageUrl: inquiry.imageUrl,
                    quantity: inquiry.quantity,
                    offeredPrice: inquiry.offerPrice,
                    cropUnit: inquiry.cropUnit,
                    status: inquiry.status,
                  ),
                ),
              );
              return;
            }

            Navigator.pop(context);
          },
          icon: Icon(
            canOpenChat ? Icons.chat_bubble_outline : Icons.arrow_back,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: canOpenChat
                ? darkGreen
                : (isDark ? const Color(0xff1E1E1E) : Colors.white),
            foregroundColor: canOpenChat ? Colors.white : _accent(context),
            side: BorderSide(color: _accent(context)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          label: Text(
            canOpenChat
                ? context.watch<LanguageProvider>().t("messageFarmer")
                : context.watch<LanguageProvider>().t("backToInquiries"),
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ),
      ),
    );
  }

  String _formatPrice() {
    final price = inquiry.offerPrice.trim();

    if (price.isEmpty) {
      return "—";
    }

    if (inquiry.cropUnit.trim().isEmpty) {
      return "Rs. $price";
    }

    return "Rs. $price / ${inquiry.cropUnit}";
  }

  String _formatDate(String rawDate) {
    if (rawDate.trim().isEmpty) {
      return "—";
    }

    final parsedDate = DateTime.tryParse(rawDate);

    if (parsedDate == null) {
      return rawDate;
    }

    final localDate = parsedDate.toLocal();
    final day = localDate.day.toString().padLeft(2, '0');
    final month = localDate.month.toString().padLeft(2, '0');

    return "$day/$month/${localDate.year}";
  }

  BoxDecoration _cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: _isDark(context) ? darkCard : Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: _isDark(context) ? Colors.white10 : const Color(0xffDCE7DD),
      ),
    );
  }
}
