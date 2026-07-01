import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/notification_model.dart';
import '../../providers/language_provider.dart';
import '../../providers/notification_provider.dart';

class NotificationScreen extends StatelessWidget {
  final String userRole;

  const NotificationScreen({super.key, required this.userRole});

  static const Color darkGreen = Color(0xFF0E5A3C);
  static const Color lightGreen = Color(0xFFEAF7F0);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final lang = context.watch<LanguageProvider>();
    final notifications = provider.getNotifications(userRole);
    final unreadCount = provider.unreadCount(userRole);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        title: Text(
          userRole == "farmer"
              ? lang.t("farmerNotifications")
              : lang.t("buyerNotifications"),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 0.2,
          ),
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () => provider.markAllAsRead(userRole),
              child: Text(
                lang.t("markAllRead"),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          _HeaderCard(unreadCount: unreadCount, userRole: userRole),
          _FilterChips(
            selectedFilter: provider.selectedFilter,
            onChanged: provider.changeFilter,
          ),
          Expanded(
            child: notifications.isEmpty
                ? _EmptyNotificationView(userRole: userRole)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                    itemCount: notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final notification = notifications[index];

                      return _NotificationCard(
                        notification: notification,
                        onTap: () {
                          provider.markAsRead(notification.id);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _notificationTitle(notification, lang),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: darkGreen,
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _notificationTitle(
    NotificationModel notification,
    LanguageProvider lang,
  ) {
    switch (notification.title) {
      case "New Inquiry Received":
        return lang.t("newInquiryReceived");
      case "New Chat Message":
        return lang.t("newChatMessage");
      default:
        return notification.title;
    }
  }
}

class _HeaderCard extends StatelessWidget {
  final int unreadCount;
  final String userRole;

  const _HeaderCard({required this.unreadCount, required this.userRole});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final title = userRole == "farmer"
        ? lang.t("farmerAlerts")
        : lang.t("buyerAlerts");
    final subtitle = unreadCount == 0
        ? lang.t("noUnreadNotifications")
        : lang
              .t(
                unreadCount > 1
                    ? "unreadNotificationsCount"
                    : "unreadNotificationCount",
              )
              .replaceAll("{count}", unreadCount.toString());

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(18, 18, 18, 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0E5A3C), Color(0xFF178A5B)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E5A3C).withOpacity(0.24),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              userRole == "farmer"
                  ? Icons.agriculture_rounded
                  : Icons.shopping_bag_rounded,
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
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.88),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onChanged;

  const _FilterChips({required this.selectedFilter, required this.onChanged});

  static const filters = ["All", "Unread", "Inquiry", "Chat"];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return ChoiceChip(
            label: Text(_filterLabel(filter, lang)),
            selected: isSelected,
            onSelected: (_) => onChanged(filter),
            selectedColor: NotificationScreen.darkGreen,
            backgroundColor: Theme.of(context).cardColor,
            labelStyle: TextStyle(
              color: isSelected
                  ? Colors.white
                  : isDark
                  ? Colors.white
                  : const Color(0xFF1E3328),
              fontWeight: FontWeight.w800,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(
                color: isSelected
                    ? NotificationScreen.darkGreen
                    : isDark
                    ? Colors.white12
                    : Colors.grey.shade300,
              ),
            ),
          );
        },
      ),
    );
  }

  String _filterLabel(String filter, LanguageProvider lang) {
    switch (filter) {
      case "All":
        return lang.t("all");
      case "Unread":
        return lang.t("unread");
      case "Inquiry":
        return lang.t("inquiry");
      case "Chat":
        return lang.t("chat");
      default:
        return filter;
    }
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  IconData get icon {
    switch (notification.type) {
      case "chat":
        return Icons.chat_bubble_rounded;
      case "system":
        return Icons.settings_rounded;
      default:
        return notification.role == "farmer"
            ? Icons.assignment_rounded
            : Icons.assignment_turned_in_rounded;
    }
  }

  Color get iconColor {
    switch (notification.type) {
      case "chat":
        return const Color(0xFF2563EB);
      case "system":
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF0E5A3C);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Theme.of(context).cardColor
              : isDark
              ? const Color(0xFF173526)
              : NotificationScreen.lightGreen,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: notification.isRead
                ? isDark
                      ? Colors.white12
                      : Colors.grey.shade200
                : NotificationScreen.darkGreen.withOpacity(
                    isDark ? 0.45 : 0.22,
                  ),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.18)
                  : Colors.black.withOpacity(0.045),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(isDark ? 0.20 : 0.12),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Icon(icon, color: iconColor, size: 26),
                ),
                if (!notification.isRead)
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      height: 11,
                      width: 11,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE11D48),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _title(notification, lang),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _message(notification, lang),
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.grey.shade700,
                      fontSize: 13.5,
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 15,
                        color: isDark ? Colors.white54 : Colors.grey.shade500,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _time(notification.time, lang),
                        style: TextStyle(
                          color: isDark ? Colors.white60 : Colors.grey.shade600,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? Colors.white38 : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  String _title(NotificationModel notification, LanguageProvider lang) {
    switch (notification.title) {
      case "New Inquiry Received":
        return lang.t("newInquiryReceived");
      case "New Chat Message":
        return lang.t("newChatMessage");
      default:
        return notification.title;
    }
  }

  String _message(NotificationModel notification, LanguageProvider lang) {
    switch (notification.message) {
      case "Ahmed wants to buy your Organic Wheat crop.":
        return lang.t("notificationFarmerInquiry");
      case "Buyer sent: Can you supply 100kg this week?":
        return lang.t("notificationBuyerChat");
      default:
        return notification.message;
    }
  }

  String _time(String value, LanguageProvider lang) {
    switch (value) {
      case "2 min ago":
        return lang.t("twoMinAgo");
      case "10 min ago":
        return lang.t("tenMinAgo");
      case "Yesterday":
        return lang.t("yesterday");
      default:
        return value;
    }
  }
}

class _EmptyNotificationView extends StatelessWidget {
  final String userRole;

  const _EmptyNotificationView({required this.userRole});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    final message = userRole == "farmer"
        ? lang.t("farmerNotificationEmpty")
        : lang.t("buyerNotificationEmpty");

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 76,
              color: isDark ? Colors.white38 : Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              lang.t("noNotificationsFound"),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.white60 : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
