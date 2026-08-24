import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/inquiry_model.dart';
import '../../providers/chat_provider.dart';
import '../../providers/inquiry_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/farmer_bottom_navbar.dart';
import 'farmer_inquiry_detail_screen.dart';

class FarmerInquiriesScreen extends StatefulWidget {
  const FarmerInquiriesScreen({super.key});

  @override
  State<FarmerInquiriesScreen> createState() =>
      _FarmerInquiriesScreenState();
}

class _FarmerInquiriesScreenState
    extends State<FarmerInquiriesScreen> {
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
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: const Color(0xfff5faf7),

      bottomNavigationBar: const FarmerBottomNavbar(
        currentIndex: 3,
      ),

      body: Column(
        children: [
          _topBar(),

          Expanded(
            child: Consumer<InquiryProvider>(
              builder: (
                context,
                inquiryProvider,
                _,
              ) {
                // --------------------------------------------------
                // LOADING
                // --------------------------------------------------

                if (inquiryProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: darkGreen,
                    ),
                  );
                }

                // --------------------------------------------------
                // ERROR
                // --------------------------------------------------

                if (inquiryProvider.errorMessage != null) {
                  return _ErrorState(
                    message:
                        inquiryProvider.errorMessage!,
                    onRetry: () {
                      inquiryProvider
                          .fetchFarmerInquiries();
                    },
                  );
                }

                final isDark =
                    Theme.of(context).brightness ==
                        Brightness.dark;

                return RefreshIndicator(
                  color: darkGreen,

                  onRefresh: () async {
                    await inquiryProvider
                        .fetchFarmerInquiries();
                  },

                  child: SingleChildScrollView(
                    physics:
                        const AlwaysScrollableScrollPhysics(),

                    padding: const EdgeInsets.fromLTRB(
                      18,
                      20,
                      18,
                      100,
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // ------------------------------------------------
                        // HERO
                        // ------------------------------------------------

                        _heroSection(
                          context,
                          lang,
                          isDark,
                        ),

                        const SizedBox(height: 20),

                        // ------------------------------------------------
                        // FILTERS
                        // ------------------------------------------------

                        Row(
                          children: [
                            _filterChip(
                              context,
                              title: "Pending",
                              displayTitle:
                                  lang.t("pending"),
                              selected:
                                  inquiryProvider
                                          .selectedFilter ==
                                      "Pending",
                            ),

                            const SizedBox(width: 9),

                            _filterChip(
                              context,
                              title: "Active",
                              displayTitle:
                                  lang.t("active"),
                              selected:
                                  inquiryProvider
                                          .selectedFilter ==
                                      "Active",
                            ),

                            const SizedBox(width: 9),

                            _filterChip(
                              context,
                              title: "History",
                              displayTitle:
                                  lang.t("history"),
                              selected:
                                  inquiryProvider
                                          .selectedFilter ==
                                      "History",
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ------------------------------------------------
                        // CONTENT
                        // ------------------------------------------------

                        if (inquiryProvider
                            .filteredInquiries
                            .isEmpty)
                          const _EmptyState()
                        else
                          ListView.builder(
                            itemCount: inquiryProvider
                                .filteredInquiries
                                .length,
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            itemBuilder:
                                (context, index) {
                              final inquiry =
                                  inquiryProvider
                                      .filteredInquiries[index];

                              return _InquiryCard(
                                inquiry: inquiry,

                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          FarmerInquiryDetailScreen(
                                        inquiryId:
                                            inquiry.id,
                                      ),
                                    ),
                                  );
                                },

                                onReject: () async {
                                  await inquiryProvider
                                      .rejectInquiry(
                                    inquiry.id,
                                  );
                                },

                                onAccept: () async {
                                  await inquiryProvider
                                      .acceptInquiry(
                                    inquiry.id,
                                  );

                                  if (!context.mounted) {
                                    return;
                                  }

                                  if (inquiryProvider
                                          .errorMessage ==
                                      null) {
                                    await context
                                        .read<ChatProvider>()
                                        .fetchConversations(
                                          showLoading: false,
                                        );
                                  }
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
    );
  }

  // ==============================================================
  // TOP BAR
  // ==============================================================

  Widget _topBar() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xff075739),
            Color(0xff0b704a),
          ],
        ),

        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),

      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // LEFT BUBBLE
          Positioned(
            left: -45,
            top: -55,
            child: Container(
              height: 155,
              width: 155,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(
                  alpha: 0.035,
                ),
              ),
            ),
          ),

          // RIGHT BUBBLE
          Positioned(
            right: -45,
            bottom: -70,
            child: Container(
              height: 165,
              width: 165,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(
                  alpha: 0.035,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              30,
              20,
              10,
            ),

            child: Row(
              children: [
                // LEFT ICON
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.13,
                    ),
                    borderRadius:
                        BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(
                        alpha: 0.08,
                      ),
                    ),
                  ),

                  child: const Icon(
                    Icons.agriculture_outlined,
                    color: Colors.white,
                    size: 27,
                  ),
                ),

                // TITLE
                const Expanded(
                  child: Center(
                    child: Text(
                      "Inquiries",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.6,
                      ),
                    ),
                  ),
                ),

                // RIGHT ICON
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.13,
                    ),
                    borderRadius:
                        BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(
                        alpha: 0.08,
                      ),
                    ),
                  ),

                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 27,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // HERO SECTION
  // ==============================================================

  Widget _heroSection(
    BuildContext context,
    LanguageProvider lang,
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      lang.t("receivedInquiries"),
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : const Color(0xff161d19),
                        fontSize: 27,
                        fontWeight:
                            FontWeight.w900,
                        letterSpacing: -0.7,
                      ),
                    ),
                  ),

                  const SizedBox(width: 7),

                  const Icon(
                    Icons.eco_rounded,
                    color: Color(0xff329a60),
                    size: 19,
                  ),
                ],
              ),

              const SizedBox(height: 7),

              Text(
                lang.t(
                  "receivedInquiriesSubtitle",
                ),
                style: TextStyle(
                  color: isDark
                      ? Colors.white60
                      : const Color(0xff68736d),
                  fontSize: 14,
                  height: 1.45,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        // SMALL PREMIUM ICON BOX
        Container(
          height: 78,
          width: 86,
          decoration: BoxDecoration(
            color: const Color(0xffe4f3e9),
            borderRadius:
                BorderRadius.circular(24),
          ),

          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 8,
                left: 10,
                right: 10,
                child: Container(
                  height: 15,
                  decoration: BoxDecoration(
                    color:
                        const Color(0xffcce8d5),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                ),
              ),

              const Icon(
                Icons.mark_email_unread_outlined,
                color: darkGreen,
                size: 40,
              ),

              const Positioned(
                top: 8,
                right: 12,
                child: Icon(
                  Icons.eco_rounded,
                  color: Color(0xff4ea971),
                  size: 17,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // FILTER CHIP
  // ==============================================================

  Widget _filterChip(
    BuildContext context, {
    required String title,
    required String displayTitle,
    required bool selected,
  }) {
    final provider =
        Provider.of<InquiryProvider>(
      context,
      listen: false,
    );

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    IconData icon;

    switch (title) {
      case "Pending":
        icon = Icons.schedule_rounded;
        break;

      case "Active":
        icon = Icons.eco_rounded;
        break;

      default:
        icon =
            Icons.inventory_2_outlined;
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          provider.changeFilter(title);
        },

        child: AnimatedContainer(
          duration:
              const Duration(milliseconds: 180),

          height: 52,

          decoration: BoxDecoration(
            color: selected
                ? darkGreen
                : isDark
                    ? const Color(0xff1d251f)
                    : Colors.white,

            borderRadius:
                BorderRadius.circular(27),

            border: Border.all(
              color: selected
                  ? darkGreen
                  : isDark
                      ? Colors.white12
                      : const Color(0xffd8e6de),
            ),

            boxShadow: selected
                ? [
                    BoxShadow(
                      color: darkGreen
                          .withValues(
                        alpha: 0.12,
                      ),
                      blurRadius: 12,
                      offset:
                          const Offset(0, 5),
                    ),
                  ]
                : [],
          ),

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              Icon(
                icon,
                size: 18,
                color: selected
                    ? Colors.white
                    : darkGreen,
              ),

              const SizedBox(width: 6),

              Flexible(
                child: Text(
                  displayTitle,
                  overflow:
                      TextOverflow.ellipsis,

                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : darkGreen,
                    fontSize: 12.5,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================================================================
// INQUIRY CARD
// ==================================================================

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
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final lang = context.watch<LanguageProvider>();

    final isPending =
        inquiry.status.toLowerCase() == "pending";

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),

      child: Container(
        margin: const EdgeInsets.only(bottom: 16),

        height: 170,

        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xff1d251f)
              : Colors.white,

          borderRadius: BorderRadius.circular(24),

          border: Border.all(
            color: isDark
                ? Colors.white12
                : const Color(0xffd8e6de),
            width: 1,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.045,
              ),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        clipBehavior: Clip.antiAlias,

        child: Row(
          children: [
            // =====================================================
            // PREMIUM CURVED IMAGE
            // =====================================================

            SizedBox(
              width: 150,
              height: double.infinity,

              child: Stack(
                children: [
                  // -------------------------------------------------
                  // IMAGE
                  // -------------------------------------------------

                  ClipPath(
                    clipper: _InquiryImageClipper(),

                    child: Image.network(
                      inquiry.cropImage,

                      width: 160,
                      height: double.infinity,

                      fit: BoxFit.cover,

                      errorBuilder: (_, __, ___) {
                        return Container(
                          width: 185,
                          height: double.infinity,
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

                  // -------------------------------------------------
                  // IMAGE DARK GRADIENT
                  // -------------------------------------------------

                  ClipPath(
                    clipper: _InquiryImageClipper(),

                    child: Container(
                      width: 185,
                      height: double.infinity,

                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,

                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(
                              alpha: 0.68,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // -------------------------------------------------
                  // CURVED GREEN BORDER
                  // -------------------------------------------------

                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter:
                        _InquiryImageCurvePainter(),
                      ),
                    ),
                  ),

                  // -------------------------------------------------
                  // CROP NAME
                  // -------------------------------------------------

                  Positioned(
                    left: 17,
                    right: 35,
                    bottom: 14,

                    child: Text(
                      inquiry.cropName,

                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // =====================================================
            // INFORMATION
            // =====================================================

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  14,
                  12,
                  12,
                  10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // =====================================================
                    // TOP ROW
                    // BUYER + STATUS
                    // =====================================================

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // BUYER
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              Text(
                                lang.t("buyer"),
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white54
                                      : const Color(0xff68736d),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Row(
                                children: [

                                  Container(
                                    height: 29,
                                    width: 29,
                                    decoration:
                                    const BoxDecoration(
                                      color: Color(0xffdff5e7),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      inquiry.buyerInitials,
                                      style: const TextStyle(
                                        color: darkGreen,
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w900,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 7),

                                  Flexible(
                                    child: Text(
                                      inquiry.buyerName,
                                      maxLines: 1,
                                      overflow:
                                      TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : const Color(
                                          0xff202723,
                                        ),
                                        fontSize: 14,
                                        fontWeight:
                                        FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // STATUS
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(
                              inquiry.status,
                            ).withValues(alpha: 0.11),
                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              Container(
                                height: 7,
                                width: 7,
                                decoration: BoxDecoration(
                                  color: _statusColor(
                                    inquiry.status,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),

                              const SizedBox(width: 5),

                              Text(
                                _statusLabel(
                                  inquiry.status,
                                  lang,
                                ),
                                style: TextStyle(
                                  color: _statusColor(
                                    inquiry.status,
                                  ),
                                  fontSize: 10.5,
                                  fontWeight:
                                  FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // =====================================================
                    // REQUESTED
                    // =====================================================

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.end,
                      children: [

                        Text(
                          lang.t("requested"),
                          style: TextStyle(
                            color: isDark
                                ? Colors.white54
                                : const Color(0xff000000),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(width: 8),


                        Text(
                          lang.tDynamic(
                            inquiry.requestedQuantity,
                          ),
                          style: const TextStyle(
                            color: darkGreen,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 7),

                    // =====================================================
                    // DIVIDER
                    // =====================================================

                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark
                          ? Colors.white12
                          : const Color(0xffe1e9e4),
                    ),

                    const Spacer(),

                    // =====================================================
                    // PROPOSED PRICE
                    // =====================================================

                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Text(
                          lang.t("proposedPrice"),
                          style: TextStyle(
                            color: isDark
                                ? Colors.white54
                                : const Color(0xff68736d),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          inquiry.proposedPrice,
                          style: const TextStyle(
                            color: darkGreen,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
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

  // ==============================================================
  // ACTION BUTTON
  // ==============================================================

  Widget _circleButton({
    required BuildContext context,
    required IconData icon,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),

      child: Container(
        height: 36,
        width: 36,

        decoration: BoxDecoration(
          color: filled
              ? darkGreen
              : Colors.white,

          shape: BoxShape.circle,

          border: Border.all(
            color: darkGreen,
            width: 1.2,
          ),
        ),

        child: Icon(
          icon,

          color: filled
              ? Colors.white
              : darkGreen,

          size: 19,
        ),
      ),
    );
  }

  // ==============================================================
  // STATUS LABEL
  // ==============================================================

  String _statusLabel(
      String status,
      LanguageProvider lang,
      ) {
    switch (status.toLowerCase()) {
      case "pending":
        return lang.t("pending");

      case "active":
      case "accepted":
        return lang.t("active");

      case "history":
      case "completed":
        return lang.t("history");

      default:
        return lang.tDynamic(status);
    }
  }

  // ==============================================================
  // STATUS COLOR
  // ==============================================================

  static Color _statusColor(
      String status,
      ) {
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

  // ==============================================================
  // SNACKBAR
  // ==============================================================

  void _showMessage(
      BuildContext context,
      String message,
      ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: darkGreen,
      ),
    );
  }
}

// ================================================================
// CURVED IMAGE CLIPPER
// ================================================================

class _InquiryImageClipper
    extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Top-left rounded corner
    path.moveTo(24, 0);

    path.quadraticBezierTo(
      0,
      0,
      0,
      24,
    );

    // Left side
    path.lineTo(
      0,
      size.height - 24,
    );

    // Bottom-left rounded corner
    path.quadraticBezierTo(
      0,
      size.height,
      24,
      size.height,
    );

    // Bottom curved edge
    path.lineTo(
      size.width - 28,
      size.height,
    );

    path.cubicTo(
      size.width - 17,
      size.height * 0.82,
      size.width - 8,
      size.height * 0.65,
      size.width - 8,
      size.height * 0.50,
    );

    // Top curved edge
    path.cubicTo(
      size.width - 8,
      size.height * 0.35,
      size.width - 17,
      size.height * 0.18,
      size.width - 28,
      0,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(
      covariant CustomClipper<Path> oldClipper,
      ) {
    return false;
  }
}


// ================================================================
// CURVED GREEN SEPARATOR
// ================================================================

class _InquiryImageCurvePainter
    extends CustomPainter {
  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final path = Path();

    path.moveTo(
      size.width - 28,
      0,
    );

    path.cubicTo(
      size.width - 17,
      size.height * 0.18,
      size.width - 8,
      size.height * 0.35,
      size.width - 8,
      size.height * 0.50,
    );

    path.cubicTo(
      size.width - 8,
      size.height * 0.65,
      size.width - 17,
      size.height * 0.82,
      size.width - 28,
      size.height,
    );

    final paint = Paint()
      ..color = const Color(0xff63c895)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ) {
    return false;
  }
}

// ==================================================================
// EMPTY STATE
// ==================================================================

class _EmptyState
    extends StatelessWidget {
  const _EmptyState();

  static const Color darkGreen =
      Color(0xff075739);

  @override
  Widget build(
    BuildContext context,
  ) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final lang =
        context.watch<LanguageProvider>();

    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 38,
      ),

      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xff1d251f)
            : Colors.white,

        borderRadius:
            BorderRadius.circular(24),

        border: Border.all(
          color: isDark
              ? Colors.white12
              : const Color(0xffd8e6de),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.035,
            ),
            blurRadius: 14,
            offset:
                const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        children: [
          Container(
            height: 72,
            width: 72,

            decoration:
                BoxDecoration(
              color:
                  const Color(0xffe4f3e9),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons
                  .mark_email_unread_outlined,
              color: darkGreen,
              size: 38,
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          Text(
            lang.t(
              "noInquiriesFound",
            ),

            style: TextStyle(
              color: isDark
                  ? Colors.white
                  : const Color(
                      0xff202723,
                    ),

              fontSize: 18,
              fontWeight:
                  FontWeight.w900,
            ),
          ),

          const SizedBox(
            height: 6,
          ),

          Text(
            lang.t(
              "noInquiriesSubtitle",
            ),

            textAlign:
                TextAlign.center,

            style: TextStyle(
              color: isDark
                  ? Colors.white60
                  : const Color(
                      0xff68736d,
                    ),

              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// ERROR STATE
// ==================================================================

class _ErrorState
    extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  static const Color darkGreen =
      Color(0xff075739);

  @override
  Widget build(
    BuildContext context,
  ) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final lang =
        context.watch<LanguageProvider>();

    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(22),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Container(
              height: 76,
              width: 76,

              decoration:
                  BoxDecoration(
                color: const Color(
                  0xffffeeee,
                ),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.wifi_off_rounded,
                color: Colors.red,
                size: 38,
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            Text(
              lang.t(
                "somethingWentWrong",
              ),

              style: TextStyle(
                color: isDark
                    ? Colors.white
                    : const Color(
                        0xff202723,
                      ),

                fontSize: 18,
                fontWeight:
                    FontWeight.w900,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              message,

              textAlign:
                  TextAlign.center,

              style: TextStyle(
                color: isDark
                    ? Colors.white60
                    : const Color(
                        0xff68736d,
                      ),

                fontSize: 14,
                height: 1.4,
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            ElevatedButton(
              onPressed: onRetry,

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    darkGreen,
                foregroundColor:
                    Colors.white,

                elevation: 0,

                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    24,
                  ),
                ),
              ),

              child: Text(
                lang.t("retry"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}