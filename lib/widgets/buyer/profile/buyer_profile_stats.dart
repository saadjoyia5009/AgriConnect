import 'package:flutter/material.dart';
import '../../../models/buyer_profile_model.dart';

class BuyerProfileStats extends StatelessWidget {
  final BuyerProfileModel profile;

  const BuyerProfileStats({
    super.key,
    required this.profile,
  });

  static const Color darkGreen = Color(0xff0F5C3A);
  static const Color darkCard = Color(0xFF15251E);
  static const Color lightGreen = Color(0xff9ff2c1);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _statBox(
          context,
          "Inquiries",
          profile.totalInquiries.toString(),
        ),
        const SizedBox(width: 10),
        _statBox(
          context,
          "Deals",
          profile.acceptedDeals.toString(),
        ),
        const SizedBox(width: 10),
        _statBox(
          context,
          "Favorites",
          profile.favoriteCrops.toString(),
        ),
      ],
    );
  }

  Widget _statBox(
      BuildContext context,
      String title,
      String value,
      ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isDark ? darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white10
                : const Color(0xffDCE7DD),
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: isDark
                    ? lightGreen
                    : darkGreen,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? Colors.white70
                    : const Color(0xff5F675F),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}