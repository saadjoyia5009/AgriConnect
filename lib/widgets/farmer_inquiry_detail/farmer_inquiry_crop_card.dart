import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/inquiry_model.dart';
import '../../providers/language_provider.dart';
import 'farmer_inquiry_detail_crop_clipper.dart';

class FarmerInquiryCropCard extends StatelessWidget {
  final InquiryModel inquiry;

  const FarmerInquiryCropCard({
    super.key,
    required this.inquiry,
  });

  static const Color darkGreen = Color(0xff075739);
  static const Color lightGreen = Color(0xffe9f7ef);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = (screenWidth * 0.56).clamp(245.0, 330.0);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff172019) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark
              ? Colors.white12
              : const Color(0xffcfe5d8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(
            height: imageHeight,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipPath(
                    clipper: InquiryImageCurveClipper(),
                    child: Container(
                      color: const Color(0xff48b980),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ClipPath(
                      clipper: InquiryImageCurveClipper(bottomPadding: 10),
                      child: Image.network(
                        inquiry.cropImage,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            color: isDark
                                ? Colors.white10
                                : lightGreen,
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
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
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ClipPath(
                      clipper: InquiryImageCurveClipper(bottomPadding: 10),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.72),
                              Colors.black.withValues(alpha: 0.20),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.45, 0.85],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 27,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        inquiry.cropName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.6,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        lang.t("requestedValue").replaceAll(
                          "{value}",
                          lang.tDynamic(inquiry.requestedQuantity),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _InfoText(
                    title: lang.t("proposedPriceCaps"),
                    value: inquiry.proposedPrice,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white10
                        : const Color(0xffeaf6ee),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: isDark ? Colors.white : darkGreen,
                        size: 19,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        lang.t("viewListing"),
                        style: TextStyle(
                          color: isDark ? Colors.white : darkGreen,
                          fontSize: 13,
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
}

class _InfoText extends StatelessWidget {
  final String title;
  final String value;

  const _InfoText({
    required this.title,
    required this.value,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
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
}
