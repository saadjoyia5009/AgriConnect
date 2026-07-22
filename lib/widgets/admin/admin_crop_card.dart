import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../models/admin_crop_model.dart';
import '../../providers/language_provider.dart';

class AdminCropCard extends StatelessWidget {
  final AdminCropModel crop;
  final int index;
  final VoidCallback onToggleStatus;
  final VoidCallback onDelete;

  const AdminCropCard({
    super.key,
    required this.crop,
    required this.index,
    required this.onToggleStatus,
    required this.onDelete,
  });

  static const Color darkGreen = Color(0xFF0E5A3C);
  static const Color lightGreen = Color(0xff9ff2c1);
  static const Color darkCard = Color(0xFF15251E);

  Color get statusColor {
    switch (crop.status) {
      case "Active":
        return Colors.green;
      case "Inactive":
        return Colors.grey;
      case "Reported":
        return Colors.redAccent;
      default:
        return darkGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? darkCard : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.transparent,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.22 : 0.055),
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
                      color: isDark
                          ? darkGreen.withOpacity(0.28)
                          : darkGreen.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Icon(
                      Icons.grass_rounded,
                      color: isDark ? lightGreen : darkGreen,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          crop.cropName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1F3328),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          context
                              .watch<LanguageProvider>()
                              .t("farmerPrefix")
                              .replaceAll('{value}', crop.farmerName),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: isDark
                                ? Colors.white70
                                : Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    color: isDark ? const Color(0xFF1E3128) : Colors.white,
                    iconColor: isDark ? Colors.white70 : Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onSelected: (value) {
                      if (value == "status") onToggleStatus();
                      if (value == "delete") onDelete();
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: "status",
                        child: Text(
                          crop.status == "Active"
                              ? context.watch<LanguageProvider>().t(
                                  "markInactive",
                                )
                              : context.watch<LanguageProvider>().t(
                                  "markActive",
                                ),
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: "delete",
                        child: Text(
                          context.watch<LanguageProvider>().t("deleteListing"),
                          style: TextStyle(
                            color: isDark ? Colors.red.shade200 : Colors.red,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _info(context, Icons.category_rounded, crop.category),
                  const SizedBox(width: 10),
                  _info(context, Icons.location_on_rounded, crop.location),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _info(context, Icons.payments_rounded, crop.price),
                  const SizedBox(width: 10),
                  _info(context, Icons.inventory_2_rounded, crop.quantity),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _chip(context, crop.status, statusColor),
                  const Spacer(),
                  Text(
                    crop.listedDate,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? Colors.white54 : Colors.grey.shade500,
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

  Widget _info(BuildContext context, IconData icon, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: 15,
            color: isDark ? Colors.white54 : Colors.grey.shade500,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String text, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.20 : 0.11),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(isDark ? 0.28 : 0)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: isDark && color == Colors.grey ? Colors.white70 : color,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
