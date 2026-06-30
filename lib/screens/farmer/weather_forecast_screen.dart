import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/weather_provider.dart';
import '../../models/weather_model.dart';

class WeatherForecastScreen extends StatefulWidget {
  const WeatherForecastScreen({super.key});

  @override
  State<WeatherForecastScreen> createState() => _WeatherForecastScreenState();
}

class _WeatherForecastScreenState extends State<WeatherForecastScreen> {
  final TextEditingController _searchController = TextEditingController();

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
      context.read<WeatherProvider>().fetchWeatherForecast();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      backgroundColor: isDark ? darkBackground : lightBackground,
      body: SafeArea(
        child: provider.isLoading
            ? Center(
          child: CircularProgressIndicator(color: accentColor),
        )
            : provider.errorMessage != null
            ? _errorView(provider)
            : provider.weather == null
            ? Center(
          child: Text(
            "No weather data found",
            style: TextStyle(color: primaryText),
          ),
        )
            : RefreshIndicator(
          color: accentColor,
          backgroundColor: isDark ? darkCard : Colors.white,
          onRefresh: () => provider.fetchWeatherForecast(),
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
                  "5-Day Outlook",
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
          child: Icon(
            Icons.arrow_back,
            color: accentColor,
            size: 26,
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              "AgriConnect",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
          ),
        ),
        Icon(
          Icons.account_circle_outlined,
          color: accentColor,
          size: 26,
        ),
      ],
    );
  }

  Widget _location(WeatherModel weather) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Weather Forecast",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: accentColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 17,
              color: secondaryText,
            ),
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
    return TextField(
      controller: _searchController,
      style: TextStyle(
        color: primaryText,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: accentColor,
      onSubmitted: (value) {
        provider.fetchWeatherForecast(city: value.trim());
      },
      decoration: InputDecoration(
        hintText: "Search city...",
        hintStyle: TextStyle(
          color: isDark ? Colors.white38 : Colors.grey,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: isDark ? Colors.white60 : const Color(0xff6d7471),
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
              const Text(
                "🌧️",
                style: TextStyle(fontSize: 48),
              ),
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
                    _infoItem(Icons.water_drop_outlined, "Humidity", weather.humidity),
                    _infoItem(Icons.air, "Wind", weather.wind),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    _infoItem(Icons.grain, "Precipitation", weather.precipitation),
                    _infoItem(Icons.thermostat, "Feels Like", weather.feelsLike),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    _infoItem(Icons.wb_sunny_outlined, "UV Index", weather.uvIndex),
                    _infoItem(Icons.visibility_outlined, "Visibility", weather.visibility),
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
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
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
              "Farming Suggestion: ${weather.farmingSuggestion}",
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
          Text(
            item.icon,
            style: const TextStyle(fontSize: 24),
          ),
          const Spacer(),
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
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _errorView(WeatherProvider provider) {
    return Center(
      child: ElevatedButton(
        onPressed: () => provider.fetchWeatherForecast(),
        style: ElevatedButton.styleFrom(
          backgroundColor: darkGreen,
          foregroundColor: Colors.white,
        ),
        child: const Text("Retry"),
      ),
    );
  }
}