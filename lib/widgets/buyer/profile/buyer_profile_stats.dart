import 'package:flutter/material.dart';
import '../../../models/buyer_profile_model.dart';

class BuyerProfileStats extends StatelessWidget {
  final BuyerProfileModel profile;

  const BuyerProfileStats({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _statBox("Inquiries", profile.totalInquiries.toString()),
        const SizedBox(width: 10),
        _statBox("Deals", profile.acceptedDeals.toString()),
        const SizedBox(width: 10),
        _statBox("Favorites", profile.favoriteCrops.toString()),
      ],
    );
  }

  Widget _statBox(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xffDCE7DD)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xff0F5C3A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xff5F675F),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}