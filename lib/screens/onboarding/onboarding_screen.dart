import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const Color darkGreen = Color(0xFF0E5A3C);

  int currentIndex = 0;

  List<_OnboardingItem> _items(LanguageProvider lang) {
    return [
      _OnboardingItem(
        image: 'assets/images/onboarding.jpeg',
        title: lang.t('onboardingEmpoweringFarmersTitle'),
        subtitle: lang.t('onboardingEmpoweringFarmersSubtitle'),
      ),
      _OnboardingItem(
        image: 'assets/images/onboarding2.jpeg',
        title: lang.t('onboardingSmartInsightsTitle'),
        subtitle: lang.t('onboardingSmartInsightsSubtitle'),
      ),
      _OnboardingItem(
        image: 'assets/images/img.png',
        title: lang.t('onboardingDirectMarketplaceTitle'),
        subtitle: lang.t('onboardingDirectMarketplaceSubtitle'),
      ),
    ];
  }

  void _next(List<_OnboardingItem> items) {
    if (currentIndex == items.length - 1) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 550),
          pageBuilder: (_, animation, __) => const LoginScreen(),
          transitionsBuilder: (_, animation, __, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );

            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: 0.96,
                  end: 1.0,
                ).animate(curved),
                child: child,
              ),
            );
          },
        ),
      );
    } else {
      setState(() {
        currentIndex++;
      });
    }
  }

  Widget _centerLayout(
      Widget? currentChild,
      List<Widget> previousChildren,
      ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ...previousChildren,
        if (currentChild != null) currentChild,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final items = _items(lang);
    final item = items[currentIndex];

    return Scaffold(
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 750),
            switchInCurve: Curves.easeOutExpo,
            switchOutCurve: Curves.easeInExpo,
            layoutBuilder: _centerLayout,
            transitionBuilder: (child, animation) {
              final curved = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutExpo,
              );

              return FadeTransition(
                opacity: curved,
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.96,
                    end: 1.0,
                  ).animate(curved),
                  child: child,
                ),
              );
            },
            child: SizedBox(
              key: ValueKey(item.image),
              height: double.infinity,
              width: double.infinity,
              child: Image.asset(
                item.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 650),
              switchInCurve: Curves.easeOutExpo,
              switchOutCurve: Curves.easeInCubic,
              layoutBuilder: _centerLayout,
              transitionBuilder: (child, animation) {
                final curved = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutExpo,
                );

                return FadeTransition(
                  opacity: curved,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.96,
                      end: 1.0,
                    ).animate(curved),
                    child: child,
                  ),
                );
              },
              child: Container(
                key: ValueKey(item.title),
                width: double.infinity,
                height: 255,
                padding: const EdgeInsets.fromLTRB(22, 32, 22, 26),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: darkGreen,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.subtitle,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 15.5,
                        height: 1.45,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: List.generate(
                            items.length,
                                (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeOutCubic,
                              margin: const EdgeInsets.only(right: 8),
                              width: currentIndex == index ? 30 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: currentIndex == index
                                    ? darkGreen
                                    : const Color(0xFFE0E0E0),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          height: 52,
                          width: currentIndex == items.length - 1 ? 145 : 112,
                          child: ElevatedButton(
                            onPressed: () => _next(items),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: darkGreen,
                              foregroundColor: Colors.white,
                              elevation: 12,
                              shadowColor: darkGreen.withOpacity(0.35),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              layoutBuilder: _centerLayout,
                              child: currentIndex == items.length - 1
                                  ? Text(
                                lang.t("getStarted"),
                                key: const ValueKey("start"),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              )
                                  : Row(
                                key: const ValueKey("next"),
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    lang.t("next"),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingItem {
  final String image;
  final String title;
  final String subtitle;

  const _OnboardingItem({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}