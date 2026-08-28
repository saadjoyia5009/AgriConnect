import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';

class MyCropsHero extends StatelessWidget {
  const MyCropsHero({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final secondary = isDark
        ? const Color(0xffb8c6bd)
        : const Color(0xff68736d);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 25, 18, 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        lang.t("myCrops"),
                        style: TextStyle(
                          color: isDark
                              ? Colors.white
                              : const Color(0xff161d19),
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    const Icon(
                      Icons.eco_rounded,
                      color: Color(0xff329a60),
                      size: 19,
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  _tr(
                    lang,
                    "manageCrops",
                    en: "Manage your crops and track their performance",
                    ur: "اپنی فصلوں کا انتظام کریں اور ان کی کارکردگی دیکھیں",
                  ),
                  style: TextStyle(
                    color: secondary,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 82,
            width: 96,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xff1d3327)
                  : const Color(0xffe4f3e9),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  bottom: 8,
                  left: 10,
                  right: 10,
                  child: Container(
                    height: 17,
                    decoration: BoxDecoration(
                      color: const Color(0xffcce8d5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/img_5.png',
                  width: 105,
                  height: 105,
                  fit: BoxFit.contain,
                ),
                const Positioned(
                  top: 9,
                  right: 14,
                  child: Icon(
                    Icons.eco_rounded,
                    color: Color(0xff4ea971),
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _tr(
      LanguageProvider lang,
      String key, {
        required String en,
        required String ur,
      }) {
    final translated = lang.t(key);
    return translated == key ? (lang.isUrdu ? ur : en) : translated;
  }
}
