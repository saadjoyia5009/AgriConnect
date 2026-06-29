import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../models/admin_user_model.dart';

class AdminUserCard extends StatelessWidget {
  final AdminUserModel user;
  final int index;
  final VoidCallback onToggleStatus;

  const AdminUserCard({
    super.key,
    required this.user,
    required this.index,
    required this.onToggleStatus,
  });

  static const Color darkGreen = Color(0xFF0E5A3C);

  @override
  Widget build(BuildContext context) {
    final bool isFarmer = user.role == "Farmer";

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
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor:
            isFarmer ? darkGreen.withOpacity(0.12) : Colors.blue.withOpacity(0.12),
            child: Icon(
              isFarmer ? Icons.agriculture_rounded : Icons.shopping_bag_rounded,
              color: isFarmer ? darkGreen : Colors.blue,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1F3328),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _chip(user.role, isFarmer ? darkGreen : Colors.blue),
                    const SizedBox(width: 8),
                    _chip(
                      user.isActive ? "Active" : "Suspended",
                      user.isActive ? Colors.green : Colors.redAccent,
                    ),
                  ],
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
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: "status",
                child: Text(user.isActive ? "Suspend User" : "Activate User"),
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