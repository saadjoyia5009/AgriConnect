import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';

class MyCropHeader extends StatelessWidget {
  const MyCropHeader({super.key});

  static const Color darkGreen = Color(0xff075739);
  static const Color lightGreen = Color(0xffeaf6ef);

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Premium App Header
        Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? const [
                Color(0xff063d29),
                Color(0xff075739),
              ]
                  : const [
                Color(0xff075739),
                Color(0xff0b704a),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -45,
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.035),
                  ),
                ),
              ),

              Row(
                children: [
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    child: const Icon(
                      Icons.agriculture_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: Text(
                        lang.t("appName"),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 42),
                ],
              ),
            ],
          ),
        ),

        // My Crops Hero
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 28, 18, 20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xff121814) : const Color(0xfff7fbf8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          lang.t("myCrops"),
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xff161c19),
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.eco,
                          color: Color(0xff2a9d62),
                          size: 19,
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      "Manage your crops and track their performance",
                      style: TextStyle(
                        color: isDark
                            ? Colors.white60
                            : const Color(0xff65706a),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              // Agricultural visual
              Container(
                height: 82,
                width: 100,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xff173b2b)
                      : const Color(0xffe6f4eb),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      bottom: 7,
                      left: 8,
                      right: 8,
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xff205a3c)
                              : const Color(0xffcce8d6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.agriculture,
                      size: 48,
                      color: darkGreen,
                    ),
                    const Positioned(
                      top: 10,
                      right: 15,
                      child: Icon(
                        Icons.eco,
                        size: 18,
                        color: Color(0xff49a86f),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}