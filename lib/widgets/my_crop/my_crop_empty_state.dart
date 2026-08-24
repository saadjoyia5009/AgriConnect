import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/crop_provider.dart';
import '../../providers/language_provider.dart';

class MyCropEmptyState extends StatelessWidget {
  const MyCropEmptyState({super.key});

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final provider = context.read<CropProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 45,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff18211b) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white10
              : const Color(0xffe0ebe4),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xff20382a)
                  : const Color(0xffe9f6ed),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.eco_outlined,
              size: 42,
              color: darkGreen,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            "No ${lang.tDynamic(provider.selectedFilter)} crops found",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xff202622),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            "Add a crop or select another filter.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark
                  ? Colors.white60
                  : const Color(0xff727b76),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}