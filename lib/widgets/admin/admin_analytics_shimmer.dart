import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AdminAnalyticsShimmer extends StatelessWidget {
  const AdminAnalyticsShimmer({super.key});

  Widget _box({double height = 90}) {
    return Container(
      height: height,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
          _box(height: 110),
          _box(height: 260),
          _box(height: 260),
          _box(height: 260),
        ],
      ),
    );
  }
}
