import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/crop_model.dart';
import '../../providers/language_provider.dart';
import '../../core/responsive/app_breakpoints.dart';

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

  static const Color darkGreen =
      Color(0xff0F5C3A);

  static const Color darkCard =
      Color(0xff14231C);

  static const Color lightGreen =
      Color(0xff9ff2c1);

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final lang =
        context.watch<LanguageProvider>();

    return GestureDetector(
      onTap: onTap,

      child: Container(
        width:
            AppBreakpoints.isMobile(
          context,
        )
                ? 215
                : double.infinity,

        margin:
            AppBreakpoints.isMobile(
          context,
        )
                ? const EdgeInsetsDirectional
                    .only(end: 14)
                : EdgeInsets.zero,

        decoration:
            BoxDecoration(
          color: isDark
              ? darkCard
              : Colors.white,

          borderRadius:
              BorderRadius.circular(24),

          border: Border.all(
            color: isDark
                ? Colors.white10
                : const Color(
                    0xffE0E9E2,
                  ),
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(
                alpha:
                    isDark ? 0.22 : 0.055,
              ),
              blurRadius: 18,
              offset:
                  const Offset(0, 8),
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(24),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // ==================================================
              // IMAGE
              // ==================================================

              SizedBox(
                height: 130,
                width: double.infinity,

                child: Stack(
                  fit: StackFit.expand,

                  children: [

                    Image.network(
                      crop.imageUrl,
                      fit: BoxFit.cover,

                      errorBuilder:
                          (_, __, ___) {
                        return Container(
                          color: isDark
                              ? const Color(
                                  0xff1D3027,
                                )
                              : const Color(
                                  0xffEAF4ED,
                                ),

                          child: Icon(
                            Icons
                                .agriculture_rounded,
                            size: 42,
                            color:
                                darkGreen,
                          ),
                        );
                      },
                    ),

                    // IMAGE GRADIENT
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration:
                            BoxDecoration(
                          gradient:
                              LinearGradient(
                            begin:
                                Alignment
                                    .topCenter,
                            end:
                                Alignment
                                    .bottomCenter,
                            colors: [
                              Colors
                                  .transparent,
                              Colors.black
                                  .withValues(
                                alpha:
                                    0.48,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ORGANIC BADGE
                    if (crop.isOrganic)
                      Positioned(
                        left: 10,
                        top: 10,

                        child:
                            Container(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),

                          decoration:
                              BoxDecoration(
                            color: Colors.white
                                .withValues(
                              alpha: 0.92,
                            ),

                            borderRadius:
                                BorderRadius
                                    .circular(
                              20,
                            ),
                          ),

                          child: Row(
                            mainAxisSize:
                                MainAxisSize.min,

                            children: [
                              const Icon(
                                Icons
                                    .eco_rounded,
                                size: 13,
                                color:
                                    darkGreen,
                              ),

                              const SizedBox(
                                width: 4,
                              ),

                              Text(
                                lang.t(
                                  "organic",
                                ),
                                style:
                                    const TextStyle(
                                  color:
                                      darkGreen,
                                  fontSize: 10,
                                  fontWeight:
                                      FontWeight
                                          .w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // FAVORITE
                    Positioned(
                      right: 10,
                      top: 10,

                      child:
                          GestureDetector(
                        onTap:
                            onFavoriteTap,

                        child:
                            Container(
                          height: 34,
                          width: 34,

                          decoration:
                              BoxDecoration(
                            color: Colors.white
                                .withValues(
                              alpha: 0.92,
                            ),
                            shape:
                                BoxShape
                                    .circle,
                          ),

                          child: Icon(
                            isFavorite
                                ? Icons
                                    .favorite_rounded
                                : Icons
                                    .favorite_border_rounded,
                            size: 18,
                            color:
                                isFavorite
                                    ? Colors
                                        .red
                                    : darkGreen,
                          ),
                        ),
                      ),
                    ),

                    // CROP NAME
                    Positioned(
                      left: 12,
                      bottom: 10,

                      child: Text(
                        crop.name,
                        maxLines: 1,
                        overflow:
                            TextOverflow
                                .ellipsis,

                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                          fontSize: 17,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ==================================================
              // DETAILS
              // ==================================================

              Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  13,
                  12,
                  13,
                  13,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    // LOCATION
                    Row(
                      children: [
                        Icon(
                          Icons
                              .location_on_outlined,
                          size: 15,
                          color: isDark
                              ? Colors.white54
                              : const Color(
                                  0xff77817B,
                                ),
                        ),

                        const SizedBox(
                          width: 4,
                        ),

                        Expanded(
                          child: Text(
                            crop.location,
                            maxLines: 1,
                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                TextStyle(
                              color: isDark
                                  ? Colors
                                      .white70
                                  : const Color(
                                      0xff66716B,
                                    ),
                              fontSize: 11,
                              fontWeight:
                                  FontWeight
                                      .w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 13,
                    ),

                    // PRICE + ADD
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .end,

                      children: [

                        Expanded(
                          child: RichText(
                            text:
                                TextSpan(
                              children: [

                                TextSpan(
                                  text:
                                      'Rs. ${crop.price}',
                                  style:
                                      TextStyle(
                                    color:
                                        isDark
                                            ? lightGreen
                                            : darkGreen,
                                    fontSize:
                                        17,
                                    fontWeight:
                                        FontWeight
                                            .w900,
                                  ),
                                ),

                                TextSpan(
                                  text:
                                      ' ${lang.tDynamic(crop.unit)}',
                                  style:
                                      TextStyle(
                                    color:
                                        isDark
                                            ? Colors
                                                .white60
                                            : const Color(
                                                0xff66716B,
                                              ),
                                    fontSize:
                                        11,
                                    fontWeight:
                                        FontWeight
                                            .w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: onAddTap,

                          child:
                              Container(
                            height: 36,
                            width: 36,

                            decoration:
                                BoxDecoration(
                              color:
                                  darkGreen,
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                12,
                              ),
                            ),

                            child:
                                const Icon(
                              Icons
                                  .add_rounded,
                              color:
                                  Colors.white,
                              size: 21,
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