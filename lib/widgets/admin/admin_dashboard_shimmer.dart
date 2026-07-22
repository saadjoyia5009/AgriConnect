import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AdminDashboardShimmer extends StatelessWidget {
  const AdminDashboardShimmer({super.key});

  Widget _box({required bool isDark, double height = 80}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF15251E) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: isDark ? Border.all(color: Colors.white10) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF1E3128) : Colors.grey.shade300,
      highlightColor: isDark ? const Color(0xFF294236) : Colors.grey.shade100,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _box(isDark: isDark, height: 120),
          const SizedBox(height: 18),

          _box(isDark: isDark),
          const SizedBox(height: 14),

          _box(isDark: isDark),
          const SizedBox(height: 14),

          _box(isDark: isDark),
          const SizedBox(height: 18),

          _box(isDark: isDark, height: 240),
        ],
      ),
    );
  }
}
