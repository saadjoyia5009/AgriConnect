import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';

class FarmerInquiryErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const FarmerInquiryErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 76,
              width: 76,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xff3a2020)
                    : const Color(0xffffeeee),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                color: Colors.red,
                size: 38,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              lang.t("somethingWentWrong"),
              style: TextStyle(
                color: isDark
                    ? Colors.white
                    : const Color(0xff202723),
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark
                    ? Colors.white60
                    : const Color(0xff68736d),
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(lang.t("retry")),
            ),
          ],
        ),
      ),
    );
  }
}
