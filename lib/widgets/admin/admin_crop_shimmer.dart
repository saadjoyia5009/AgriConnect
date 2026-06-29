import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AdminCropShimmer extends StatelessWidget {
  const AdminCropShimmer({super.key});

  Widget _card() {
    return Container(
      height: 150,
      margin: const EdgeInsets.only(bottom: 14),
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
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 6,
        itemBuilder: (_, __) => _card(),
      ),
    );
  }
}