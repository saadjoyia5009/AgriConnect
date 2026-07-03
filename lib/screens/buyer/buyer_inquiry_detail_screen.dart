import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/buyer_inquiry_model.dart';
import '../../providers/language_provider.dart';
import 'buyer_farmer_chat_screen.dart';

class BuyerInquiryDetailScreen extends StatelessWidget {
  final BuyerInquiryModel inquiry;

  const BuyerInquiryDetailScreen({
    super.key,
    required this.inquiry,
  });

  static const Color darkGreen = Color(0xff0F5C3A);
  static const Color lightBackground = Color(0xffF8FAF7);
  static const Color darkBackground = Color(0xFF0B1410);
  static const Color darkCard = Color(0xFF15251E);
  static const Color lightGreen = Color(0xff9ff2c1);

  bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  Color _accent(BuildContext context) =>
      _isDark(context) ? lightGreen : darkGreen;

  Color _primaryText(BuildContext context) =>
      _isDark(context) ? Colors.white : const Color(0xff10291D);

  Color _secondaryText(BuildContext context) =>
      _isDark(context) ? Colors.white70 : const Color(0xff5F675F);

  @override
  Widget build(BuildContext context) {
    final isDark = _isDark(context);
    final isAccepted = inquiry.status.toLowerCase() == "accepted";
    final lang = context.watch<LanguageProvider>();

    return Directionality(
      textDirection: lang.isUrdu
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
      backgroundColor: isDark ? darkBackground : lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? darkBackground : lightBackground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          lang.t("inquiryDetails"),
          style: TextStyle(
            color: _accent(context),
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _accent(context)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: _bottomButton(context, isAccepted),
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
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inquiry.cropName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: _primaryText(context),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  inquiry.farmerName,
                  style: TextStyle(
                    color: _secondaryText(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                _statusChip(context, inquiry.status),
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
            context.watch<LanguageProvider>().tDynamic(inquiry.quantity),
          ),
          _detailRow(
            context,
            context.watch<LanguageProvider>().t("offerPrice"),
            inquiry.offerPrice,
          ),
          _detailRow(
            context,
            context.watch<LanguageProvider>().t("deliveryDate"),
            inquiry.deliveryDate,
          ),
          _detailRow(
            context,
            context.watch<LanguageProvider>().t("inquiryDate"),
            inquiry.date,
          ),
        ],
      ),
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
          Text(
            context.watch<LanguageProvider>().t("buyerMessage"),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: _primaryText(context),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            inquiry.message,
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
    final status = inquiry.status.toLowerCase();

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
          _timelineItem(context, context.watch<LanguageProvider>().t("inquirySent"), true),
          _timelineItem(
            context,
            context.watch<LanguageProvider>().t("farmerResponse"),
            status == "accepted" ||
                status == "declined" ||
                status == "rejected" ||
                status == "completed",
          ),
          _timelineItem(
            context,
            context.watch<LanguageProvider>().t("dealCompleted"),
            status == "completed",
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

  Widget _detailRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: _secondaryText(context),
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: _primaryText(context),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(BuildContext context, String status) {
    final isDark = _isDark(context);

    Color bgColor = isDark ? Colors.white10 : const Color(0xffE6ECE8);
    Color textColor = isDark ? Colors.white70 : const Color(0xff4E6B59);

    if (status.toLowerCase() == "accepted") {
      bgColor = isDark
          ? darkGreen.withOpacity(0.35)
          : const Color(0xffA8F0C8);
      textColor = isDark ? lightGreen : darkGreen;
    } else if (status.toLowerCase() == "declined" ||
        status.toLowerCase() == "rejected") {
      bgColor =
      isDark ? Colors.red.withOpacity(0.18) : const Color(0xffFFD6D6);
      textColor = isDark ? Colors.red.shade200 : Colors.red;
    } else if (status.toLowerCase() == "completed") {
      bgColor =
      isDark ? Colors.blue.withOpacity(0.18) : const Color(0xffD7E8FF);
      textColor = isDark ? Colors.blue.shade200 : Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        context.watch<LanguageProvider>().tDynamic(status),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: textColor,
        ),
      ),
    );
  }

  Widget _bottomButton(BuildContext context, bool isAccepted) {
    final isDark = _isDark(context);

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
        child: ElevatedButton(
          onPressed: () {
            if (isAccepted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BuyerFarmerChatScreen(inquiry: inquiry),
                ),
              );
            } else {
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isAccepted
                ? darkGreen
                : (isDark ? const Color(0xff1E1E1E) : Colors.white),
            foregroundColor: isAccepted ? Colors.white : _accent(context),
            side: BorderSide(color: _accent(context)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            isAccepted
                ? context.watch<LanguageProvider>().t("messageFarmer")
                : context.watch<LanguageProvider>().t("backToInquiries"),
            style: TextStyle(
              color: isAccepted ? Colors.white : _accent(context),
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration(BuildContext context) {
    final isDark = _isDark(context);

    return BoxDecoration(
      color: isDark ? darkCard : Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: isDark ? Colors.white10 : const Color(0xffDCE7DD),
      ),
    );
  }
}
