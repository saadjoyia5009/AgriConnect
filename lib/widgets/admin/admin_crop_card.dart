import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../models/admin_crop_model.dart';

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
                  color: darkGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.grass_rounded,
                  color: darkGreen,
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
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1F3328),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Farmer: ${crop.farmerName}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                onSelected: (value) {
                  if (value == "status") onToggleStatus();
                  if (value == "delete") onDelete();
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: "status",
                    child: Text(
                      crop.status == "Active"
                          ? "Mark Inactive"
                          : "Mark Active",
                    ),
                  ),
                  const PopupMenuItem(
                    value: "delete",
                    child: Text("Delete Listing"),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _info(Icons.category_rounded, crop.category),
              const SizedBox(width: 10),
              _info(Icons.location_on_rounded, crop.location),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _info(Icons.payments_rounded, crop.price),
              const SizedBox(width: 10),
              _info(Icons.inventory_2_rounded, crop.quantity),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _chip(crop.status, statusColor),
              const Spacer(),
              Text(
                crop.listedDate,
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