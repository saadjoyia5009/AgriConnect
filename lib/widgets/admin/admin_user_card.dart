import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../models/admin_user_model.dart';
import '../../providers/language_provider.dart';

class AdminUserCard extends StatelessWidget {
  final AdminUserModel user;
  final int index;
  final VoidCallback onToggleStatus;
  final bool isProcessing;

  const AdminUserCard({
    super.key,
    required this.user,
    required this.index,
    required this.onToggleStatus,
    this.isProcessing = false,
  });

  static const Color darkGreen = Color(0xFF0E5A3C);
  static const Color lightGreen = Color(0xFF9FF2C1);
  static const Color darkCard = Color(0xFF15251E);

  bool get isFarmer => user.role.toLowerCase() == "farmer";
  bool get isBuyer => user.role.toLowerCase() == "buyer";
  bool get isAdmin => user.role.toLowerCase() == "admin";

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
            color: Colors.black.withOpacity(
              isDark ? 0.22 : 0.055,
            ),
            blurRadius: 16,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: _roleColor().withOpacity(
              isDark ? 0.22 : 0.12,
            ),
            child: Icon(
              _roleIcon(),
              color: isDark && isFarmer
                  ? lightGreen
                  : _roleColor(),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name.isEmpty ? user.username : user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF1F3328),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  user.email,
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

                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _chip(
                      context,
                      user.role,
                      _roleColor(),
                    ),
                    _chip(
                      context,
                      user.isActive
                          ? context
                          .watch<LanguageProvider>()
                          .t("active")
                          : context
                          .watch<LanguageProvider>()
                          .t("suspended"),
                      user.isActive
                          ? Colors.green
                          : Colors.redAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          SizedBox(
            width: 44,
            height: 44,
            child: isProcessing
                ? const Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(
                color: darkGreen,
                strokeWidth: 2.4,
              ),
            )
                : IconButton(
              tooltip: "User actions",
              splashRadius: 22,
              onPressed: () {
                _showUserActions(context);
              },
              icon: Icon(
                Icons.more_vert_rounded,
                color: isDark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
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

  Future<void> _showUserActions(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      backgroundColor: isDark
          ? const Color(0xFF1E3128)
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 44,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white24
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 18),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: _roleColor().withOpacity(0.12),
                  child: Icon(
                    _roleIcon(),
                    color: _roleColor(),
                  ),
                ),
                title: Text(
                  user.name.isEmpty ? user.username : user.name,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF1F3328),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                subtitle: Text(
                  user.email,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white60
                        : Colors.grey.shade600,
                  ),
                ),
              ),

              Divider(
                color: isDark
                    ? Colors.white12
                    : Colors.grey.shade200,
              ),

              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                leading: Icon(
                  user.isActive
                      ? Icons.block_rounded
                      : Icons.check_circle_rounded,
                  color: user.isActive
                      ? Colors.redAccent
                      : Colors.green,
                ),
                title: Text(
                  user.isActive
                      ? context
                      .read<LanguageProvider>()
                      .t("suspendUser")
                      : context
                      .read<LanguageProvider>()
                      .t("activateUser"),
                  style: TextStyle(
                    color: user.isActive
                        ? Colors.redAccent
                        : Colors.green,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showStatusConfirmation(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showStatusConfirmation(
      BuildContext context,
      ) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: isDark
              ? const Color(0xFF1E3128)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            user.isActive
                ? "Suspend user?"
                : "Activate user?",
            style: TextStyle(
              color: isDark
                  ? Colors.white
                  : const Color(0xFF1F3328),
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            user.isActive
                ? "${user.name} will not be able to login until activated again."
                : "${user.name} will be allowed to login again.",
            style: TextStyle(
              color: isDark
                  ? Colors.white70
                  : Colors.grey.shade700,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: user.isActive
                    ? Colors.redAccent
                    : Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text(
                user.isActive ? "Suspend" : "Activate",
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      onToggleStatus();
    }
  }

  Color _roleColor() {
    if (isFarmer) return darkGreen;
    if (isBuyer) return Colors.blue;
    if (isAdmin) return Colors.deepPurple;

    return Colors.grey;
  }

  IconData _roleIcon() {
    if (isFarmer) return Icons.agriculture_rounded;
    if (isBuyer) return Icons.shopping_bag_rounded;
    if (isAdmin) return Icons.admin_panel_settings_rounded;

    return Icons.person_rounded;
  }

  Widget _chip(
      BuildContext context,
      String text,
      Color color,
      ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            isDark ? 0.30 : 0,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: isDark && isFarmer
              ? lightGreen
              : color,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}