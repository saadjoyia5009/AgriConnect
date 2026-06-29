import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_dashboard_provider.dart';
import '../../widgets/admin/admin_dashboard_shimmer.dart';
import '../../widgets/admin/admin_stat_card.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  static const Color darkGreen = Color(0xFF0E5A3C);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AdminDashboardProvider>().fetchDashboardStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5),
      body: Consumer<AdminDashboardProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const AdminDashboardShimmer();
          }

          final stats = provider.stats;

          if (stats == null) {
            return const Center(
              child: Text("No dashboard data found"),
            );
          }

          return SafeArea(
            child: RefreshIndicator(
              color: darkGreen,
              onRefresh: provider.fetchDashboardStats,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                children: [
                  _header(),
                  const SizedBox(height: 22),

                  AdminStatCard(
                    title: "Total Farmers",
                    value: stats.totalFarmers.toString(),
                    icon: Icons.agriculture_rounded,
                    color: darkGreen,
                    index: 0,
                  ),
                  const SizedBox(height: 14),

                  AdminStatCard(
                    title: "Total Buyers",
                    value: stats.totalBuyers.toString(),
                    icon: Icons.shopping_bag_rounded,
                    color: Colors.blue,
                    index: 1,
                  ),
                  const SizedBox(height: 14),

                  AdminStatCard(
                    title: "Total Crops",
                    value: stats.totalCrops.toString(),
                    icon: Icons.grass_rounded,
                    color: Colors.orange,
                    index: 2,
                  ),
                  const SizedBox(height: 14),

                  AdminStatCard(
                    title: "Total Inquiries",
                    value: stats.totalInquiries.toString(),
                    icon: Icons.mark_email_unread_rounded,
                    color: Colors.purple,
                    index: 3,
                  ),
                  const SizedBox(height: 14),

                  AdminStatCard(
                    title: "Active Listings",
                    value: stats.activeListings.toString(),
                    icon: Icons.verified_rounded,
                    color: Colors.teal,
                    index: 4,
                  ),
                  const SizedBox(height: 14),

                  AdminStatCard(
                    title: "Pending Reports",
                    value: stats.pendingReports.toString(),
                    icon: Icons.report_problem_rounded,
                    color: Colors.redAccent,
                    index: 5,
                  ),

                  const SizedBox(height: 26),
                  _quickActions(context),

                  const SizedBox(height: 26),
                  _chartCard(
                    stats.totalFarmers,
                    stats.totalBuyers,
                    stats.totalCrops,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0E5A3C),
            Color(0xFF157A52),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.admin_panel_settings_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Admin Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Manage AgriConnect activity",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: -0.18, end: 0);
  }

  Widget _quickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color(0xFF123524),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _actionCard(
                context,
                title: "Users",
                icon: Icons.people_alt_rounded,
                color: darkGreen,
                route: '/adminUsers',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _actionCard(
                context,
                title: "Crops",
                icon: Icons.grass_rounded,
                color: Colors.orange,
                route: '/adminCrops',
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _actionCard(
                context,
                title: "Analytics",
                icon: Icons.bar_chart_rounded,
                color: Colors.purple,
                route: '/adminAnalytics',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _actionCard(
                context,
                title: "Reports",
                icon: Icons.report_problem_rounded,
                color: Colors.redAccent,
                route: '/adminReports',
              ),
            ),
          ],
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 650.ms)
        .slideY(begin: 0.15, end: 0);
  }

  Widget _actionCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required String route,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.10),
              blurRadius: 16,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF123524),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chartCard(int farmers, int buyers, int crops) {
    return Container(
      height: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Platform Overview",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF123524),
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final labels = ["Farmers", "Buyers", "Crops"];

                        if (value.toInt() < 0 ||
                            value.toInt() >= labels.length) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            labels[value.toInt()],
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  _barGroup(0, farmers.toDouble(), darkGreen),
                  _barGroup(1, buyers.toDouble(), Colors.blue),
                  _barGroup(2, crops.toDouble(), Colors.orange),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 500.ms)
        .slideY(begin: 0.18, end: 0);
  }

  BarChartGroupData _barGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 28,
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
      ],
    );
  }
}