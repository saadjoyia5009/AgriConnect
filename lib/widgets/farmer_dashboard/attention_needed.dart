import 'package:flutter/material.dart';

import 'dashboard_colors.dart';
import 'dashboard_models.dart';

class AttentionNeeded extends StatelessWidget {
  final int newInquiries;
  final dynamic weatherAlert;
  final bool isDark;
  final Color cardColor;
  final Color textColor;
  final String title;
  final String weatherAlertFallback;
  final bool isUrdu;
  final VoidCallback onMyCropsTap;
  final VoidCallback onWeatherTap;

  const AttentionNeeded({
    super.key,
    required this.newInquiries,
    required this.weatherAlert,
    required this.isDark,
    required this.cardColor,
    required this.textColor,
    required this.title,
    required this.weatherAlertFallback,
    required this.isUrdu,
    required this.onMyCropsTap,
    required this.onWeatherTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = <DashboardAttentionData>[];

    if (newInquiries > 0) {
      items.add(
        DashboardAttentionData(
          icon: Icons.chat_bubble_rounded,
          iconColor: DashboardColors.primaryGreen,
          text: isUrdu
              ? "$newInquiries ${newInquiries == 1 ? "خریدار کی انکوائری" : "خریداروں کی انکوائریز"} آپ کے جواب کی منتظر ہیں"
              : "$newInquiries buyer ${newInquiries == 1 ? "inquiry needs" : "inquiries need"} your response",
          onTap: onMyCropsTap,
        ),
      );
    }

    if (weatherAlert != null) {
      items.add(
        DashboardAttentionData(
          icon: Icons.cloud_outlined,
          iconColor: DashboardColors.blueColor,
          text: weatherAlert.title ?? weatherAlertFallback,
          onTap: onWeatherTap,
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? cardColor
            : const Color(0xfffffaf1),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white12
              : const Color(0xffffdfaa),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xffffc078)
                        : const Color(0xff8c4710),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: DashboardColors.orangeColor.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.priority_high_rounded,
                  color: DashboardColors.orangeColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: isDark
                    ? const Color(0xffffc078)
                    : const Color(0xff8c4710),
                size: 14,
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...items.map((item) => _AttentionItem(
            item: item,
            isDark: isDark,
            textColor: textColor,
          )),
        ],
      ),
    );
  }
}

class _AttentionItem extends StatelessWidget {
  final DashboardAttentionData item;
  final bool isDark;
  final Color textColor;

  const _AttentionItem({
    required this.item,
    required this.isDark,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? Colors.white12
                    : const Color(0xffffe5c0),
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: item.iconColor.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.icon,
                    color: item.iconColor,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xff777777),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
