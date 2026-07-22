import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/weather_model.dart';
import '../../providers/language_provider.dart';

class WeatherForecastTile extends StatelessWidget {
  final WeatherForecastModel item;
  final bool isDark;
  final Color accentColor;

  const WeatherForecastTile({
    super.key,
    required this.item,
    required this.isDark,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final primaryText = isDark ? Colors.white : const Color(0xff202525);
    final secondaryText = isDark ? Colors.white70 : const Color(0xff4f5b56);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF15251E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xffd8dedb),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.day,
              style: TextStyle(fontWeight: FontWeight.w700, color: primaryText),
            ),
          ),
          Text(item.icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(item.condition, style: TextStyle(color: primaryText)),
                Text(item.highTemp, style: TextStyle(color: secondaryText)),
                Text(
                  context
                      .watch<LanguageProvider>()
                      .t("rainChance")
                      .replaceAll('{value}', item.rainChance.toString()),
                  style: TextStyle(
                    color: accentColor,
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
