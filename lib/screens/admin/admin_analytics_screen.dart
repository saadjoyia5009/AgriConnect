import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_analytics_provider.dart';
import '../../widgets/admin/admin_analytics_shimmer.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
  static const Color darkGreen = Color(0xFF0E5A3C);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AdminAnalyticsProvider>().fetchAnalytics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5),
      appBar: AppBar(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Analytics",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: Consumer<AdminAnalyticsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const AdminAnalyticsShimmer();
          }

          return RefreshIndicator(
            color: darkGreen,
            onRefresh: provider.fetchAnalytics,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                _summaryCard(provider),
                const SizedBox(height: 18),
                _userGrowthChart(provider),
                const SizedBox(height: 18),
                _cropCategoryChart(provider),
                const SizedBox(height: 18),
                _inquiryChart(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _summaryCard(AdminAnalyticsProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0E5A3C),
            Color(0xFF157A52),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withOpacity(0.22),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          _summaryItem("Users", provider.totalUsers.toString()),
          _divider(),
          _summaryItem("Crops", provider.totalCrops.toString()),
          _divider(),
          _summaryItem("Deals", provider.completedDeals.toString()),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 450.ms)
        .slideY(begin: -0.12, end: 0);
  }

  Widget _summaryItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 42,
      width: 1,
      color: Colors.white.withOpacity(0.25),
    );
  }

  Widget _userGrowthChart(AdminAnalyticsProvider provider) {
    final entries = provider.userGrowth.entries.toList();

    return _chartContainer(
      title: "User Growth",
      subtitle: "Monthly registered users",
      child: LineChart(
        LineChartData(
          minY: 0,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) {
              return FlLine(
                color: Colors.grey.withOpacity(0.18),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
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
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= entries.length) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      entries[index].key,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: darkGreen,
              barWidth: 4,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: darkGreen.withOpacity(0.10),
              ),
              spots: List.generate(
                entries.length,
                    (index) => FlSpot(index.toDouble(), entries[index].value),
              ),
            ),
          ],
        ),
      ),
      delay: 100,
    );
  }

  Widget _cropCategoryChart(AdminAnalyticsProvider provider) {
    final entries = provider.cropCategories.entries.toList();

    return _chartContainer(
      title: "Crop Categories",
      subtitle: "Most listed crop types",
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
                  final index = value.toInt();
                  if (index < 0 || index >= entries.length) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      entries[index].key,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: List.generate(
            entries.length,
                (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: entries[index].value,
                  width: 24,
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(9),
                ),
              ],
            ),
          ),
        ),
      ),
      delay: 220,
    );
  }

  Widget _inquiryChart(AdminAnalyticsProvider provider) {
    final entries = provider.inquiryStats.entries.toList();

    return _chartContainer(
      title: "Inquiry Status",
      subtitle: "Buyer inquiry distribution",
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 42,
          sectionsSpace: 3,
          sections: List.generate(entries.length, (index) {
            final colors = [
              Colors.orange,
              Colors.green,
              Colors.redAccent,
              Colors.blue,
            ];

            return PieChartSectionData(
              value: entries[index].value,
              title: entries[index].key,
              radius: 62,
              color: colors[index],
              titleStyle: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            );
          }),
        ),
      ),
      delay: 340,
    );
  }

  Widget _chartContainer({
    required String title,
    required String subtitle,
    required Widget child,
    required int delay,
  }) {
    return Container(
      height: 285,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF123524),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 18),
          Expanded(child: child),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 480.ms, delay: delay.ms)
        .slideY(begin: 0.15, end: 0);
  }
}