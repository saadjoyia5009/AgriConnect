import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import '../../providers/crop_provider.dart';
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

      // Backend ready:
      // CropProvider mein ye method add karna hoga:
      // Future<void> fetchFarmerDashboard();
      await cropProvider.fetchFarmerDashboard();

      if (!mounted) return;
      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to load dashboard data";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cropProvider = context.watch<CropProvider>();

    return Scaffold(
      appBar: FarmerTopBar(
        title: "Dashboard",
        onNotificationTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const FarmerNotificationScreen(),
            ),
          );
        },
      ),
      backgroundColor: const Color(0xfff9fbfa),
      bottomNavigationBar: const FarmerBottomNavbar(currentIndex: 0),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xff075739),
          onRefresh: _loadDashboardData,
          child: _isLoading
              ? const Center(
            child: CircularProgressIndicator(
              color: Color(0xff075739),
            ),
          )
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
                        title: "Active Crops",
                        value: cropProvider.activeCrops.toString(),
                        subtitle: "Updated ",
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: _statsCard(
                        icon: Icons.chat_bubble,
                        title: "New Inquiries",
                        value: cropProvider.newInquiries.toString(),
                        subtitle: "Action required",
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

                const Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff202525),
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _quickAction(
                      context,
                      icon: Icons.add,
                      title: "Add Crop",
                      active: true,
                      screen: const AddCropScreen(),
                    ),
                    _quickAction(
                      context,
                      icon: Icons.trending_up,
                      title: "Price\nPrediction",
                      screen: const PricePredictionScreen(),
                    ),
                    _quickAction(
                      context,
                      icon: Icons.medical_services_outlined,
                      title: "Disease\nDetection",
                      screen: const DiseaseDetectionScreen(),
                    ),
                    _quickAction(
                      context,
                      icon: Icons.cloud_outlined,
                      title: "Weather",
                      blueIcon: true,
                      screen: const WeatherForecastScreen(),
                    ),
                  ],
                ),

                const SizedBox(height: 45),

                const SizedBox(height: 42),

                const Text(
                  "Daily Farming Tip",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff202525),
                  ),
                ),

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

  Widget _errorView() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 220),
        const Icon(
          Icons.error_outline,
          size: 55,
          color: Colors.red,
        ),
        const SizedBox(height: 15),
        Center(
          child: Text(
            _errorMessage!,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xff202525),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: ElevatedButton(
            onPressed: _loadDashboardData,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff075739),
              foregroundColor: Colors.white,
            ),
            child: const Text("Retry"),
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
    return Container(
      height: 160,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffbfe8ce)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xff2d7153), size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff3e4542),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 31,
              fontWeight: FontWeight.bold,
              color: Color(0xff171b1a),
            ),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xff6d7471),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dailyTipCard() {
    final tips = [
      {
        "title": "Water Early Morning",
        "tip": "Water your crops early in the morning to reduce evaporation and help roots absorb moisture better.",
        "icon": Icons.water_drop_outlined,
      },
      {
        "title": "Check Leaves Regularly",
        "tip": "Inspect crop leaves twice a week. Early disease signs can save your whole field from damage.",
        "icon": Icons.health_and_safety_outlined,
      },
      {
        "title": "Use Balanced Fertilizer",
        "tip": "Avoid overusing fertilizer. Balanced nutrients improve crop growth and protect soil quality.",
        "icon": Icons.eco_outlined,
      },
      {
        "title": "Monitor Market Price",
        "tip": "Before selling, compare crop prices and use price prediction to choose a better selling time.",
        "icon": Icons.trending_up_rounded,
      },
      {
        "title": "Remove Weeds Early",
        "tip": "Remove weeds before they grow large because they compete with crops for water and nutrients.",
        "icon": Icons.grass_outlined,
      },
    ];

    final todayIndex = DateTime.now().day % tips.length;
    final todayTip = tips[todayIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xffeaf7f0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffbfe8ce)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: const Color(0xff075739),
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff202525),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  todayTip["tip"] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff3e4542),
                  ),
                ),

                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Tip updates daily",
                    style: TextStyle(
                      color: Color(0xff075739),
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
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/weather");
      },
      child: Container(
      height: 150,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xffeffaff),
        border: Border.all(color: const Color(0xffb6def7)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -5,
            bottom: -5,
            child: Icon(
              Icons.cloud_outlined,
              size: 110,
              color: Colors.lightBlue.withOpacity(0.12),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.warning, color: Color(0xff168ad1), size: 28),
                  SizedBox(width: 15),
                  Text(
                    "Weather Alert",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3d4643),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                weather.title ?? "Weather Update",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff252929),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                weather.description ?? "",
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xff444b49),
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
    return Container(
      height: 120,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffbfe8ce)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.cloud_done_outlined, color: Color(0xff075739), size: 32),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              "No weather alert available right now",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xff3e4542),
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
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 450),
      closedElevation: 0,
      openElevation: 0,
      closedColor: Colors.transparent,
      openColor: Colors.white,
      closedBuilder: (context, openContainer) {
        return GestureDetector(
          onTap: openContainer,
          child: Column(
            children: [
              Container(
                height: 66,
                width: 66,
                decoration: BoxDecoration(
                  color: active ? const Color(0xff2d7153) : const Color(0xffe5e8e6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: active
                      ? Colors.white
                      : blueIcon
                      ? const Color(0xff008fe2)
                      : const Color(0xff27634a),
                ),
              ),
              const SizedBox(height: 9),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.2,
                  color: Color(0xff3f4845),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
      openBuilder: (context, _) => screen,
    );
  }


}