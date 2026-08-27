import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';

class BuyerPromoCarousel extends StatefulWidget {
  const BuyerPromoCarousel({
    super.key,
    this.onBrowseTap,
  });

  final VoidCallback? onBrowseTap;

  @override
  State<BuyerPromoCarousel> createState() =>
      _BuyerPromoCarouselState();
}

class _BuyerPromoCarouselState
    extends State<BuyerPromoCarousel> {
  final PageController _pageController =
  PageController();

  Timer? _timer;

  int _currentPage = 0;

  static const Color darkGreen =
  Color(0xff0F5C3A);

  static const Color lightGreen =
  Color(0xff9ff2c1);

  final List<_PromoData> _slides = const [
    _PromoData(
      imageUrl:
      'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=1000',
      title: 'Buy Quality.',
      highlight: 'Support Farmers.',
    ),
    _PromoData(
      imageUrl:
      'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=1000',
      title: 'Fresh Crops.',
      highlight: 'Direct From Farms.',
    ),
    _PromoData(
      imageUrl:
      'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=1000',
      title: 'Better Prices.',
      highlight: 'Better Choices.',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 4),
          (_) {
        if (!_pageController.hasClients) return;

        _currentPage++;

        if (_currentPage >= _slides.length) {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration:
          const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang =
    context.watch<LanguageProvider>();

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return SizedBox(
      height: 220,
      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(24),

        child: Stack(
          children: [

            PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,

              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },

              itemBuilder:
                  (context, index) {
                final slide =
                _slides[index];

                return _buildSlide(
                  context,
                  slide,
                  lang,
                  isDark,
                );
              },
            ),

            // DOT INDICATORS
            Positioned(
              left: 0,
              right: 0,
              bottom: 13,

              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: List.generate(
                  _slides.length,
                      (index) {
                    final active =
                        index == _currentPage;

                    return AnimatedContainer(
                      duration:
                      const Duration(
                        milliseconds: 250,
                      ),

                      margin:
                      const EdgeInsets.symmetric(
                        horizontal: 3,
                      ),

                      height: 7,

                      width: active ? 20 : 7,

                      decoration:
                      BoxDecoration(
                        color: active
                            ? Colors.white
                            : Colors.white54,

                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(
      BuildContext context,
      _PromoData slide,
      LanguageProvider lang,
      bool isDark,
      ) {
    return Stack(
      fit: StackFit.expand,
      children: [

        Image.network(
          slide.imageUrl,
          fit: BoxFit.cover,

          errorBuilder:
              (_, __, ___) {
            return Container(
              color: darkGreen,
            );
          },
        ),

        // DARK OVERLAY
        Container(
          decoration:
          const BoxDecoration(
            gradient:
            LinearGradient(
              begin:
              Alignment.centerLeft,
              end:
              Alignment.centerRight,

              colors: [
                Color(0xcc06472f),
                Color(0x99064f34),
                Color(0x16064f34),
              ],
            ),
          ),
        ),

        Padding(
          padding:
          const EdgeInsets.fromLTRB(
            18,
            16,
            18,
            24,
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [

              // BADGE
              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),

                decoration:
                BoxDecoration(
                  color: Colors.white
                      .withValues(
                    alpha: 0.18,
                  ),

                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),

                  border: Border.all(
                    color: Colors.white24,
                  ),
                ),

                child: Row(
                  mainAxisSize:
                  MainAxisSize.min,

                  children: [
                    const Icon(
                      Icons.eco_rounded,
                      size: 14,
                      color:
                      Colors.white,
                    ),

                    const SizedBox(
                      width: 5,
                    ),

                    Text(
                      lang.isUrdu
                          ? 'فارم سے تازہ'
                          : 'Fresh from Farms',

                      style:
                      const TextStyle(
                        color:
                        Colors.white,
                        fontSize: 10,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Text(
                lang.isUrdu
                    ? 'معیاری فصلیں خریدیں'
                    : slide.title,

                style:
                const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight:
                  FontWeight.w900,
                ),
              ),

              Text(
                lang.isUrdu
                    ? 'کسانوں کو سپورٹ کریں'
                    : slide.highlight,

                style:
                const TextStyle(
                  color: lightGreen,
                  fontSize: 21,
                  fontWeight:
                  FontWeight.w900,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                lang.isUrdu
                    ? 'تازہ فصلیں براہِ راست کسانوں سے حاصل کریں'
                    : 'Get fresh crops directly from trusted farmers.',

                maxLines: 2,
                overflow:
                TextOverflow.ellipsis,

                style:
                const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  height: 1.4,
                  fontWeight:
                  FontWeight.w500,
                ),
              ),

              const SizedBox(height: 12),

              GestureDetector(
                onTap:
                widget.onBrowseTap,

                child: Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),

                  decoration:
                  BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(
                      12,
                    ),
                  ),

                  child: Row(
                    mainAxisSize:
                    MainAxisSize.min,

                    children: [

                      Text(
                        lang.isUrdu
                            ? 'فصلیں دیکھیں'
                            : 'Browse Crops',

                        style:
                        const TextStyle(
                          color:
                          darkGreen,
                          fontSize: 11,
                          fontWeight:
                          FontWeight.w900,
                        ),
                      ),

                      const SizedBox(
                        width: 6,
                      ),

                      const Icon(
                        Icons
                            .arrow_forward_rounded,
                        color:
                        darkGreen,
                        size: 17,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PromoData {
  final String imageUrl;
  final String title;
  final String highlight;

  const _PromoData({
    required this.imageUrl,
    required this.title,
    required this.highlight,
  });
}