import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import '../../providers/crop_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/farmer_bottom_navbar.dart';
import 'add_crop_screen.dart';
import 'price_prediction_screen.dart';
import 'disease_detection_screen.dart';
import 'weather_forecast_screen.dart';
import 'farmer_top_bar.dart';
import 'farmer_notification_screen.dart';

class FarmerDashboardScreen extends StatefulWidget {
  const FarmerDashboardScreen({super.key});

  @override
  State<FarmerDashboardScreen> createState() => _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState extends State<FarmerDashboardScreen> {
  static const Color darkGreen = Color(0xff075739);
  static const Color mediumGreen = Color(0xff2d7153);

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadDashboardData);
  }

  Future<void> _loadDashboardData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final cropProvider = context.read<CropProvider>();
      await cropProvider.fetchFarmerDashboard();

      if (!mounted) return;
      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = "failedLoadDashboard";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cropProvider = context.watch<CropProvider>();
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      appBar: FarmerTopBar(
        title: lang.t("dashboard"),
        onNotificationTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FarmerNotificationScreen()),
          );
        },
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: const FarmerBottomNavbar(currentIndex: 0),
      body: SafeArea(
        child: RefreshIndicator(
          color: darkGreen,
          onRefresh: _loadDashboardData,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: darkGreen))
              : _errorMessage != null
              ? _errorView()
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _statsCard(
                              icon: Icons.local_florist,
                              title: lang.t("activeCrops"),
                              value: cropProvider.activeCrops.toString(),
                              subtitle: lang.t("updated"),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: _statsCard(
                              icon: Icons.chat_bubble,
                              title: lang.t("newInquiries"),
                              value: cropProvider.newInquiries.toString(),
                              subtitle: lang.t("actionRequired"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (cropProvider.weatherAlert != null)
                        _weatherAlertCard(cropProvider.weatherAlert!)
                      else
                        _emptyWeatherCard(),
                      const SizedBox(height: 35),
                      _sectionTitle(lang.t("quickActions")),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _quickAction(
                            context,
                            icon: Icons.add,
                            title: lang.t("addCrop"),
                            active: true,
                            screen: const AddCropScreen(),
                          ),
                          _quickAction(
                            context,
                            icon: Icons.trending_up,
                            title: lang.t("pricePrediction"),
                            screen: const PricePredictionScreen(),
                          ),
                          _quickAction(
                            context,
                            icon: Icons.medical_services_outlined,
                            title: lang.t("diseaseDetection"),
                            screen: const DiseaseDetectionScreen(),
                          ),
                          _quickAction(
                            context,
                            icon: Icons.cloud_outlined,
                            title: lang.t("weather"),
                            blueIcon: true,
                            screen: const WeatherForecastScreen(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 45),
                      _sectionTitle(lang.t("dailyFarmingTip")),
                      const SizedBox(height: 14),
                      _dailyTipCard(),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
  }

  Widget _errorView() {
    final lang = context.watch<LanguageProvider>();

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 220),
        const Icon(Icons.error_outline, size: 55, color: Colors.red),
        const SizedBox(height: 15),
        Center(
          child: Text(
            lang.t(_errorMessage!),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: ElevatedButton(
            onPressed: _loadDashboardData,
            style: ElevatedButton.styleFrom(
              backgroundColor: darkGreen,
              foregroundColor: Colors.white,
            ),
            child: Text(lang.t("retry")),
          ),
        ),
      ],
    );
  }

  Widget _statsCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 160,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xffbfe8ce),
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.18)
                : Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: mediumGreen, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : const Color(0xff3e4542),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 31,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white60 : const Color(0xff6d7471),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dailyTipCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    final tips = [
      {
        "title": lang.t("tipWaterTitle"),
        "tip": lang.t("tipWaterBody"),
        "icon": Icons.water_drop_outlined,
      },
      {
        "title": lang.t("tipLeavesTitle"),
        "tip": lang.t("tipLeavesBody"),
        "icon": Icons.health_and_safety_outlined,
      },
      {
        "title": lang.t("tipFertilizerTitle"),
        "tip": lang.t("tipFertilizerBody"),
        "icon": Icons.eco_outlined,
      },
      {
        "title": lang.t("tipMarketTitle"),
        "tip": lang.t("tipMarketBody"),
        "icon": Icons.trending_up_rounded,
      },
      {
        "title": lang.t("tipWeedsTitle"),
        "tip": lang.t("tipWeedsBody"),
        "icon": Icons.grass_outlined,
      },
    ];

    final todayIndex = DateTime.now().day % tips.length;
    final todayTip = tips[todayIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).cardColor : const Color(0xffeaf7f0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xffbfe8ce),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.18)
                : Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: darkGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              todayTip["icon"] as IconData,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todayTip["title"] as String,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  todayTip["tip"] as String,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : const Color(0xff3e4542),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white12 : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    lang.t("tipUpdatesDaily"),
                    style: TextStyle(
                      color: isDark ? Colors.white : darkGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _weatherAlertCard(dynamic weather) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/weather");
      },
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Theme.of(context).cardColor : const Color(0xffeffaff),
          border: Border.all(
            color: isDark ? Colors.white12 : const Color(0xffb6def7),
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.18)
                  : Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -5,
              bottom: -5,
              child: Icon(
                Icons.cloud_outlined,
                size: 110,
                color: Colors.lightBlue.withOpacity(isDark ? 0.08 : 0.12),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.warning,
                      color: Color(0xff168ad1),
                      size: 28,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      lang.t("weatherAlert"),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xff3d4643),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  weather.title ?? lang.t("weatherUpdate"),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  weather.description ?? "",
                  style: TextStyle(
                    fontSize: 18,
                    color: isDark ? Colors.white70 : const Color(0xff444b49),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyWeatherCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return Container(
      height: 120,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xffbfe8ce),
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.18)
                : Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_done_outlined, color: darkGreen, size: 32),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              lang.t("noWeatherAlert"),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : const Color(0xff3e4542),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickAction(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget screen,
    bool active = false,
    bool blueIcon = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 350),
      closedElevation: 0,
      openElevation: 0,
      closedColor: Colors.transparent,
      openColor: Theme.of(context).scaffoldBackgroundColor,
      closedBuilder: (context, openContainer) {
        return GestureDetector(
          onTap: openContainer,
          child: SizedBox(
            width: 78,
            child: Column(
              children: [
                Container(
                  height: 66,
                  width: 66,
                  decoration: BoxDecoration(
                    color: active
                        ? mediumGreen
                        : isDark
                        ? Theme.of(context).cardColor
                        : const Color(0xffe5e8e6),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.transparent,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: active
                        ? Colors.white
                        : blueIcon
                        ? const Color(0xff008fe2)
                        : mediumGreen,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.2,
                    color: isDark ? Colors.white70 : const Color(0xff3f4845),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      openBuilder: (context, _) => screen,
    );
  }
}
