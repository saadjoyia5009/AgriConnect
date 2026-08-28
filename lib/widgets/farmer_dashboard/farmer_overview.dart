import 'package:flutter/material.dart';
import 'dashboard_colors.dart';

class FarmerOverview extends StatelessWidget {
  final bool isDark;
  final Color cardColor;
  final Color subTextColor;
  final Color softBorderColor;
  final String welcomeText;
  final String subtitleText;
  final String activeCrops;
  final String activeCropsTitle;
  final String inquiries;
  final String inquiriesTitle;
  final String thisSeasonTitle;
  final String thisSeasonValue;
  final String priceTrendTitle;
  final String priceTrendValue;
  final String weatherTitle;
  final String weatherValue;
  final VoidCallback onWeatherTap;
  final VoidCallback onVoiceTap;
  final String voiceText;

  const FarmerOverview({
    super.key,
    required this.isDark,
    required this.cardColor,
    required this.subTextColor,
    required this.softBorderColor,
    required this.welcomeText,
    required this.subtitleText,
    required this.activeCrops,
    required this.activeCropsTitle,
    required this.inquiries,
    required this.inquiriesTitle,
    required this.thisSeasonTitle,
    required this.thisSeasonValue,
    required this.priceTrendTitle,
    required this.priceTrendValue,
    required this.weatherTitle,
    required this.weatherValue,
    required this.onWeatherTap,
    required this.onVoiceTap,
    required this.voiceText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [
            Color(0xff172a20),
            Color(0xff1c2c23),
          ]
              : const [
            Color(0xffeaf8ef),
            Color(0xfff8fcf9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xffb7dfc3),
        ),
        boxShadow: [
          BoxShadow(
            color: DashboardColors.darkGreen.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -25,
            bottom: 35,
            child: Icon(
              Icons.landscape_rounded,
              size: 180,
              color: DashboardColors.primaryGreen.withOpacity(0.07),
            ),
          ),
          Positioned(
            right: 22,
            top: 20,
            child: Icon(
              Icons.eco_rounded,
              size: 75,
              color: DashboardColors.primaryGreen.withOpacity(0.08),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            welcomeText,
                            style: const TextStyle(
                              color: DashboardColors.darkGreen,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            subtitleText,
                            style: TextStyle(
                              color: subTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _RoundHeaderButton(
                      icon: Icons.mic_none_rounded,
                      background: DashboardColors.darkGreen,
                      iconColor: Colors.white,
                      onTap: onVoiceTap,
                    ),
                  ],
                ),
                if (voiceText.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      voiceText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: DashboardColors.darkGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: _OverviewStat(
                        icon: Icons.eco_rounded,
                        value: activeCrops,
                        title: activeCropsTitle,
                        iconColor: DashboardColors.primaryGreen,
                        subTextColor: subTextColor,
                        softBorderColor: softBorderColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _OverviewStat(
                        icon: Icons.chat_bubble_rounded,
                        value: inquiries,
                        title: inquiriesTitle,
                        iconColor: DashboardColors.orangeColor,
                        showBadge: int.tryParse(inquiries) != null &&
                            int.parse(inquiries) > 0,
                        subTextColor: subTextColor,
                        softBorderColor: softBorderColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.white.withOpacity(0.82),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _OverviewInfo(
                          icon: Icons.calendar_month_rounded,
                          title: thisSeasonTitle,
                          value: thisSeasonValue,
                          iconColor: DashboardColors.primaryGreen,
                          subTextColor: subTextColor,
                        ),
                      ),
                      _VerticalDivider(isDark: isDark),
                      Expanded(
                        child: _OverviewInfo(
                          icon: Icons.trending_up_rounded,
                          title: priceTrendTitle,
                          value: priceTrendValue,
                          iconColor: DashboardColors.orangeColor,
                          subTextColor: subTextColor,
                        ),
                      ),
                      _VerticalDivider(isDark: isDark),
                      Expanded(
                        child: GestureDetector(
                          onTap: onWeatherTap,
                          child: _OverviewInfo(
                            icon: Icons.cloud_outlined,
                            title: weatherTitle,
                            value: weatherValue,
                            iconColor: DashboardColors.blueColor,
                            subTextColor: subTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundHeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? background;
  final Color iconColor;
  final String? badge;

  const _RoundHeaderButton({
    required this.icon,
    required this.onTap,
    this.background,
    this.iconColor = DashboardColors.darkGreen,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedBackground =
        background ?? (isDark ? const Color(0xff24332a) : Colors.white);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: resolvedBackground,
              shape: BoxShape.circle,
              border: Border.all(
                color: DashboardColors.darkGreen.withOpacity(0.10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          if (badge != null)
            Positioned(
              right: -2,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(5),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xffdf4646),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badge!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OverviewStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String title;
  final Color iconColor;
  final bool showBadge;
  final Color subTextColor;
  final Color softBorderColor;

  const _OverviewStat({
    required this.icon,
    required this.value,
    required this.title,
    required this.iconColor,
    required this.subTextColor,
    required this.softBorderColor,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: softBorderColor),
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.11),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 23,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: DashboardColors.darkGreen,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;
  final Color subTextColor;

  const _OverviewInfo({
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
    required this.subTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 25,
          ),
          const SizedBox(height: 7),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: subTextColor,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: iconColor,
              fontSize: 11.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  final bool isDark;

  const _VerticalDivider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 1,
      color: isDark
          ? Colors.white12
          : const Color(0xffd6e7dc),
    );
  }
}
