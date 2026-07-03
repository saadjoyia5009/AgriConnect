import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/weather_model.dart';
import '../../providers/language_provider.dart';
import '../../providers/weather_provider.dart';

class WeatherForecastScreen extends StatefulWidget {
  const WeatherForecastScreen({super.key});

  @override
  State<WeatherForecastScreen> createState() => _WeatherForecastScreenState();
}

class _WeatherForecastScreenState extends State<WeatherForecastScreen> {
  final TextEditingController _searchController = TextEditingController();

  String? _lastSearchedCity;

  static const Color darkGreen = Color(0xff075739);
  static const Color darkBackground = Color(0xFF0B1410);
  static const Color darkCard = Color(0xFF15251E);
  static const Color lightBackground = Color(0xfff9fbfa);
  static const Color lightGreen = Color(0xff9ff2c1);

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get primaryText => isDark ? Colors.white : const Color(0xff202525);
  Color get secondaryText => isDark ? Colors.white70 : const Color(0xff4f5b56);
  Color get accentColor => isDark ? lightGreen : darkGreen;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WeatherProvider>().fetchWeatherForecast(
        latitude: 30.67,
        longitude: 73.10,
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshWeather(WeatherProvider provider) async {
    if (_lastSearchedCity != null && _lastSearchedCity!.trim().isNotEmpty) {
      await provider.fetchWeatherByCity(_lastSearchedCity!);
    } else {
      await provider.fetchWeatherForecast(
        latitude: 30.67,
        longitude: 73.10,
      );
    }
  }

  void _searchCity(WeatherProvider provider, String value) {
    final city = value.trim();

    if (city.isEmpty) return;

    _lastSearchedCity = city;
    provider.fetchWeatherByCity(city);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: isDark ? darkBackground : lightBackground,
      body: SafeArea(
        child: provider.isLoading
            ? Center(child: CircularProgressIndicator(color: accentColor))
            : provider.errorMessage != null
            ? _errorView(provider)
            : provider.weather == null
            ? Center(
          child: Text(
            lang.t("noWeatherData"),
            style: TextStyle(color: primaryText),
          ),
        )
            : RefreshIndicator(
          color: accentColor,
          backgroundColor: isDark ? darkCard : Colors.white,
          onRefresh: () => _refreshWeather(provider),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _topBar(context),
                const SizedBox(height: 18),
                _location(provider.weather!),
                const SizedBox(height: 18),
                _searchField(provider),
                const SizedBox(height: 22),
                _weatherCard(provider.weather!),
                const SizedBox(height: 22),
                _suggestionCard(provider.weather!),
                const SizedBox(height: 22),
                Text(
                  lang.t("fiveDayOutlook"),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 12),
                ...provider.weather!.forecast.map(
                      (item) => _forecastTile(item),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: accentColor, size: 26),
        ),
        Expanded(
          child: Center(
            child: Text(
              context.watch<LanguageProvider>().t("appName"),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _location(WeatherModel weather) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.watch<LanguageProvider>().t("weatherForecast"),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: accentColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.location_on_outlined, size: 17, color: secondaryText),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                weather.location,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: secondaryText,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _searchField(WeatherProvider provider) {
    final lang = context.watch<LanguageProvider>();

    return TextField(
      controller: _searchController,
      style: TextStyle(color: primaryText, fontWeight: FontWeight.w600),
      cursorColor: accentColor,
      textInputAction: TextInputAction.search,
      onSubmitted: (value) => _searchCity(provider, value),
      decoration: InputDecoration(
        hintText: lang.t("searchCity"),
        hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
        prefixIcon: Icon(
          Icons.search,
          color: isDark ? Colors.white60 : const Color(0xff6d7471),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.send_rounded, color: accentColor),
          onPressed: () => _searchCity(provider, _searchController.text),
        ),
        filled: true,
        fillColor: isDark ? darkCard : Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white12 : const Color(0xffd8dedb),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentColor, width: 1.3),
        ),
      ),
    );
  }

  Widget _weatherCard(WeatherModel weather) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1D6F8F) : const Color(0xff55bfea),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(weather.forecast.isNotEmpty ? weather.forecast.first.icon : "🌤️",
                  style: const TextStyle(fontSize: 48)),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather.temperature,
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    weather.condition,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                Icons.cloud,
                size: 70,
                color: Colors.white.withOpacity(0.25),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(isDark ? 0.14 : 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _infoItem(
                      Icons.water_drop_outlined,
                      context.watch<LanguageProvider>().t("humidity"),
                      weather.humidity,
                    ),
                    _infoItem(
                      Icons.air,
                      context.watch<LanguageProvider>().t("wind"),
                      weather.wind,
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    _infoItem(
                      Icons.grain,
                      context.watch<LanguageProvider>().t("precipitation"),
                      weather.precipitation,
                    ),
                    _infoItem(
                      Icons.thermostat,
                      context.watch<LanguageProvider>().t("feelsLike"),
                      weather.feelsLike,
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    _infoItem(
                      Icons.wb_sunny_outlined,
                      context.watch<LanguageProvider>().t("uvIndex"),
                      weather.uvIndex,
                    ),
                    _infoItem(
                      Icons.visibility_outlined,
                      context.watch<LanguageProvider>().t("visibility"),
                      weather.visibility,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String title, String value) {
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

  Widget _suggestionCard(WeatherModel weather) {
    final lang = context.watch<LanguageProvider>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? Colors.red.withOpacity(0.15) : const Color(0xffffd8d5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.red.withOpacity(0.25) : Colors.transparent,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: isDark ? Colors.red.shade200 : const Color(0xffd65345),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              lang.t("farmingSuggestion").replaceAll(
                "{value}",
                weather.farmingSuggestion,
              ),
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

  Widget _forecastTile(WeatherForecastModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      decoration: BoxDecoration(
        color: isDark ? darkCard : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xffd8dedb),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.day,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: primaryText,
              ),
            ),
          ),
          Text(item.icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.highTemp,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),
              Text(
                item.lowTemp,
                style: TextStyle(fontSize: 14, color: secondaryText),
              ),
              Text(
                "Rain: ${item.rainChance}",
                style: TextStyle(
                  fontSize: 12,
                  color: accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _errorView(WeatherProvider provider) {
    final lang = context.watch<LanguageProvider>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              provider.errorMessage ?? "Failed to load weather",
              textAlign: TextAlign.center,
              style: TextStyle(color: primaryText, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () => _refreshWeather(provider),
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
              ),
              child: Text(lang.t("retry")),
            ),
          ],
        ),
      ),
    );
  }
}