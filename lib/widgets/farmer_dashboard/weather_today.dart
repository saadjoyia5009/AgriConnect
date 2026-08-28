import 'package:flutter/material.dart';

import 'dashboard_colors.dart';

class WeatherToday extends StatelessWidget {
  final dynamic weather;
  final bool isDark;
  final Color cardColor;
  final Color textColor;
  final Color subTextColor;
  final String weatherUpdate;
  final String weatherForecast;
  final String humidityTitle;
  final String windTitle;
  final String rainChanceTitle;
  final String goodConditionsText;
  final VoidCallback onTap;
  final bool isUrdu;

  const WeatherToday({
    super.key,
    required this.weather,
    required this.isDark,
    required this.cardColor,
    required this.textColor,
    required this.subTextColor,
    required this.weatherUpdate,
    required this.weatherForecast,
    required this.humidityTitle,
    required this.windTitle,
    required this.rainChanceTitle,
    required this.goodConditionsText,
    required this.onTap,
    required this.isUrdu,
  });

  @override
  Widget build(BuildContext context) {
    final hasAlert = weather != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark
              ? cardColor
              : const Color(0xfff4fbff),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isDark
                ? Colors.white12
                : const Color(0xffcce5f5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    weatherUpdate,
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xff8fd0ff)
                          : const Color(0xff14567d),
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  weatherForecast,
                  style: const TextStyle(
                    color: DashboardColors.blueColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: DashboardColors.blueColor,
                  size: 11,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  height: 62,
                  width: 62,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xff24332a)
                        : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: DashboardColors.blueColor.withOpacity(0.10),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.wb_sunny_rounded,
                    color: Color(0xffffb52e),
                    size: 38,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "31°C",
                        style: TextStyle(
                          color: Color(0xff176eab),
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        "Lahore, Punjab",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        isUrdu ? "دھوپ" : "Sunny",
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _WeatherMetric(
                    icon: Icons.water_drop_outlined,
                    title: humidityTitle,
                    value: "62%",
                    subTextColor: subTextColor,
                    textColor: textColor,
                  ),
                ),
                Expanded(
                  child: _WeatherMetric(
                    icon: Icons.air_rounded,
                    title: windTitle,
                    value: "12 km/h",
                    subTextColor: subTextColor,
                    textColor: textColor,
                  ),
                ),
                Expanded(
                  child: _WeatherMetric(
                    icon: Icons.water_drop_rounded,
                    title: rainChanceTitle,
                    value: "20%",
                    subTextColor: subTextColor,
                    textColor: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                color: DashboardColors.blueColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                hasAlert ? weatherUpdate : goodConditionsText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: DashboardColors.blueColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherMetric extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color subTextColor;
  final Color textColor;

  const _WeatherMetric({
    required this.icon,
    required this.title,
    required this.value,
    required this.subTextColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: DashboardColors.blueColor,
          size: 18,
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            color: subTextColor,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
