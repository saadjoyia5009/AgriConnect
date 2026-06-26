import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/crop_provider.dart';
import '../../widgets/farmer_bottom_navbar.dart';

class FarmerDashboardScreen extends StatefulWidget {
  const FarmerDashboardScreen({super.key});

  @override
  State<FarmerDashboardScreen> createState() => _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState extends State<FarmerDashboardScreen> {
  bool _isLoading = true;
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
                _topBar(context),
                const SizedBox(height: 40),

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
                      onTap: () {
                        Navigator.pushNamed(context, "/add-crop");
                      },
                    ),
                    _quickAction(
                      context,
                      icon: Icons.trending_up,
                      title: "Price\nPrediction",
                      onTap: () {
                        Navigator.pushNamed(
                            context, "/price-prediction");
                      },
                    ),
                    _quickAction(
                      context,
                      icon: Icons.medical_services_outlined,
                      title: "Disease\nDetection",
                      onTap: () {
                        Navigator.pushNamed(
                            context, "/disease-detection");
                      },
                    ),
                    _quickAction(
                      context,
                      icon: Icons.cloud_outlined,
                      title: "Weather",
                      blueIcon: true,
                      onTap: () {
                        Navigator.pushNamed(context, "/weather");
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 45),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Recent Inquiries",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff202525),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/inquiries");
                      },
                      child: const Text(
                        "View All",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff075739),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                if (cropProvider.recentInquiries.isEmpty)
                  _emptyInquiryCard()
                else
                  ...cropProvider.recentInquiries.map(
                        (inquiry) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _inquiryCard(
                        name: inquiry.buyerName,
                        message: inquiry.message,
                        time: inquiry.timeAgo,
                        image: inquiry.buyerImage,
                        avatarText: inquiry.avatarText,
                        showDot: inquiry.isUnread,
                      ),
                    ),
                  ),
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

  Widget _topBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(Icons.menu, size: 30, color: Color(0xff075739)),
        const Text(
          "AgriConnect",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xff075739),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "/notifications");
          },
          child: Stack(
            children: [
              const Icon(
                Icons.notifications_none,
                size: 30,
                color: Color(0xff075739),
              ),
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  height: 9,
                  width: 9,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
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
        required VoidCallback onTap,
        bool active = false,
        bool blueIcon = false,
      }) {
    return GestureDetector(
      onTap: onTap,
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
  }

  Widget _emptyInquiryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffbfe8ce)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        "No recent inquiries found",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: Color(0xff6d7471),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _inquiryCard({
    required String name,
    required String message,
    required String time,
    String? avatarText,
    String? image,
    bool showDot = false,
  }) {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffbfe8ce)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xffcdeed3),
            backgroundImage: image != null && image.isNotEmpty
                ? NetworkImage(image)
                : null,
            child: image == null || image.isEmpty
                ? Text(
              avatarText ?? name.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                color: Color(0xff1a573a),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )
                : null,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff202525),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.35,
                    color: Color(0xff3e4542),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                time,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff737b78),
                ),
              ),
              if (showDot) ...[
                const SizedBox(height: 15),
                Container(
                  height: 9,
                  width: 9,
                  decoration: const BoxDecoration(
                    color: Color(0xff075739),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}