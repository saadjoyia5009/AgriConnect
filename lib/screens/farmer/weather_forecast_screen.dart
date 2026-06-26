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

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WeatherProvider>().fetchWeatherForecast();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      backgroundColor: const Color(0xfff9fbfa),
      body: SafeArea(
        child: provider.isLoading
            ? const Center(
          child: CircularProgressIndicator(
            color: Color(0xff075739),
          ),
        )
            : provider.errorMessage != null
            ? _errorView(provider)
            : provider.weather == null
            ? const Center(child: Text("No weather data found"))
            : RefreshIndicator(
          color: const Color(0xff075739),
          onRefresh: () =>
              provider.fetchWeatherForecast(),
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
                const Text(
                  "5-Day Outlook",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff075739),
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
          child: const Icon(
            Icons.arrow_back,
            color: Color(0xff075739),
            size: 26,
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              "AgriConnect",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff075739),
              ),
            ),
          ),
        ),
        const Icon(
          Icons.account_circle_outlined,
          color: Color(0xff075739),
          size: 26,
        ),
      ],
    );
  }

  Widget _location(WeatherModel weather) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Weather Forecast",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xff075739),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 17,
              color: Color(0xff4f5b56),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                weather.location,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff4f5b56),
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
      onSubmitted: (value) {
        provider.fetchWeatherForecast(city: value.trim());
      },
      decoration: InputDecoration(
        hintText: "Search city...",
        prefixIcon: const Icon(
          Icons.search,
          color: Color(0xff6d7471),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffd8dedb)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff075739)),
        ),
      ),
    );
  }

  Widget _weatherCard(WeatherModel weather) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xff55bfea),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
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
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _infoItem(Icons.water_drop_outlined, "Humidity",
                        weather.humidity),
                    _infoItem(Icons.air, "Wind", weather.wind),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    _infoItem(Icons.grain, "Precipitation",
                        weather.precipitation),
                    _infoItem(Icons.thermostat, "Feels Like",
                        weather.feelsLike),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    _infoItem(Icons.wb_sunny_outlined, "UV Index",
                        weather.uvIndex),
                    _infoItem(Icons.visibility_outlined, "Visibility",
                        weather.visibility),
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
        color: const Color(0xffffd8d5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xffd65345),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Farming Suggestion: ${weather.farmingSuggestion}",
              style: const TextStyle(
                color: Color(0xffb33b31),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xffd8dedb)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.day,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xff3e4542),
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff202525),
                ),
              ),
              Text(
                item.lowTemp,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff202525),
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
          backgroundColor: const Color(0xff075739),
          foregroundColor: Colors.white,
        ),
        child: const Text("Retry"),
      ),
    );
  }
}