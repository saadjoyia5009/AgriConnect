import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../models/admin_user_model.dart';
import '../../providers/language_provider.dart';

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
  static const Color lightGreen = Color(0xff9ff2c1);
  static const Color darkCard = Color(0xFF15251E);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isFarmer = user.role == "Farmer";

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
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: isFarmer
                    ? darkGreen.withOpacity(isDark ? 0.28 : 0.12)
                    : Colors.blue.withOpacity(isDark ? 0.22 : 0.12),
                child: Icon(
                  isFarmer
                      ? Icons.agriculture_rounded
                      : Icons.shopping_bag_rounded,
                  color: isFarmer
                      ? (isDark ? lightGreen : darkGreen)
                      : Colors.blue,
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : const Color(0xFF1F3328),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark ? Colors.white70 : Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _chip(
                          context,
                          user.role,
                          isFarmer ? darkGreen : Colors.blue,
                        ),
                        _chip(
                          context,
                          user.isActive
                              ? context.watch<LanguageProvider>().t("active")
                              : context.watch<LanguageProvider>().t(
                                  "suspended",
                                ),
                          user.isActive ? Colors.green : Colors.redAccent,
                        ),
                      ],
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
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: "status",
                    child: Text(
                      user.isActive
                          ? context.watch<LanguageProvider>().t("suspendUser")
                          : context.watch<LanguageProvider>().t("activateUser"),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w700,
                      ),
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

  Widget _chip(BuildContext context, String text, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.20 : 0.11),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(isDark ? 0.30 : 0)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: isDark && color == darkGreen ? lightGreen : color,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
