import 'package:flutter/material.dart';

class WeatherSuggestionCard extends StatelessWidget {
  final String suggestion;
  final bool isDark;

  const WeatherSuggestionCard({
    super.key,
    required this.suggestion,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? Colors.red.withOpacity(0.15) : const Color(0xffffd8d5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: isDark ? Colors.red.shade200 : const Color(0xffd65345),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              suggestion,
              style: TextStyle(
                color: isDark ? Colors.red.shade100 : const Color(0xffb33b31),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
