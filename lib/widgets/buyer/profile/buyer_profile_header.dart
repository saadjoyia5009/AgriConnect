import 'package:flutter/material.dart';
import '../../../models/buyer_profile_model.dart';

class BuyerProfileHeader extends StatelessWidget {
  final BuyerProfileModel profile;

  const BuyerProfileHeader({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 46,
          backgroundImage: NetworkImage(profile.imageUrl),
        ),
        const SizedBox(height: 12),
        Text(
          profile.name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Color(0xff10291D),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          profile.email,
          style: const TextStyle(
            color: Color(0xff5F675F),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}