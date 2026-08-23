import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';
import '../../widgets/language/language_card.dart';
import '../onboarding/onboarding_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  static const Color darkGreen = Color(0xFF0E5A3C);

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final selectedCode = lang.locale.languageCode;

    return Scaffold(
      body: Stack(
        children: [
          // ============================================================
          // CLEAR BACKGROUND IMAGE
          // ============================================================
          Positioned.fill(
            child: Image.asset(
              'assets/images/languagescreen.png',
              fit: BoxFit.cover,
            ),
          ),

          // ============================================================
          // VERY LIGHT OVERLAY
          // Only slight dimming - image stays clearly visible
          // ============================================================
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.08),
            ),
          ),

          // ============================================================
          // CONTENT
          // ============================================================
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compactHeight = constraints.maxHeight < 620;

                final horizontalPadding =
                constraints.maxWidth < 360 ? 14.0 : 20.0;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: compactHeight ? 14 : 24,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                      constraints.maxHeight -
                          (compactHeight ? 28 : 48),
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(
                              compactHeight ? 18 : 24,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.91),
                              borderRadius: BorderRadius.circular(30),

                              // Soft border
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.95),
                                width: 1.2,
                              ),

                              // Premium shadow
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.16),
                                  blurRadius: 35,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                              children: [
                                // ==========================================
                                // LANGUAGE ICON
                                // ==========================================
                                Center(
                                  child: Container(
                                    height: compactHeight ? 66 : 76,
                                    width: compactHeight ? 66 : 76,
                                    decoration: BoxDecoration(
                                      color: darkGreen.withValues(
                                        alpha: 0.10,
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: darkGreen.withValues(
                                          alpha: 0.12,
                                        ),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.language_rounded,
                                      size: compactHeight ? 34 : 38,
                                      color: darkGreen,
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: compactHeight ? 14 : 20,
                                ),

                                // ==========================================
                                // TITLE
                                // ==========================================
                                Text(
                                  lang.t("chooseLanguage"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: compactHeight ? 25 : 29,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                    color: darkGreen,
                                  ),
                                ),

                                const SizedBox(height: 7),

                                // ==========================================
                                // SUBTITLE
                                // ==========================================
                                Text(
                                  lang.t("chooseLanguageSubtitle"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: compactHeight ? 13.5 : 14.5,
                                    color: Colors.grey.shade700,
                                    height: 1.4,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                SizedBox(
                                  height: compactHeight ? 18 : 24,
                                ),

                                // ==========================================
                                // ENGLISH
                                // ==========================================
                                LanguageCard(
                                  title: lang.t("languageEnglish"),
                                  subtitle:
                                  lang.t("languageEnglishSubtitle"),
                                  icon: Icons.translate_rounded,
                                  isSelected: selectedCode == 'en',
                                  onTap: () {
                                    context
                                        .read<LanguageProvider>()
                                        .changeLanguage('en');
                                  },
                                ),

                                const SizedBox(height: 12),

                                // ==========================================
                                // URDU
                                // ==========================================
                                LanguageCard(
                                  title: lang.t("languageUrdu"),
                                  subtitle:
                                  lang.t("languageUrduSubtitle"),
                                  icon: Icons.language_rounded,
                                  isSelected: selectedCode == 'ur',
                                  onTap: () {
                                    context
                                        .read<LanguageProvider>()
                                        .changeLanguage('ur');
                                  },
                                ),

                                SizedBox(
                                  height: compactHeight ? 18 : 24,
                                ),

                                // ==========================================
                                // CONTINUE BUTTON
                                // ==========================================
                                SizedBox(
                                  height: 54,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: darkGreen,
                                      foregroundColor: Colors.white,
                                      elevation: 3,
                                      shadowColor: darkGreen.withValues(
                                        alpha: 0.30,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(17),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                          const OnboardingScreen(),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          lang.t("continue"),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
}