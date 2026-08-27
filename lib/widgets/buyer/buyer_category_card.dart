import 'package:flutter/material.dart';

class BuyerCategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final IconData? icon;
  final VoidCallback? onTap;

  const BuyerCategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.icon,
    this.onTap,
  });

  static const Color darkGreen =
      Color(0xff0F5C3A);

  static const Color lightGreen =
      Color(0xff9ff2c1);

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final hasImage =
        imageUrl != null &&
        imageUrl!.trim().isNotEmpty;

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(22),

        child: Container(
          decoration:
              BoxDecoration(
            color: hasImage
                ? null
                : isDark
                    ? const Color(
                        0xff16271F,
                      )
                    : Colors.white,

            borderRadius:
                BorderRadius.circular(22),

            border: Border.all(
              color: isDark
                  ? Colors.white10
                  : const Color(
                      0xffE0E9E2,
                    ),
            ),

            image: hasImage
                ? DecorationImage(
                    image: NetworkImage(
                      imageUrl!,
                    ),
                    fit: BoxFit.cover,

                    colorFilter:
                        ColorFilter.mode(
                      Colors.black
                          .withValues(
                        alpha:
                            isDark
                                ? 0.55
                                : 0.30,
                      ),
                      BlendMode.darken,
                    ),
                  )
                : null,

            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withValues(
                  alpha:
                      isDark ? 0.18 : 0.035,
                ),
                blurRadius: 14,
                offset:
                    const Offset(0, 6),
              ),
            ],
          ),

          padding:
              const EdgeInsets.all(10),

          child: hasImage
              ? Column(
                  mainAxisAlignment:
                      MainAxisAlignment.end,

                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,

                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),

                    if (subtitle
                        .isNotEmpty) ...[
                      const SizedBox(
                        height: 2,
                      ),

                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,

                        style:
                            const TextStyle(
                          color:
                              Colors.white70,
                          fontSize: 9,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                )
              : Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    Container(
                      height: 42,
                      width: 42,

                      decoration:
                          BoxDecoration(
                        color: isDark
                            ? darkGreen
                            : const Color(
                                0xffE4F6EA,
                              ),
                        shape:
                            BoxShape.circle,
                      ),

                      child: Icon(
                        icon ??
                            Icons
                                .category_rounded,
                        color: isDark
                            ? lightGreen
                            : darkGreen,
                        size: 22,
                      ),
                    ),

                    const SizedBox(
                      height: 7,
                    ),

                    Text(
                      title,
                      textAlign:
                          TextAlign.center,

                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,

                      style:
                          TextStyle(
                        color: isDark
                            ? Colors.white
                            : const Color(
                                0xff1F2722,
                              ),
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}