import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_reports_provider.dart';
import '../../widgets/admin/admin_report_card.dart';
import '../../widgets/admin/admin_report_shimmer.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  static const Color darkGreen = Color(0xFF0E5A3C);
  static const Color lightBackground = Color(0xFFF4F8F5);
  static const Color darkBackground = Color(0xFF0B1410);
  static const Color darkCard = Color(0xFF15251E);
  static const Color lightGreen = Color(0xff9ff2c1);

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get accentColor => isDark ? lightGreen : darkGreen;
  Color get primaryText => isDark ? Colors.white : const Color(0xFF123524);
  Color get secondaryText => isDark ? Colors.white70 : Colors.grey.shade700;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AdminReportsProvider>().fetchReports();
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
        title: const Text(
          "Reports",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: Consumer<AdminReportsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const AdminReportShimmer();
          }

          return Column(
            children: [
              _filters(provider),
              Expanded(
                child: provider.reports.isEmpty
                    ? Center(
                  child: Text(
                    "No reports found",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: primaryText,
                    ),
                  ),
                )
                    : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  itemCount: provider.reports.length,
                  itemBuilder: (context, index) {
                    final report = provider.reports[index];

                    return AdminReportCard(
                      report: report,
                      index: index,
                      onStatusChanged: (status) {
                        provider.updateReportStatus(report.id, status);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _filters(AdminReportsProvider provider) {
    final filters = ["All", "Pending", "Reviewed", "Resolved"];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      height: 78,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = provider.selectedFilter == filter;

          return GestureDetector(
            onTap: () => provider.changeFilter(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: selected
                    ? (isDark ? darkGreen.withOpacity(0.45) : darkGreen)
                    : (isDark ? darkCard : Colors.white),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected
                      ? accentColor
                      : (isDark ? Colors.white10 : Colors.transparent),
                ),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    color: selected
                        ? (isDark ? lightGreen : Colors.white)
                        : secondaryText,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}