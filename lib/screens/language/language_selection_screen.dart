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
      backgroundColor: const Color(0xFFF4F8F5),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compactHeight = constraints.maxHeight < 620;
            final horizontalPadding = constraints.maxWidth < 360 ? 16.0 : 22.0;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: compactHeight ? 16 : 26,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - (compactHeight ? 32 : 52),
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!compactHeight) const Spacer(),

                      Center(
                        child: Container(
                          height: 86,
                          width: 86,
                          decoration: BoxDecoration(
                            color: darkGreen.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.language_rounded,
                            size: 44,
                            color: darkGreen,
                          ),
                        ),
                      ),

                      SizedBox(height: compactHeight ? 16 : 28),

                      Center(
                        child: Text(
                          lang.t("chooseLanguage"),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: darkGreen,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Center(
                        child: Text(
                          lang.t("chooseLanguageSubtitle"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                      ),

                      SizedBox(height: compactHeight ? 20 : 36),

                      LanguageCard(
                        title: lang.t("languageEnglish"),
                        subtitle: lang.t("languageEnglishSubtitle"),
                        icon: Icons.translate_rounded,
                        isSelected: selectedCode == 'en',
                        onTap: () {
                          context.read<LanguageProvider>().changeLanguage('en');
                        },
                      ),

                      const SizedBox(height: 16),

                      LanguageCard(
                        title: lang.t("languageUrdu"),
                        subtitle: lang.t("languageUrduSubtitle"),
                        icon: Icons.language_rounded,
                        isSelected: selectedCode == 'ur',
                        onTap: () {
                          context.read<LanguageProvider>().changeLanguage('ur');
                        },
                      ),

                      SizedBox(height: compactHeight ? 20 : 28),
                      if (!compactHeight) const Spacer(),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OnboardingScreen(),
                              ),
                            );
                          },
                          child: Text(
                            lang.t("continue"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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
    );
  }
}
