import 'package:flutter/material.dart';
import '../../../models/buyer_profile_model.dart';

class BuyerProfileHeader extends StatelessWidget {
  final BuyerProfileModel profile;

  const BuyerProfileHeader({super.key, required this.profile});

  static const Color lightGreen = Color(0xff9ff2c1);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? lightGreen : const Color(0xff0F5C3A),
              width: 3,
            ),
          ),
          child: CircleAvatar(
            radius: 46,
            backgroundImage: NetworkImage(profile.imageUrl),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          profile.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xff10291D),
          ),
        ),
        const SizedBox(height: 5),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            profile.email,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xff5F675F),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
