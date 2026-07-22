import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AdminCropShimmer extends StatelessWidget {
  const AdminCropShimmer({super.key});

  static const Color darkCard = Color(0xFF15251E);

  Widget _card(bool isDark) {
    return Container(
      height: 150,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? darkCard : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: isDark ? Border.all(color: Colors.white10) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF1B2B23) : Colors.grey.shade300,
      highlightColor: isDark ? const Color(0xFF263A30) : Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 6,
        itemBuilder: (_, __) => _card(isDark),
      ),
    );
  }
}
