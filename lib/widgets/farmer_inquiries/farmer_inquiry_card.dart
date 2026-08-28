import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/inquiry_model.dart';
import '../../providers/language_provider.dart';
import 'farmer_inquiry_card_shapes.dart';

class FarmerInquiryCard extends StatelessWidget {
  final InquiryModel inquiry;
  final Future<void> Function() onAccept;
  final Future<void> Function() onReject;
  final VoidCallback onTap;

  const FarmerInquiryCard({
    super.key,
    required this.inquiry,
    required this.onAccept,
    required this.onReject,
    required this.onTap,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 170,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff1d251f) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white12
                : const Color(0xffd8e6de),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.045),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            _InquiryImageSection(inquiry: inquiry),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BuyerAndStatus(
                      inquiry: inquiry,
                      isDark: isDark,
                      lang: lang,
                    ),
                    const SizedBox(height: 8),
                    _RequestedRow(
                      inquiry: inquiry,
                      isDark: isDark,
                      lang: lang,
                    ),
                    const SizedBox(height: 7),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark
                          ? Colors.white12
                          : const Color(0xffe1e9e4),
                    ),
                    const Spacer(),
                    _PriceSection(
                      inquiry: inquiry,
                      isDark: isDark,
                      lang: lang,
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
}

class _InquiryImageSection extends StatelessWidget {
  final InquiryModel inquiry;

  const _InquiryImageSection({required this.inquiry});

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 150,
      height: double.infinity,
      child: Stack(
        children: [
          ClipPath(
            clipper: InquiryImageClipper(),
            child: Image.network(
              inquiry.cropImage,
              width: 160,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 185,
                  height: double.infinity,
                  color: isDark
                      ? const Color(0xff193126)
                      : const Color(0xffe8f3ed),
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: darkGreen,
                    size: 38,
                  ),
                );
              },
            ),
          ),
          ClipPath(
            clipper: InquiryImageClipper(),
            child: Container(
              width: 185,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.68),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: InquiryImageCurvePainter(),
              ),
            ),
          ),
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
    );
  }
}

class _BuyerAndStatus extends StatelessWidget {
  final InquiryModel inquiry;
  final bool isDark;
  final LanguageProvider lang;

  const _BuyerAndStatus({
    required this.inquiry,
    required this.isDark,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xff244a37)
                          : const Color(0xffdff5e7),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      inquiry.buyerInitials,
                      style: const TextStyle(
                        color: Color(0xff075739),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Flexible(
                    child: Text(
                      inquiry.buyerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : const Color(0xff202723),
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _StatusChip(
          status: inquiry.status,
          lang: lang,
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  final LanguageProvider lang;

  const _StatusChip({
    required this.status,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final color = inquiryStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 7,
            width: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            inquiryStatusLabel(status, lang),
            style: TextStyle(
              color: color,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestedRow extends StatelessWidget {
  final InquiryModel inquiry;
  final bool isDark;
  final LanguageProvider lang;

  const _RequestedRow({
    required this.inquiry,
    required this.isDark,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          lang.t("requested"),
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          lang.tDynamic(inquiry.requestedQuantity),
          style: const TextStyle(
            color: Color(0xff075739),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _PriceSection extends StatelessWidget {
  final InquiryModel inquiry;
  final bool isDark;
  final LanguageProvider lang;

  const _PriceSection({
    required this.inquiry,
    required this.isDark,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            color: Color(0xff075739),
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

String inquiryStatusLabel(
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

Color inquiryStatusColor(String status) {
  switch (status.toLowerCase()) {
    case "active":
    case "accepted":
      return const Color(0xff075739);
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
