import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/notification_provider.dart';

class FarmerTopBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationTap;

  const FarmerTopBar({
    super.key,
    required this.title,
    this.onNotificationTap,
  });

  static const Color darkGreen = Color(0xFF0E5A3C);

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  State<FarmerTopBar> createState() => _FarmerTopBarState();
}

class _FarmerTopBarState extends State<FarmerTopBar> {
  @override
  void initState() {
    super.initState();

    // Load the farmer's notifications when the top bar first appears.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Rebuild the badge whenever the notification provider changes.
    final notificationProvider = context.watch<NotificationProvider>();
    final unreadCount = notificationProvider.unreadCount('farmer');
    final hasUnreadNotifications = unreadCount > 0;

    return AppBar(
      backgroundColor: FarmerTopBar.darkGreen,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 72,
      centerTitle: true,
      leading: const Padding(
        padding: EdgeInsets.only(left: 14),
        child: Icon(
          Icons.agriculture_outlined,
          color: Colors.white,
          size: 24,
        ),
      ),
      title: Text(
        widget.title,
        style: GoogleFonts.outfit(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: widget.onNotificationTap ??
                    () {
                  Navigator.pushNamed(context, "/notifications");
                },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.10)
                        : Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(
                        isDark ? 0.08 : 0.12,
                      ),
                    ),
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                // Show the red dot only when there are real unread notifications.
                if (hasUnreadNotifications)
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
