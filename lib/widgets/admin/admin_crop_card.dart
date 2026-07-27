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
  static const Color lightGreen = Color(0xFF9FF2C1);
  static const Color darkCard = Color(0xFF15251E);

  Color get statusColor {
    switch (crop.status.toLowerCase()) {
      case "active":
        return Colors.green;

      case "draft":
        return Colors.orange;

      case "sold out":
        return Colors.grey;

      default:
        return darkGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final lang = context.watch<LanguageProvider>();

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
            color: Colors.black.withOpacity(
              isDark ? 0.22 : 0.055,
            ),
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
                      crop.cropName.isEmpty
                          ? "Unnamed Crop"
                          : crop.cropName,
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
                      lang
                          .t("farmerPrefix")
                          .replaceAll(
                        "{value}",
                        crop.farmerName.isEmpty
                            ? "Unknown"
                            : crop.farmerName,
                      ),
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

              const SizedBox(width: 8),

              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _showCropActions(context);
                  },
                  borderRadius: BorderRadius.circular(24),
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Icon(
                      Icons.more_vert_rounded,
                      color: isDark
                          ? Colors.white70
                          : Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              _info(
                context,
                Icons.category_rounded,
                crop.category.isEmpty
                    ? "No category"
                    : crop.category,
              ),
              const SizedBox(width: 10),
              _info(
                context,
                Icons.location_on_rounded,
                crop.location.isEmpty
                    ? "No location"
                    : crop.location,
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              _info(
                context,
                Icons.payments_rounded,
                crop.price,
              ),
              const SizedBox(width: 10),
              _info(
                context,
                Icons.inventory_2_rounded,
                crop.quantity,
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _chip(
                context,
                crop.status,
                statusColor,
              ),
              const Spacer(),
              Text(
                crop.listedDate,
                style: TextStyle(
                  fontSize: 11.5,
                  color: isDark
                      ? Colors.white54
                      : Colors.grey.shade500,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
      duration: 420.ms,
      delay: (index * 70).ms,
    )
        .slideY(
      begin: 0.14,
      end: 0,
    );
  }

  Future<void> _showCropActions(BuildContext context) async {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final bool isActive =
        crop.status.toLowerCase() == "active";

    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            26,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF15251E)
                : Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(26),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white24
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: darkGreen.withOpacity(
                        isDark ? 0.30 : 0.12,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.grass_rounded,
                      color: isDark ? lightGreen : darkGreen,
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          crop.cropName.isEmpty
                              ? "Crop Actions"
                              : crop.cropName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF123524),
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          "Manage crop listing",
                          style: TextStyle(
                            color: isDark
                                ? Colors.white60
                                : Colors.grey.shade600,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                    },
                    icon: const Icon(Icons.close_rounded),
                    color: isDark
                        ? Colors.white70
                        : Colors.black54,
                  ),
                ],
              ),

              const SizedBox(height: 18),

              _actionTile(
                context: sheetContext,
                icon: isActive
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                title: isActive
                    ? "Move to Draft"
                    : "Mark as Active",
                subtitle: isActive
                    ? "Hide this crop from the marketplace"
                    : "Show this crop on the marketplace",
                color: isActive
                    ? Colors.orange
                    : Colors.green,
                onTap: () {
                  Navigator.pop(sheetContext);
                  onToggleStatus();
                },
              ),

              const SizedBox(height: 10),

              _actionTile(
                context: sheetContext,
                icon: Icons.delete_outline_rounded,
                title: "Delete Listing",
                subtitle:
                "Permanently remove this crop listing",
                color: Colors.redAccent,
                onTap: () {
                  Navigator.pop(sheetContext);
                  onDelete();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _actionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(
              isDark ? 0.14 : 0.08,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(
                isDark ? 0.28 : 0.16,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(
                    isDark ? 0.22 : 0.13,
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : const Color(0xFF1F3328),
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      style: TextStyle(
                        color: isDark
                            ? Colors.white60
                            : Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right_rounded,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _info(
      BuildContext context,
      IconData icon,
      String text,
      ) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: 15,
            color: isDark
                ? Colors.white54
                : Colors.grey.shade500,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? Colors.white70
                    : Colors.grey.shade700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(
      BuildContext context,
      String text,
      Color color,
      ) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(
          isDark ? 0.20 : 0.11,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: color.withOpacity(
            isDark ? 0.28 : 0,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: isDark && color == Colors.grey
              ? Colors.white70
              : color,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}