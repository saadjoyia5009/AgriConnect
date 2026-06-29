import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AdminDashboardShimmer extends StatelessWidget {
  const AdminDashboardShimmer({super.key});

  Widget _box({double height = 80}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _box(height: 120),
          const SizedBox(height: 18),
          _box(),
          const SizedBox(height: 14),
          _box(),
          const SizedBox(height: 14),
          _box(),
          const SizedBox(height: 18),
          _box(height: 240),
        ],
      ),
    );
  }
}