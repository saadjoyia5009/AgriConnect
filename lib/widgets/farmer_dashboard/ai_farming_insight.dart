import 'package:flutter/material.dart';

import 'dashboard_colors.dart';

class AiFarmingInsight extends StatelessWidget {
  final dynamic weatherAlert;
  final bool isDark;
  final Color textColor;
  final Color subTextColor;
  final String sectionTitle;
  final String seeMore;
  final bool isUrdu;

  const AiFarmingInsight({
    super.key,
    required this.weatherAlert,
    required this.isDark,
    required this.textColor,
    required this.subTextColor,
    required this.sectionTitle,
    required this.seeMore,
    required this.isUrdu,
  });

  @override
  Widget build(BuildContext context) {
    final title = weatherAlert != null
        ? (isUrdu ? "کل بارش متوقع ہے۔" : "Rain is expected tomorrow.")
        : (isUrdu
        ? "اپنی کاشتکاری کی سرگرمیوں کی بہتر منصوبہ بندی کریں۔"
        : "Plan your farming activities smarter.");

    final description = weatherAlert != null
        ? (isUrdu
        ? "زیادہ پانی دینے سے بچنے کے لیے آج آبپاشی کم کرنے پر غور کریں۔"
        : "Consider reducing irrigation today to avoid overwatering.")
        : (isUrdu
        ? "بہتر فیصلوں کے لیے موسم اور مارکیٹ کی معلومات استعمال کریں۔"
        : "Use weather and market information to make better farming decisions.");

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [
            Color(0xff241d2f),
            Color(0xff2a2138),
          ]
              : const [
            Color(0xfffaf5ff),
            Color(0xfff6efff),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white12
              : const Color(0xffdfc9fa),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: DashboardColors.purpleColor,
                size: 18,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  sectionTitle,
                  style: const TextStyle(
                    color: DashboardColors.purpleColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                seeMore,
                style: const TextStyle(
                  color: DashboardColors.purpleColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: DashboardColors.purpleColor,
                size: 11,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                height: 62,
                width: 62,
                decoration: BoxDecoration(
                  color: DashboardColors.purpleColor.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.psychology_rounded,
                  color: DashboardColors.purpleColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: TextStyle(
                        color: subTextColor,
                        fontSize: 11.5,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
