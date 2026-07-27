import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../providers/admin_dashboard_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/admin/admin_dashboard_shimmer.dart';
import '../../widgets/admin/admin_stat_card.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  static const Color darkGreen = Color(0xFF0E5A3C);
  static const Color lightBackground = Color(0xFFF4F8F5);
  static const Color darkBackground = Color(0xFF0B1410);
  static const Color darkCard = Color(0xFF15251E);
  static const Color lightGreen = Color(0xFF9FF2C1);

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get accentColor => isDark ? lightGreen : darkGreen;

  Color get primaryText {
    return isDark ? Colors.white : const Color(0xFF123524);
  }

  Color get secondaryText {
    return isDark ? Colors.white70 : Colors.grey;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<AdminDashboardProvider>().fetchDashboardStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? darkBackground : lightBackground,
      body: Consumer<AdminDashboardProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.stats == null) {
            return const AdminDashboardShimmer();
          }

          if (provider.stats == null) {
            return _buildErrorState(provider);
          }

          final stats = provider.stats!;

          return ResponsiveLayout(
            child: SafeArea(
              child: RefreshIndicator(
                color: accentColor,
                backgroundColor: isDark ? darkCard : Colors.white,
                onRefresh: provider.refreshDashboardStats,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.all(20),
                  children: [
                    _header(),
                    const SizedBox(height: 22),

                    if (provider.errorMessage != null) ...[
                      _refreshErrorBanner(
                        message: provider.errorMessage!,
                        onRetry: provider.refreshDashboardStats,
                      ),
                      const SizedBox(height: 16),
                    ],

                    AdminStatCard(
                      title: context
                          .watch<LanguageProvider>()
                          .t("totalFarmers"),
                      value: stats.totalFarmers.toString(),
                      icon: Icons.agriculture_rounded,
                      color: darkGreen,
                      index: 0,
                    ),
                    const SizedBox(height: 14),

                    AdminStatCard(
                      title: context
                          .watch<LanguageProvider>()
                          .t("totalBuyers"),
                      value: stats.totalBuyers.toString(),
                      icon: Icons.shopping_bag_rounded,
                      color: Colors.blue,
                      index: 1,
                    ),
                    const SizedBox(height: 14),

                    AdminStatCard(
                      title: context
                          .watch<LanguageProvider>()
                          .t("totalCrops"),
                      value: stats.totalCrops.toString(),
                      icon: Icons.grass_rounded,
                      color: Colors.orange,
                      index: 2,
                    ),
                    const SizedBox(height: 14),

                    AdminStatCard(
                      title: context
                          .watch<LanguageProvider>()
                          .t("totalInquiries"),
                      value: stats.totalInquiries.toString(),
                      icon: Icons.mark_email_unread_rounded,
                      color: Colors.purple,
                      index: 3,
                    ),
                    const SizedBox(height: 14),

                    AdminStatCard(
                      title: context
                          .watch<LanguageProvider>()
                          .t("activeListings"),
                      value: stats.activeListings.toString(),
                      icon: Icons.verified_rounded,
                      color: Colors.teal,
                      index: 4,
                    ),
                    const SizedBox(height: 14),

                    AdminStatCard(
                      title: context
                          .watch<LanguageProvider>()
                          .t("pendingReports"),
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

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(AdminDashboardProvider provider) {
    return ResponsiveLayout(
      child: SafeArea(
        child: RefreshIndicator(
          color: accentColor,
          backgroundColor: isDark ? darkCard : Colors.white,
          onRefresh: provider.refreshDashboardStats,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.18,
              ),
              Icon(
                Icons.cloud_off_rounded,
                size: 70,
                color: isDark ? Colors.white54 : darkGreen,
              ),
              const SizedBox(height: 18),
              Text(
                "Unable to load dashboard",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                provider.errorMessage ??
                    context
                        .watch<LanguageProvider>()
                        .t("noDashboardDataFound"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: provider.isLoading
                      ? null
                      : provider.fetchDashboardStats,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: provider.isLoading
                      ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Icon(Icons.refresh_rounded),
                  label: const Text(
                    "Retry",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _refreshErrorBanner({
    required String message,
    required Future<void> Function() onRetry,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.red.withOpacity(0.14)
            : Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.red.withOpacity(0.25),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isDark ? Colors.red.shade200 : Colors.red.shade800,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [
            Color(0xFF123524),
            Color(0xFF0E5A3C),
          ]
              : const [
            Color(0xFF0E5A3C),
            Color(0xFF157A52),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.35)
                : darkGreen.withOpacity(0.25),
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
              color: Colors.white.withOpacity(
                isDark ? 0.14 : 0.18,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.admin_panel_settings_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context
                      .watch<LanguageProvider>()
                      .t("adminDashboard"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  context
                      .watch<LanguageProvider>()
                      .t("manageAgriConnectActivity"),
                  style: const TextStyle(
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
    ).animate().fadeIn(
      duration: 500.ms,
    ).slideY(
      begin: -0.18,
      end: 0,
    );
  }

  Widget _quickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.watch<LanguageProvider>().t("quickActions"),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: primaryText,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _actionCard(
                context,
                title: context.watch<LanguageProvider>().t("users"),
                icon: Icons.people_alt_rounded,
                color: darkGreen,
                route: "/adminUsers",
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _actionCard(
                context,
                title: context.watch<LanguageProvider>().t("crops"),
                icon: Icons.grass_rounded,
                color: Colors.orange,
                route: "/adminCrops",
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
                title: context.watch<LanguageProvider>().t("analytics"),
                icon: Icons.bar_chart_rounded,
                color: Colors.purple,
                route: "/adminAnalytics",
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _actionCard(
                context,
                title: context.watch<LanguageProvider>().t("reports"),
                icon: Icons.report_problem_rounded,
                color: Colors.redAccent,
                route: "/adminReports",
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(
      duration: 500.ms,
      delay: 650.ms,
    ).slideY(
      begin: 0.15,
      end: 0,
    );
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
          color: isDark ? darkCard : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.22)
                  : color.withOpacity(0.10),
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
                color: color.withOpacity(isDark ? 0.20 : 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chartCard(
      int farmers,
      int buyers,
      int crops,
      ) {
    return Container(
      height: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? darkCard : Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              isDark ? 0.22 : 0.06,
            ),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context
                .watch<LanguageProvider>()
                .t("platformOverview"),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: primaryText,
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
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final labels = [
                          "Farmers",
                          "Buyers",
                          "Crops",
                        ];

                        final index = value.toInt();

                        if (index < 0 || index >= labels.length) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            labels[index],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: secondaryText,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  _barGroup(
                    0,
                    farmers.toDouble(),
                    darkGreen,
                  ),
                  _barGroup(
                    1,
                    buyers.toDouble(),
                    Colors.blue,
                  ),
                  _barGroup(
                    2,
                    crops.toDouble(),
                    Colors.orange,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
      duration: 500.ms,
      delay: 500.ms,
    ).slideY(
      begin: 0.18,
      end: 0,
    );
  }

  BarChartGroupData _barGroup(
      int x,
      double y,
      Color color,
      ) {
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