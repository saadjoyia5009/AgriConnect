import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';

class FarmerInquiryEmptyState extends StatelessWidget {
  const FarmerInquiryEmptyState({super.key});

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 38,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xff1d251f)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white12
              : const Color(0xffd8e6de),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xff193126)
                  : const Color(0xffe4f3e9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_unread_outlined,
              color: darkGreen,
              size: 38,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            lang.t("noInquiriesFound"),
            style: TextStyle(
              color: isDark
                  ? Colors.white
                  : const Color(0xff202723),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            lang.t("noInquiriesSubtitle"),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark
                  ? Colors.white60
                  : const Color(0xff68736d),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
