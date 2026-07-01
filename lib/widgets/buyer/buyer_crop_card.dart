import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/crop_model.dart';
import '../../providers/language_provider.dart';

class BuyerCropCard extends StatelessWidget {
  final CropModel crop;
  final VoidCallback? onTap;
  final VoidCallback? onAddTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  const BuyerCropCard({
    super.key,
    required this.crop,
    this.onTap,
    this.onAddTap,
    this.onFavoriteTap,
    this.isFavorite = false,
  });

  static const Color darkGreen = Color(0xff0F5C3A);
  static const Color darkCard = Color(0xFF15251E);
  static const Color lightGreen = Color(0xff9ff2c1);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: isDark ? darkCard : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? Colors.white10 : const Color(0xffE2E8E1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.22 : 0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    crop.imageUrl,
                    height: 112,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xff1E1E1E) : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? Colors.white12 : Colors.transparent,
                          ),
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: isFavorite
                              ? Colors.red
                              : (isDark ? Colors.white70 : const Color(0xff9AA39C)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            crop.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        if (crop.isOrganic)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? darkGreen.withOpacity(0.30)
                                  : const Color(0xffDCF5E1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              lang.t("organic"),
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark ? lightGreen : darkGreen,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: isDark ? Colors.white60 : const Color(0xff6B7280),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            crop.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : const Color(0xff5F675F),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${crop.price} ',
                                  style: TextStyle(
                                    color: isDark ? lightGreen : darkGreen,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                TextSpan(
                                  text: lang.tDynamic(crop.unit),
                                  style: TextStyle(
                                    color: isDark ? Colors.white70 : const Color(0xff5F675F),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: onAddTap,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: darkGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
