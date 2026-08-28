import 'package:flutter/material.dart';

import 'dashboard_colors.dart';

class DailyFarmingTip extends StatelessWidget {
  final bool isDark;
  final Color cardColor;
  final Color textColor;
  final Color subTextColor;
  final String sectionTitle;
  final String seeMore;
  final List<Map<String, dynamic>> tips;

  const DailyFarmingTip({
    super.key,
    required this.isDark,
    required this.cardColor,
    required this.textColor,
    required this.subTextColor,
    required this.sectionTitle,
    required this.seeMore,
    required this.tips,
  });

  @override
  Widget build(BuildContext context) {
    final todayIndex = DateTime.now().day % tips.length;
    final todayTip = tips[todayIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? cardColor
            : const Color(0xfff4fbf2),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white12
              : const Color(0xffcce6c9),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_rounded,
                color: Color(0xffffae1a),
                size: 19,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  sectionTitle,
                  style: const TextStyle(
                    color: DashboardColors.darkGreen,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                seeMore,
                style: const TextStyle(
                  color: DashboardColors.darkGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: DashboardColors.darkGreen,
                size: 11,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  color: DashboardColors.primaryGreen.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  todayTip["icon"] as IconData,
                  color: DashboardColors.primaryGreen,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todayTip["title"] as String,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      todayTip["tip"] as String,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
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
              const SizedBox(width: 8),
              const Icon(
                Icons.search_rounded,
                color: DashboardColors.primaryGreen,
                size: 34,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
