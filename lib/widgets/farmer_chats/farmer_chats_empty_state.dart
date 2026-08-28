import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';

class FarmerChatsEmptyState extends StatelessWidget {
  const FarmerChatsEmptyState({super.key});

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 90),
        Container(
          height: 100,
          width: 100,
          margin: const EdgeInsets.symmetric(horizontal: 115),
          decoration: const BoxDecoration(
            color: Color(0xffe5f5e9),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.chat_bubble_outline_rounded,
            size: 46,
            color: darkGreen,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          lang.t('noChatsFound'),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xff222a26),
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          lang.t('acceptedInquiriesChatSubtitle'),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? Colors.white38 : const Color(0xff7b837e),
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
