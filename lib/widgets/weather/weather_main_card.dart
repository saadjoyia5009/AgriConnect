import 'package:flutter/material.dart';

import '../../models/weather_model.dart';
import '../../utils/weather_ui_helper.dart';

class WeatherMainCard extends StatelessWidget {
  final WeatherModel weather;
  final WeatherUiData uiData;
  final String humidityText;
  final String windText;
  final String feelsLikeText;
  final String uvIndexText;
  final String visibilityText;

  const WeatherMainCard({
    super.key,
    required this.weather,
    required this.uiData,
    required this.humidityText,
    required this.windText,
    required this.feelsLikeText,
    required this.uvIndexText,
    required this.visibilityText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: uiData.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Icon(
              uiData.backgroundIcon,
              size: 110,
              color: Colors.white.withOpacity(0.18),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Text(uiData.emoji, style: const TextStyle(fontSize: 52)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weather.temperature,
                          style: const TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          weather.condition,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _info(Icons.water_drop_outlined, humidityText, weather.humidity),
                        _info(Icons.air, windText, weather.wind),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _info(Icons.grain, "Rain Chance", weather.precipitation),
                        _info(Icons.thermostat, feelsLikeText, weather.feelsLike),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _info(Icons.wb_sunny_outlined, uvIndexText, weather.uvIndex),
                        _info(Icons.visibility_outlined, visibilityText, weather.visibility),
                      ],
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

  Widget _info(IconData icon, String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 12)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}