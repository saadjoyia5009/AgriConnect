import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/inquiry_model.dart';
import '../../providers/inquiry_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/auth_provider.dart';
import '../chat/chat_detail_screen.dart';

class FarmerInquiryDetailScreen extends StatelessWidget {
  final String inquiryId;

  const FarmerInquiryDetailScreen({
    super.key,
    required this.inquiryId,
  });

  static const Color darkGreen = Color(0xff075739);
  static const Color mediumGreen = Color(0xff0b7a4f);
  static const Color accentGreen = Color(0xff36a66b);
  static const Color lightGreen = Color(0xffe9f7ef);
  static const Color softGreen = Color(0xfff4faf6);
  static const Color borderGreen = Color(0xffcfe5d8);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InquiryProvider>(context);
    final lang = context.watch<LanguageProvider>();

    final InquiryModel? inquiry =
    provider.getInquiryById(inquiryId);

    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    if (inquiry == null) {
      return Scaffold(
        backgroundColor:
        Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Center(
            child: Text(
              lang.t("inquiryNotFound"),
              style: TextStyle(
                color: isDark ? Colors.white : darkGreen,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      );
    }

    final bool isPending =
        inquiry.status.toLowerCase() == "pending";

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xff101512)
          : const Color(0xfff7fbf8),

      body: SafeArea(
        child: Column(
          children: [

            // =====================================================
            // TOP HEADER
            // =====================================================

            _header(context),

            // =====================================================
            // CONTENT
            // =====================================================

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  18,
                  20,
                  18,
                  30,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    // BUYER CARD
                    _buyerCard(
                      context,
                      inquiry,
                    ),

                    const SizedBox(height: 18),

                    // CROP CARD
                    _cropCard(
                      context,
                      inquiry,
                    ),

                    const SizedBox(height: 26),

                    // MESSAGE TITLE
                    Row(
                      children: [
                        Container(
                          height: 38,
                          width: 38,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white10
                                : const Color(0xffdff4e7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: darkGreen,
                            size: 20,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Text(
                          lang.t("message"),
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xff123a2a),
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.3,
                          ),
                        ),

                        const SizedBox(width: 6),

                        const Icon(
                          Icons.eco_rounded,
                          color: accentGreen,
                          size: 18,
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // MESSAGE
                    _messageBox(
                      context,
                      inquiry.message,
                    ),

                    const SizedBox(height: 24),

                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark
                          ? Colors.white12
                          : const Color(0xffdfe9e3),
                    ),

                    const SizedBox(height: 18),

                    // =================================================
                    // ACCEPT / DECLINE
                    // =================================================

                    if (isPending) ...[
                      _fullButton(
                        title:
                        lang.t("acceptInquiry"),
                        icon:
                        Icons.check_circle_outline_rounded,
                        backgroundColor:
                        darkGreen,
                        textColor:
                        Colors.white,
                        onTap: () async {
                          await provider.acceptInquiry(
                            inquiry.id,
                          );

                          _showSnack(
                            context,
                            lang.t(
                              "inquiryAcceptedSuccessfully",
                            ),
                          );

                          Navigator.pop(context);
                        },
                      ),

                      const SizedBox(height: 10),

                      _fullButton(
                        title: lang.t("decline"),
                        icon:
                        Icons.cancel_outlined,
                        backgroundColor: isDark
                            ? Theme.of(context).cardColor
                            : Colors.white,
                        textColor: isDark
                            ? Colors.white
                            : darkGreen,
                        borderColor: isDark
                            ? Colors.white24
                            : const Color(0xff49c982),
                        onTap: () async {
                          await provider.rejectInquiry(
                            inquiry.id,
                          );

                          _showSnack(
                            context,
                            lang.t(
                              "inquiryDeclined",
                            ),
                          );

                          Navigator.pop(context);
                        },
                      ),

                      const SizedBox(height: 12),
                    ],

                    // =================================================
                    // MESSAGE BUYER
                    // =================================================

                    _fullButton(
                      title: lang.t("messageBuyer"),
                      icon:
                      Icons.chat_bubble_outline_rounded,
                      backgroundColor: isPending
                          ? (isDark
                          ? Theme.of(context).cardColor
                          : const Color(0xffe7eee9))
                          : darkGreen,
                      textColor: isPending
                          ? (isDark
                          ? Colors.white
                          : const Color(0xff222222))
                          : Colors.white,
                      borderColor: isPending
                          ? (isDark
                          ? Colors.white12
                          : const Color(0xffdce7df))
                          : darkGreen,
                      onTap: () {
                        if (inquiry.status
                            .toLowerCase() ==
                            "accepted") {
                          final currentUserId =
                              context
                                  .read<AuthProvider>()
                                  .userId
                                  ?.toString() ??
                                  '';

                          if (currentUserId.isEmpty) {
                            _showSnack(
                              context,
                              context
                                  .read<
                                  LanguageProvider>()
                                  .t(
                                "loginInformationNotFound",
                              ),
                            );
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ChatDetailScreen(
                                    conversationId:
                                    inquiry
                                        .conversationId,
                                    inquiryId:
                                    inquiry.id,
                                    currentUserId:
                                    currentUserId,
                                    otherUserId:
                                    inquiry.buyerId,
                                    otherUserName:
                                    inquiry.buyerName,
                                    cropName:
                                    inquiry.cropName,
                                    cropImageUrl:
                                    inquiry.cropImage,
                                    quantity:
                                    inquiry
                                        .requestedQuantity,
                                    offeredPrice:
                                    inquiry
                                        .proposedPrice,
                                    cropUnit:
                                    inquiry.cropUnit,
                                    status:
                                    inquiry.status,
                                  ),
                            ),
                          );
                        } else {
                          _showSnack(
                            context,
                            context
                                .read<
                                LanguageProvider>()
                                .t(
                              "chatAcceptedOnly",
                            ),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // HEADER
  // =============================================================

  Widget _header(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final lang =
    context.watch<LanguageProvider>();

    return Container(
      height: 88,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xff101f17)
            : const Color(0xfff7fbf8),
      ),
      child: Stack(
        children: [

          // Decorative leaf
          Positioned(
            right: -8,
            top: 0,
            child: Opacity(
              opacity: 0.12,
              child: Icon(
                Icons.eco_rounded,
                size: 100,
                color: accentGreen,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            child: Row(
              children: [

                // BACK BUTTON
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white10
                        : Colors.white,
                    borderRadius:
                    BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? Colors.white12
                          : borderGreen,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(alpha: 0.025),
                        blurRadius: 10,
                        offset:
                        const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: isDark
                          ? Colors.white
                          : darkGreen,
                      size: 27,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Text(
                  lang.t("inquiryDetails"),
                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : darkGreen,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.7,
                  ),
                ),

                const SizedBox(width: 7),

                const Icon(
                  Icons.eco_rounded,
                  color: accentGreen,
                  size: 19,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // BUYER CARD
  // =============================================================

  Widget _buyerCard(
      BuildContext context,
      InquiryModel inquiry,
      ) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final lang =
    context.watch<LanguageProvider>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xff172019)
            : Colors.white,
        borderRadius:
        BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white12
              : borderGreen,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.035,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.center,
        children: [

          // AVATAR
          Container(
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
                errorBuilder:
                    (_, __, ___) {
                  return _initialAvatar(
                    inquiry.buyerInitials,
                  );
                },
              ),
            )
                : _initialAvatar(
              inquiry.buyerInitials,
            ),
          ),

          const SizedBox(width: 14),

          // BUYER INFO
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  inquiry.buyerName,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : const Color(0xff17211c),
                    fontSize: 20,
                    fontWeight:
                    FontWeight.w900,
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
                          : const Color(
                        0xff3e4943,
                      ),
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      child: Text(
                        inquiry.buyerLocation,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark
                              ? Colors.white60
                              : const Color(
                            0xff3e4943,
                          ),
                          fontSize: 12,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // NEW BUYER + TIME
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.end,
            children: [

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white10
                      : const Color(0xffdff5e7),
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: Text(
                  lang.t("newBuyer"),
                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : darkGreen,
                    fontSize: 11,
                    fontWeight:
                    FontWeight.w900,
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
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =============================================================
  // CROP CARD
  // =============================================================

  Widget _cropCard(
      BuildContext context,
      InquiryModel inquiry,
      ) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final lang =
    context.watch<LanguageProvider>();

    final screenWidth =
        MediaQuery.of(context).size.width;

    // Image height responsive rakhi hai.
    // Mobile par target design jaisi tall image.
    final imageHeight =
    (screenWidth * 0.56).clamp(245.0, 330.0);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xff172019)
            : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark
              ? Colors.white12
              : borderGreen,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.045,
            ),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [

          // =====================================================
          // IMAGE + CURVED BOTTOM
          // =====================================================

          SizedBox(
            height: imageHeight,
            width: double.infinity,
            child: Stack(
              children: [

                // -------------------------------------------------
                // GREEN CURVED BASE
                // -------------------------------------------------

                Positioned.fill(
                  child: ClipPath(
                    clipper: InquiryImageCurveClipper(
                      bottomPadding: 0,
                    ),
                    child: Container(
                      color: const Color(0xff48b980),
                    ),
                  ),
                ),

                // -------------------------------------------------
                // ACTUAL IMAGE
                // -------------------------------------------------

                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                    ),
                    child: ClipPath(
                      clipper: InquiryImageCurveClipper(
                        bottomPadding: 10,
                      ),
                      child: Image.network(
                        inquiry.cropImage,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) {
                          return Container(
                            color: isDark
                                ? Colors.white10
                                : lightGreen,
                            child: const Center(
                              child: Icon(
                                Icons
                                    .image_not_supported_outlined,
                                color: darkGreen,
                                size: 45,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // -------------------------------------------------
                // DARK IMAGE GRADIENT
                // -------------------------------------------------

                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                    ),
                    child: ClipPath(
                      clipper: InquiryImageCurveClipper(
                        bottomPadding: 10,
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin:
                            Alignment.bottomCenter,
                            end:
                            Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(
                                alpha: 0.72,
                              ),
                              Colors.black.withValues(
                                alpha: 0.20,
                              ),
                              Colors.transparent,
                            ],
                            stops: const [
                              0.0,
                              0.45,
                              0.85,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // -------------------------------------------------
                // CROP INFORMATION
                // -------------------------------------------------

                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 27,
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Text(
                        inquiry.cropName,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight:
                          FontWeight.w900,
                          letterSpacing: -0.6,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        lang
                            .t("requestedValue")
                            .replaceAll(
                          "{value}",
                          lang.tDynamic(
                            inquiry
                                .requestedQuantity,
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // =====================================================
          // PRICE SECTION
          // =====================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              16,
              20,
              18,
            ),
            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [

                // PRICE
                Expanded(
                  child: _infoText(
                    context: context,
                    title: lang.t(
                      "proposedPriceCaps",
                    ),
                    value: inquiry.proposedPrice,
                  ),
                ),

                const SizedBox(width: 10),

                // VIEW LISTING
                Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white10
                        : const Color(
                      0xffeaf6ee,
                    ),
                    borderRadius:
                    BorderRadius.circular(17),
                  ),
                  child: Row(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [

                      Icon(
                        Icons.inventory_2_outlined,
                        color: isDark
                            ? Colors.white
                            : darkGreen,
                        size: 19,
                      ),

                      const SizedBox(width: 8),

                      Text(
                        lang.t("viewListing"),
                        style: TextStyle(
                          color: isDark
                              ? Colors.white
                              : darkGreen,
                          fontSize: 13,
                          fontWeight:
                          FontWeight.w900,
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

  // =============================================================
  // MESSAGE BOX
  // =============================================================

  Widget _messageBox(
      BuildContext context,
      String message,
      ) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        18,
        20,
        18,
        20,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xff172019)
            : Colors.white,
        borderRadius:
        BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white12
              : borderGreen,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.025,
            ),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isDark
              ? Colors.white70
              : const Color(0xff28352e),
          fontSize: 16,
          height: 1.55,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // =============================================================
  // INFO TEXT
  // =============================================================

  Widget _infoText({
    required BuildContext context,
    required String title,
    required String value,
  }) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [

        Text(
          title,
          style: TextStyle(
            color: isDark
                ? Colors.white60
                : const Color(0xff4b5750),
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.7,
          ),
        ),

        const SizedBox(height: 5),

        Row(
          crossAxisAlignment:
          CrossAxisAlignment.baseline,
          textBaseline:
          TextBaseline.alphabetic,
          children: [

            Text(
              value,
              style: const TextStyle(
                color: darkGreen,
                fontSize: 29,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.8,
              ),
            ),

            const SizedBox(width: 6),

            Text(
              "/ Kg",
              style: TextStyle(
                color: isDark
                    ? Colors.white60
                    : const Color(0xff68736d),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =============================================================
  // FULL BUTTON
  // =============================================================

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
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(
          icon,
          size: 22,
        ),
        label: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
          backgroundColor,
          foregroundColor:
          textColor,
          elevation: 0,
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(18),
            side: BorderSide(
              color:
              borderColor ??
                  backgroundColor,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // AVATAR FALLBACK
  // =============================================================

  Widget _initialAvatar(
      String initials,
      ) {
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

  // =============================================================
  // SNACKBAR
  // =============================================================

  void _showSnack(
      BuildContext context,
      String message,
      ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: darkGreen,
        behavior:
        SnackBarBehavior.floating,
        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(14),
        ),
      ),
    );
  }
}

class InquiryImageCurveClipper
    extends CustomClipper<Path> {
  final double bottomPadding;

  const InquiryImageCurveClipper({
    this.bottomPadding = 0,
  });

  @override
  Path getClip(Size size) {
    final path = Path();

    final double curveHeight =
        38 + bottomPadding;

    path.moveTo(0, 0);

    // Top
    path.lineTo(size.width, 0);

    // Right side
    path.lineTo(
      size.width,
      size.height - curveHeight,
    );

    // Smooth curve on bottom
    path.quadraticBezierTo(
      size.width * 0.78,
      size.height - 2 - bottomPadding,
      size.width * 0.50,
      size.height - 4 - bottomPadding,
    );

    path.quadraticBezierTo(
      size.width * 0.24,
      size.height - 10 - bottomPadding,
      0,
      size.height - curveHeight,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(
      covariant InquiryImageCurveClipper oldClipper,
      ) {
    return oldClipper.bottomPadding !=
        bottomPadding;
  }
}