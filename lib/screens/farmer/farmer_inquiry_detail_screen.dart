import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/inquiry_model.dart';
import '../../providers/inquiry_provider.dart';
import '../../providers/language_provider.dart';

class FarmerInquiryDetailScreen extends StatelessWidget {
  final String inquiryId;

  const FarmerInquiryDetailScreen({super.key, required this.inquiryId});

  static const Color darkGreen = Color(0xff075739);
  static const Color lightGreen = Color(0xffe9f7ef);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InquiryProvider>(context);
    final lang = context.watch<LanguageProvider>();
    final InquiryModel? inquiry = provider.getInquiryById(inquiryId);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (inquiry == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _appBar(context),
        body: Center(
          child: Text(
            lang.t("inquiryNotFound"),
            style: TextStyle(
              color: isDark ? Colors.white : darkGreen,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }

    final bool isPending = inquiry.status.toLowerCase() == "pending";

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _appBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buyerCard(context, inquiry),
            const SizedBox(height: 22),
            _cropCard(context, inquiry),
            const SizedBox(height: 28),
            Text(
              lang.t("message"),
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            _messageBox(context, inquiry.message),
            const SizedBox(height: 28),
            Divider(color: isDark ? Colors.white12 : Colors.grey.shade300),
            const SizedBox(height: 14),

            if (isPending) ...[
              _fullButton(
                title: lang.t("acceptInquiry"),
                icon: Icons.check_circle_outline,
                backgroundColor: darkGreen,
                textColor: Colors.white,
                onTap: () async {
                  await provider.acceptInquiry(inquiry.id);
                  _showSnack(context, lang.t("inquiryAcceptedSuccessfully"));
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              _fullButton(
                title: lang.t("decline"),
                icon: Icons.cancel_outlined,
                backgroundColor: isDark
                    ? Theme.of(context).cardColor
                    : Colors.white,
                textColor: isDark ? Colors.white : darkGreen,
                borderColor: isDark ? Colors.white24 : const Color(0xff49c982),
                onTap: () async {
                  await provider.rejectInquiry(inquiry.id);
                  _showSnack(context, lang.t("inquiryDeclined"));
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
            ],

            _fullButton(
              title: lang.t("messageBuyer"),
              icon: Icons.message_outlined,
              backgroundColor: isDark
                  ? Theme.of(context).cardColor
                  : const Color(0xffe7e8e5),
              textColor: isDark ? Colors.white : const Color(0xff222222),
              borderColor: isDark ? Colors.white12 : null,
              onTap: () {
                if (inquiry.status.toLowerCase() == "accepted") {
                  _showSnack(context, lang.t("chatConnectedLater"));
                } else {
                  _showSnack(context, "Chat is only available for accepted inquiries.");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return AppBar(
      backgroundColor: Theme.of(context).cardColor,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: isDark ? Colors.white : darkGreen),
      title: Text(
        lang.t("inquiryDetails"),
        style: TextStyle(
          color: isDark ? Colors.white : darkGreen,
          fontSize: 22,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buyerCard(BuildContext context, InquiryModel inquiry) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xffcfe5d8),
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.18)
                : Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: isDark ? Colors.white12 : lightGreen,
            backgroundImage: inquiry.buyerImage.isNotEmpty
                ? NetworkImage(inquiry.buyerImage)
                : null,
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
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: isDark ? Colors.white60 : const Color(0xff444444),
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
                              : const Color(0xff444444),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white12 : const Color(0xffd9f3df),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  lang.t("newBuyer"),
                  style: TextStyle(
                    color: isDark ? Colors.white : darkGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                inquiry.timeAgo,
                style: TextStyle(
                  color: isDark ? Colors.white60 : const Color(0xff444444),
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

  Widget _cropCard(BuildContext context, InquiryModel inquiry) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xffcfe5d8),
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.18)
                : Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                child: Image.network(
                  inquiry.cropImage,
                  width: double.infinity,
                  height: 135,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      height: 135,
                      color: isDark ? Colors.white12 : lightGreen,
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
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
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
                      lang
                          .t("requestedValue")
                          .replaceAll(
                            "{value}",
                            lang.tDynamic(inquiry.requestedQuantity),
                          ),
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
                    context: context,
                    title: lang.t("proposedPriceCaps"),
                    value: inquiry.proposedPrice,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white12 : const Color(0xfff1f3f1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: isDark ? Colors.white : darkGreen,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        lang.t("viewListing"),
                        style: TextStyle(
                          color: isDark ? Colors.white : darkGreen,
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
            color: isDark ? Colors.white60 : const Color(0xff444444),
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

  Widget _messageBox(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xffcfe5d8),
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.18)
                : Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isDark ? Colors.white70 : const Color(0xff3d4a43),
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
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
            side: BorderSide(color: borderColor ?? backgroundColor, width: 1.5),
          ),
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: darkGreen),
    );
  }
}
