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
    final languageProvider = context.watch<LanguageProvider>();
    final selectedCode = languageProvider.locale.languageCode;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              Center(
                child: Container(
                  height: 86,
                  width: 86,
                  decoration: BoxDecoration(
                    color: darkGreen.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.language_rounded,
                    size: 44,
                    color: darkGreen,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              const Center(
                child: Text(
                  "Choose Language",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: darkGreen,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  "Select your preferred language to continue",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 36),

              LanguageCard(
                title: "English",
                subtitle: "Use app in English",
                icon: Icons.translate_rounded,
                isSelected: selectedCode == 'en',
                onTap: () {
                  context.read<LanguageProvider>().changeLanguage('en');
                },
              ),

              const SizedBox(height: 16),

              LanguageCard(
                title: "اردو",
                subtitle: "ایپ اردو میں استعمال کریں",
                icon: Icons.language_rounded,
                isSelected: selectedCode == 'ur',
                onTap: () {
                  context.read<LanguageProvider>().changeLanguage('ur');
                },
              ),

              const Spacer(),

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
                  child: const Text(
                    "Continue",
                    style: TextStyle(
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
  }
}