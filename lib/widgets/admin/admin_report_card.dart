import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../models/admin_report_model.dart';

class AdminReportCard extends StatelessWidget {
  final AdminReportModel report;
  final int index;
  final ValueChanged<String> onStatusChanged;

  const AdminReportCard({
    super.key,
    required this.report,
    required this.index,
    required this.onStatusChanged,
  });

  static const Color darkGreen = Color(0xFF0E5A3C);

  Color get statusColor {
    switch (report.status) {
      case "Pending":
        return Colors.orange;
      case "Reviewed":
        return Colors.blue;
      case "Resolved":
        return Colors.green;
      default:
        return darkGreen;
    }
  }

  IconData get targetIcon {
    return report.targetType == "Crop"
        ? Icons.grass_rounded
        : Icons.person_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 16,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  Icons.report_problem_rounded,
                  color: statusColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.title,
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1F3328),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Reported by ${report.reportedBy}",
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onSelected: onStatusChanged,
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: "Pending",
                    child: Text("Mark Pending"),
                  ),
                  PopupMenuItem(
                    value: "Reviewed",
                    child: Text("Mark Reviewed"),
                  ),
                  PopupMenuItem(
                    value: "Resolved",
                    child: Text("Mark Resolved"),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            report.description,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _info(targetIcon, "${report.targetType}: ${report.targetName}"),
              const SizedBox(width: 10),
              _chip(report.status, statusColor),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.calendar_month_rounded,
                  size: 15, color: Colors.grey.shade500),
              const SizedBox(width: 5),
              Text(
                report.date,
                style: TextStyle(
                  fontSize: 11.5,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 420.ms, delay: (index * 70).ms)
        .slideY(begin: 0.14, end: 0);
  }

  Widget _info(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 15, color: Colors.grey.shade500),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.11),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}