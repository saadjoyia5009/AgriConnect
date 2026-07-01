import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';
import 'onboarding_screen_three.dart';
import 'package:animations/animations.dart';

class OnboardingScreenTwo extends StatefulWidget {
  const OnboardingScreenTwo({super.key});

  @override
  State<OnboardingScreenTwo> createState() => _OnboardingScreenTwoState();
}

class _OnboardingScreenTwoState extends State<OnboardingScreenTwo>
    with SingleTickerProviderStateMixin {
  static const Color darkGreen = Color(0xFF0E5A3C);

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _cardSlide;
  late final Animation<double> _imageScale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo));

    _imageScale = Tween<double>(
      begin: 1.08,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goNext(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, __, ___) => const OnboardingScreenThree(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      body: FadeTransition(
        opacity: _fade,
        child: Stack(
          children: [
            ScaleTransition(
              scale: _imageScale,
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/onboarding2.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: _cardSlide,
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: 245,
                    maxHeight: MediaQuery.of(context).size.height * 0.42,
                  ),
                  padding: const EdgeInsets.fromLTRB(22, 34, 22, 28),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          lang.t("onboardingSmartInsightsTitle"),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: darkGreen,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          lang.t("onboardingSmartInsightsSubtitle"),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 15.5,
                            height: 1.45,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                _dot(),
                                const SizedBox(width: 8),
                                _activeDot(),
                                const SizedBox(width: 8),
                                _dot(),
                              ],
                            ),
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.95, end: 1),
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.elasticOut,
                              builder: (context, scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: child,
                                );
                              },
                              child: SizedBox(
                                height: 52,
                                width: 124,
                                child: ElevatedButton(
                                  onPressed: () => _goNext(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: darkGreen,
                                    foregroundColor: Colors.white,
                                    elevation: 12,
                                    shadowColor: darkGreen.withValues(
                                      alpha: 0.35,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          lang.t("next"),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 22,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _activeDot() {
    return Container(
      width: 30,
      height: 8,
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _dot() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0xFFE0E0E0),
        shape: BoxShape.circle,
      ),
    );
  }
}
