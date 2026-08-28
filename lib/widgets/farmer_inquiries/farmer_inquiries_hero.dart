import 'package:flutter/material.dart';

class FarmerInquiriesHero extends StatelessWidget {
  final String title;
  final String subtitle;

  const FarmerInquiriesHero({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : const Color(0xff161d19),
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.7,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  const Icon(
                    Icons.eco_rounded,
                    color: Color(0xff329a60),
                    size: 19,
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Text(
                subtitle,
                style: TextStyle(
                  color: isDark
                      ? Colors.white60
                      : const Color(0xff68736d),
                  fontSize: 14,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 78,
          width: 86,
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xff193126)
                : const Color(0xffe4f3e9),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 8,
                left: 10,
                right: 10,
                child: Container(
                  height: 15,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xff244a37)
                        : const Color(0xffcce8d5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const Icon(
                Icons.mark_email_unread_outlined,
                color: Color(0xff075739),
                size: 40,
              ),
              const Positioned(
                top: 8,
                right: 12,
                child: Icon(
                  Icons.eco_rounded,
                  color: Color(0xff4ea971),
                  size: 17,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
