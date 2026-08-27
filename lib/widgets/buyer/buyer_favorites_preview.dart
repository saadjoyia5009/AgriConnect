import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/crop_model.dart';
import '../../providers/buyer_favorite_provider.dart';
import '../../providers/language_provider.dart';

class BuyerFavoritesPreview extends StatelessWidget {
  const BuyerFavoritesPreview({
    super.key,
    required this.crops,
    this.onViewAll,
  });

  final List<CropModel> crops;
  final VoidCallback? onViewAll;

  static const Color darkGreen =
  Color(0xff0F5C3A);

  static const Color lightGreen =
  Color(0xff9ff2c1);

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final lang =
    context.watch<LanguageProvider>();

    final favoriteProvider =
    context.watch<BuyerFavoriteProvider>();

    final favorites =
    crops.where(
          (crop) =>
          favoriteProvider
              .isFavorite(crop.id),
    ).toList();

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xff14231C)
            : Colors.white,

        borderRadius:
        BorderRadius.circular(24),

        border: Border.all(
          color: isDark
              ? Colors.white10
              : const Color(
            0xffE3ECE5,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha:
              isDark ? 0.18 : 0.04,
            ),
            blurRadius: 16,
            offset:
            const Offset(0, 7),
          ),
        ],
      ),

      child: Column(
        children: [

          // HEADER
          Row(
            children: [

              Container(
                height: 38,
                width: 38,

                decoration:
                BoxDecoration(
                  color: isDark
                      ? const Color(
                    0xff29342F,
                  )
                      : const Color(
                    0xffffeeee,
                  ),
                  shape:
                  BoxShape.circle,
                ),

                child: const Icon(
                  Icons.favorite_rounded,
                  color:
                  Color(0xffE64A4A),
                  size: 19,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  lang.isUrdu
                      ? 'پسندیدہ فصلیں'
                      : 'My Favorites',

                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : const Color(
                      0xff18211C,
                    ),
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w900,
                  ),
                ),
              ),

              GestureDetector(
                onTap: onViewAll,

                child: Row(
                  children: [

                    Text(
                      lang.isUrdu
                          ? 'سب دیکھیں'
                          : 'View All',

                      style:
                      TextStyle(
                        color: isDark
                            ? lightGreen
                            : darkGreen,
                        fontSize: 11,
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),

                    const SizedBox(
                      width: 3,
                    ),

                    Icon(
                      Icons
                          .arrow_forward_rounded,
                      size: 15,
                      color: isDark
                          ? lightGreen
                          : darkGreen,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          if (favorites.isEmpty)
            _emptyState(
              context,
              lang,
            )
          else
            SizedBox(
              height: 70,

              child: ListView.separated(
                scrollDirection:
                Axis.horizontal,

                itemCount:
                favorites.length > 5
                    ? 5
                    : favorites.length,

                separatorBuilder:
                    (_, __) =>
                const SizedBox(
                  width: 10,
                ),

                itemBuilder:
                    (context, index) {
                  final crop =
                  favorites[index];

                  return ClipRRect(
                    borderRadius:
                    BorderRadius.circular(
                      16,
                    ),

                    child:
                    Image.network(
                      crop.imageUrl,

                      width: 70,
                      height: 70,

                      fit: BoxFit.cover,

                      errorBuilder:
                          (_, __, ___) {
                        return Container(
                          width: 70,
                          height: 70,

                          color: isDark
                              ? const Color(
                            0xff20392E,
                          )
                              : const Color(
                            0xffEAF5ED,
                          ),

                          child: Icon(
                            Icons
                                .agriculture_rounded,
                            color:
                            darkGreen,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _emptyState(
      BuildContext context,
      LanguageProvider lang,
      ) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.symmetric(
        vertical: 14,
      ),

      child: Text(
        lang.isUrdu
            ? 'آپ کی پسندیدہ فصلیں یہاں نظر آئیں گی'
            : 'Your favorite crops will appear here',

        textAlign:
        TextAlign.center,

        style: TextStyle(
          color: isDark
              ? Colors.white54
              : const Color(
            0xff748078,
          ),
          fontSize: 11,
          fontWeight:
          FontWeight.w600,
        ),
      ),
    );
  }
}