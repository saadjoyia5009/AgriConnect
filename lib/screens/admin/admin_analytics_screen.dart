import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_analytics_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/admin/admin_analytics_shimmer.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
  static const Color darkGreen = Color(0xFF0E5A3C);
  static const Color lightBackground = Color(0xFFF4F8F5);
  static const Color darkBackground = Color(0xFF0B1410);
  static const Color darkCard = Color(0xFF15251E);
  static const Color lightGreen = Color(0xff9ff2c1);

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get accentColor => isDark ? lightGreen : darkGreen;
  Color get primaryText => isDark ? Colors.white : const Color(0xFF123524);
  Color get secondaryText => isDark ? Colors.white70 : Colors.grey.shade600;
  Color get chartLabelColor => isDark ? Colors.white60 : Colors.grey.shade600;

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
      backgroundColor: isDark ? darkBackground : lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? darkCard : darkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context.watch<LanguageProvider>().t("analytics"),
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: Consumer<AdminAnalyticsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const AdminAnalyticsShimmer();
          }

          return RefreshIndicator(
            color: accentColor,
            backgroundColor: isDark ? darkCard : Colors.white,
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
        gradient: LinearGradient(
          colors: isDark
              ? const [Color(0xFF123524), Color(0xFF0E5A3C)]
              : const [Color(0xFF0E5A3C), Color(0xFF157A52)],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.35)
                : darkGreen.withOpacity(0.22),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          _summaryItem(
            context.watch<LanguageProvider>().t("users"),
            provider.totalUsers.toString(),
          ),
          _divider(),
          _summaryItem(
            context.watch<LanguageProvider>().t("crops"),
            provider.totalCrops.toString(),
          ),
          _divider(),
          _summaryItem(
            context.watch<LanguageProvider>().t("deals"),
            provider.completedDeals.toString(),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 450.ms).slideY(begin: -0.12, end: 0);
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
          const Text(" ", style: TextStyle(fontSize: 0)),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
      color: Colors.white.withOpacity(isDark ? 0.14 : 0.25),
    );
  }

  Widget _userGrowthChart(AdminAnalyticsProvider provider) {
    final entries = provider.userGrowth.entries.toList();

    return _chartContainer(
      title: context.watch<LanguageProvider>().t("userGrowth"),
      subtitle: context.watch<LanguageProvider>().t("monthlyRegisteredUsers"),
      child: LineChart(
        LineChartData(
          minY: 0,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) {
              return FlLine(
                color: isDark ? Colors.white10 : Colors.grey.withOpacity(0.18),
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
                        color: chartLabelColor,
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
              color: accentColor,
              barWidth: 4,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: accentColor.withOpacity(0.12),
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
      title: context.watch<LanguageProvider>().t("cropCategories"),
      subtitle: context.watch<LanguageProvider>().t("mostListedCropTypes"),
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
                        color: chartLabelColor,
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
                  color: isDark ? const Color(0xffffc166) : Colors.orange,
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
      title: context.watch<LanguageProvider>().t("inquiryStatus"),
      subtitle: context.watch<LanguageProvider>().t("buyerInquiryDistribution"),
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 42,
          sectionsSpace: 3,
          sections: List.generate(entries.length, (index) {
            final colors = [
              isDark ? const Color(0xffffc166) : Colors.orange,
              isDark ? lightGreen : Colors.green,
              Colors.redAccent,
              isDark ? const Color(0xff7bb8ff) : Colors.blue,
            ];

            return PieChartSectionData(
              value: entries[index].value,
              title: entries[index].key,
              radius: 62,
              color: colors[index % colors.length],
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
            color: isDark ? darkCard : Colors.white,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.transparent,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.22 : 0.055),
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: secondaryText,
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
