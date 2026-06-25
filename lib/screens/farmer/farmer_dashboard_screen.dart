import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/crop_provider.dart';
import '../../widgets/farmer_bottom_navbar.dart';


class FarmerDashboardScreen extends StatelessWidget {
  const FarmerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cropProvider = Provider.of<CropProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xfff9fbfa),
      bottomNavigationBar: const FarmerBottomNavbar(
        currentIndex: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(),
              const SizedBox(height: 50),

              Row(
                children: [
                  Expanded(
                    child: _statsCard(
                      icon: Icons.local_florist,
                      title: "Active Crops",
                      value: cropProvider.activeCrops.toString(),
                      subtitle: "+2 this week",
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
              _weatherAlertCard(),

              const SizedBox(height: 45),
              const Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff202525),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _quickAction(
                    icon: Icons.add,
                    title: "Add Crop",
                    active: true,
                  ),
                  _quickAction(
                    icon: Icons.trending_up,
                    title: "Price\nPrediction",
                  ),
                  _quickAction(
                    icon: Icons.medical_services_outlined,
                    title: "Disease\nDetection",
                  ),
                  _quickAction(
                    icon: Icons.cloud_outlined,
                    title: "Weather",
                    blueIcon: true,
                  ),
                ],
              ),

              const SizedBox(height: 55),

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Inquiries",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff202525),
                    ),
                  ),
                  Text(
                    "View All",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff075739),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _inquiryCard(
                name: "John Smith",
                message: "Inquiring about Organic\nTomatoes",
                time: "2h\nago",
                avatarText: "JS",
                showDot: true,
              ),

              const SizedBox(height: 10),

              _inquiryCard(
                name: "Fresh Market Co.",
                message: "Bulk order negotiation",
                time: "Yesterday",
                image: "https://i.pravatar.cc/150?img=12",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
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
        Stack(
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
      height: 152,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffbfe8ce)),
        borderRadius: BorderRadius.circular(12),
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
            style: TextStyle(
              fontSize: 15,
              color: subtitle.contains("+")
                  ? const Color(0xff7bd9aa)
                  : const Color(0xff6d7471),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _weatherAlertCard() {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xffeffaff),
        border: Border.all(color: const Color(0xffb6def7)),
        borderRadius: BorderRadius.circular(12),
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: Color(0xff168ad1),
                    size: 28,
                  ),
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
              SizedBox(height: 10),
              Text(
                "Heavy Rain Expected",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff252929),
                ),
              ),
              SizedBox(height: 3),
              Text(
                "Tomorrow, 2:00 PM - 6:00 PM",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xff444b49),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String title,
    bool active = false,
    bool blueIcon = false,
  }) {
    return Column(
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
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xffcdeed3),
            backgroundImage: image != null ? NetworkImage(image) : null,
            child: image == null
                ? Text(
              avatarText ?? "",
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
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff202525),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 17,
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
                  fontSize: 15,
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