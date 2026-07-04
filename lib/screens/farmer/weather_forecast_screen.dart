import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';
import '../../providers/weather_provider.dart';
import '../../utils/weather_ui_helper.dart';
import '../../widgets/weather/weather_forecast_tile.dart';
import '../../widgets/weather/weather_main_card.dart';
import '../../widgets/weather/weather_search_field.dart';
import '../../widgets/weather/weather_suggestion_card.dart';

class WeatherForecastScreen extends StatefulWidget {
  const WeatherForecastScreen({super.key});

  @override
  State<WeatherForecastScreen> createState() => _WeatherForecastScreenState();
}

class _WeatherForecastScreenState extends State<WeatherForecastScreen> {
  final TextEditingController _searchController = TextEditingController();

  static const double defaultLatitude = 30.67;
  static const double defaultLongitude = 73.10;

  static const Color darkGreen = Color(0xff075739);
  static const Color darkBackground = Color(0xFF0B1410);
  static const Color darkCard = Color(0xFF15251E);
  static const Color lightBackground = Color(0xfff9fbfa);
  static const Color lightGreen = Color(0xff9ff2c1);

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get primaryText => isDark ? Colors.white : const Color(0xff202525);

  Color get secondaryText =>
      isDark ? Colors.white70 : const Color(0xff4f5b56);

  Color get accentColor => isDark ? lightGreen : darkGreen;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<WeatherProvider>().fetchWeatherForecast(
        latitude: defaultLatitude,
        longitude: defaultLongitude,
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshWeather(WeatherProvider provider) async {
    await provider.refreshWeather();
  }

  void _searchCity(WeatherProvider provider, String value) {
    final city = value.trim();

    if (city.isEmpty) return;

    FocusScope.of(context).unfocus();
    provider.fetchWeatherByCity(city);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final lang = context.watch<LanguageProvider>();

    final weather = provider.weather;
    final uiData = WeatherUiHelper.getUiData(
      weather?.condition ?? "",
      isDark,
    );

    return Scaffold(
      backgroundColor: isDark ? darkBackground : lightBackground,
      body: SafeArea(
        child: provider.isLoading
            ? Center(child: CircularProgressIndicator(color: accentColor))
            : provider.errorMessage != null
            ? _errorView(provider)
            : weather == null
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
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: uiData.gradient,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topBar(context),
                  const SizedBox(height: 18),
                  _location(weather),
                  const SizedBox(height: 18),

                  WeatherSearchField(
                    controller: _searchController,
                    isDark: isDark,
                    accentColor: accentColor,
                    hintText: lang.t("searchCity"),
                    onSearch: (value) =>
                        _searchCity(provider, value),
                  ),

                  const SizedBox(height: 22),

                  WeatherMainCard(
                    weather: weather,
                    uiData: uiData,
                    humidityText: lang.t("humidity"),
                    windText: lang.t("wind"),
                    feelsLikeText: lang.t("feelsLike"),
                    uvIndexText: lang.t("uvIndex"),
                    visibilityText: lang.t("visibility"),
                  ),

                  const SizedBox(height: 22),

                  WeatherSuggestionCard(
                    suggestion: weather.farmingSuggestion,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 22),

                  Text(
                    "Next Weather Updates",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white
                          : const Color(0xff202525),
                    ),
                  ),

                  const SizedBox(height: 12),

                  ...weather.forecast.map(
                        (item) => WeatherForecastTile(
                      item: item,
                      isDark: isDark,
                      accentColor: accentColor,
                    ),
                  ),
                ],
              ),
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
          child: Icon(Icons.arrow_back, color: Colors.white, size: 26),
        ),
        Expanded(
          child: Center(
            child: Text(
              context.watch<LanguageProvider>().t("appName"),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 26),
      ],
    );
  }

  Widget _location(weather) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.watch<LanguageProvider>().t("weatherForecast"),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 17,
              color: Colors.white70,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                weather.location,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ],
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
              style: TextStyle(
                color: primaryText,
                fontWeight: FontWeight.w600,
              ),
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