import 'package:flutter/material.dart';

class WeatherUiData {
  final List<Color> gradient;
  final IconData backgroundIcon;
  final Color cardColor;
  final String emoji;

  const WeatherUiData({
    required this.gradient,
    required this.backgroundIcon,
    required this.cardColor,
    required this.emoji,
  });
}

class WeatherUiHelper {
  static WeatherUiData getUiData(String condition, bool isDark) {
    final c = condition.toLowerCase();

    if (c.contains("sun") || c.contains("clear")) {
      return WeatherUiData(
        gradient: isDark
            ? [const Color(0xff7A4E00), const Color(0xff1A1200)]
            : [const Color(0xffFDB813), const Color(0xffFFEF9F)],
        backgroundIcon: Icons.wb_sunny_rounded,
        cardColor: const Color(0xffF9A825),
        emoji: "☀️",
      );
    }

    if (c.contains("cloud")) {
      return WeatherUiData(
        gradient: isDark
            ? [const Color(0xff263238), const Color(0xff101820)]
            : [const Color(0xff78909C), const Color(0xffDDE7EB)],
        backgroundIcon: Icons.cloud_rounded,
        cardColor: const Color(0xff607D8B),
        emoji: "☁️",
      );
    }

    if (c.contains("rain") || c.contains("drizzle")) {
      return WeatherUiData(
        gradient: isDark
            ? [const Color(0xff0D324D), const Color(0xff061621)]
            : [const Color(0xff2193B0), const Color(0xff6DD5ED)],
        backgroundIcon: Icons.water_drop_rounded,
        cardColor: const Color(0xff1E88E5),
        emoji: "🌧️",
      );
    }

    if (c.contains("storm") || c.contains("thunder")) {
      return WeatherUiData(
        gradient: isDark
            ? [const Color(0xff232526), const Color(0xff000000)]
            : [const Color(0xff485563), const Color(0xff29323C)],
        backgroundIcon: Icons.thunderstorm_rounded,
        cardColor: const Color(0xff37474F),
        emoji: "⛈️",
      );
    }

    if (c.contains("fog") || c.contains("mist") || c.contains("haze")) {
      return WeatherUiData(
        gradient: isDark
            ? [const Color(0xff3E5151), const Color(0xff182222)]
            : [const Color(0xffBDC3C7), const Color(0xffECEFF1)],
        backgroundIcon: Icons.foggy,
        cardColor: const Color(0xff90A4AE),
        emoji: "🌫️",
      );
    }

    return WeatherUiData(
      gradient: isDark
          ? [const Color(0xff1D6F8F), const Color(0xff0B1410)]
          : [const Color(0xff55BFEA), const Color(0xffDFF6FF)],
      backgroundIcon: Icons.cloud_queue_rounded,
      cardColor: const Color(0xff55BFEA),
      emoji: "🌤️",
    );
  }
}