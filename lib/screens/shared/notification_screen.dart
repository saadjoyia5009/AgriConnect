import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/notification_model.dart';
import '../../models/inquiry_model.dart';
import '../../models/buyer_inquiry_model.dart';
import '../../models/chat_conversation_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/buyer_inquiry_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/inquiry_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/notification_provider.dart';
import '../buyer/buyer_inquiry_detail_screen.dart';
import '../chat/chat_detail_screen.dart';
import '../farmer/farmer_inquiry_detail_screen.dart';

class NotificationScreen extends StatefulWidget {
  final String userRole;

  const NotificationScreen({
    super.key,
    required this.userRole,
  });

  static const Color darkGreen = Color(0xFF0E5A3C);
  static const Color lightGreen = Color(0xFFEAF7F0);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  Future<void> _refreshNotifications() async {
    await context.read<NotificationProvider>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final lang = context.watch<LanguageProvider>();

    final notifications = provider.getNotifications(widget.userRole);
    final unreadCount = provider.unreadCount(widget.userRole);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: NotificationScreen.darkGreen,
        foregroundColor: Colors.white,
        title: Text(
          widget.userRole == "farmer"
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
              onPressed: provider.isLoading
                  ? null
                  : () async {
                final success = await provider.markAllAsRead(
                  widget.userRole,
                );

                if (!mounted) return;

                if (!success && provider.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(provider.errorMessage!),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
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
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: Column(
          children: [
            _HeaderCard(
              unreadCount: unreadCount,
              userRole: widget.userRole,
            ),
            _FilterChips(
              selectedFilter: provider.selectedFilter,
              onChanged: provider.changeFilter,
            ),
            Expanded(
              child: _buildContent(
                context,
                provider,
                lang,
                notifications,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      NotificationProvider provider,
      LanguageProvider lang,
      List<NotificationModel> notifications,
      ) {
    if (provider.isLoading && provider.notifications.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.errorMessage != null && provider.notifications.isEmpty) {
      return _ErrorNotificationView(
        message: provider.errorMessage!,
        onRetry: provider.fetchNotifications,
      );
    }

    if (notifications.isEmpty) {
      return _EmptyNotificationView(
        userRole: widget.userRole,
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
      itemCount: notifications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final notification = notifications[index];

        return _NotificationCard(
          notification: notification,
          onTap: () async {
            if (!notification.isRead) {
              final success = await provider.markAsRead(notification.id);

              if (!mounted) return;

              if (!success && provider.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(provider.errorMessage!),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
            }

            if (!mounted) return;

            await _openNotification(context, notification);
          },
        );
      },
    );
  }

  Future<void> _openNotification(
      BuildContext context,
      NotificationModel notification,
      ) async {
    final relatedId = notification.relatedId?.trim() ?? '';

    if (relatedId.isEmpty) {
      _showNotificationMessage(context, notification);
      return;
    }

    try {
      switch (notification.type) {
        case 'inquiry':
          await _openInquiryNotification(context, relatedId);
          return;
        case 'chat':
          await _openChatNotification(context, relatedId);
          return;
        default:
          _showNotificationMessage(context, notification);
      }
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst('Exception: ', ''),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _openInquiryNotification(
      BuildContext context,
      String inquiryId,
      ) async {
    if (widget.userRole == 'farmer') {
      final inquiry = await _getFarmerInquiry(context, inquiryId);

      if (!context.mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FarmerInquiryDetailScreen(
            inquiryId: inquiry.id,
          ),
        ),
      );
      return;
    }

    final inquiry = await _getBuyerInquiry(context, inquiryId);

    if (!context.mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BuyerInquiryDetailScreen(
          inquiry: inquiry,
        ),
      ),
    );
  }

  Future<InquiryModel> _getFarmerInquiry(
      BuildContext context,
      String inquiryId,
      ) async {
    final provider = context.read<InquiryProvider>();

    InquiryModel? inquiry = provider.getInquiryById(inquiryId);

    if (inquiry == null) {
      await provider.fetchFarmerInquiries();
      inquiry = provider.getInquiryById(inquiryId);
    }

    if (inquiry == null) {
      throw Exception('Inquiry not found.');
    }

    return inquiry;
  }

  Future<BuyerInquiryModel> _getBuyerInquiry(
      BuildContext context,
      String inquiryId,
      ) async {
    final provider = context.read<BuyerInquiryProvider>();

    BuyerInquiryModel? inquiry = provider.getInquiryById(inquiryId);

    if (inquiry == null) {
      await provider.fetchBuyerInquiries();
      inquiry = provider.getInquiryById(inquiryId);
    }

    if (inquiry == null) {
      throw Exception('Inquiry not found.');
    }

    return inquiry;
  }

  Future<void> _openChatNotification(
      BuildContext context,
      String conversationId,
      ) async {
    final conversation = await _getConversation(context, conversationId);

    if (!context.mounted) return;

    final currentUserId =
        context.read<AuthProvider>().userId?.toString() ?? '';

    if (currentUserId.isEmpty) {
      throw Exception('Login information not found.');
    }

    final isBuyer = currentUserId == conversation.buyerId;

    final otherUserId = isBuyer
        ? conversation.farmerId
        : conversation.buyerId;

    final otherUserName = isBuyer
        ? conversation.farmerName
        : conversation.buyerName;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatDetailScreen(
          conversationId: conversation.id,
          inquiryId: conversation.inquiryId,
          currentUserId: currentUserId,
          otherUserId: otherUserId,
          otherUserName: otherUserName,
          cropName: conversation.cropName,
          cropImageUrl: conversation.cropImage,
          status: conversation.inquiryStatus,
        ),
      ),
    );
  }

  Future<ChatConversationModel> _getConversation(
      BuildContext context,
      String conversationId,
      ) async {
    final provider = context.read<ChatProvider>();

    ChatConversationModel? conversation;

    for (final item in provider.conversations) {
      if (item.id == conversationId) {
        conversation = item;
        break;
      }
    }

    if (conversation == null) {
      await provider.fetchConversations(showLoading: false);

      for (final item in provider.conversations) {
        if (item.id == conversationId) {
          conversation = item;
          break;
        }
      }
    }

    if (conversation == null) {
      throw Exception('Conversation not found.');
    }

    return conversation;
  }

  void _showNotificationMessage(
      BuildContext context,
      NotificationModel notification,
      ) {
    final lang = context.read<LanguageProvider>();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _notificationTitle(notification, lang),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: NotificationScreen.darkGreen,
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

  const _HeaderCard({
    required this.unreadCount,
    required this.userRole,
  });

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
        .replaceAll(
      "{count}",
      unreadCount.toString(),
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(18, 18, 18, 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0E5A3C),
            Color(0xFF178A5B),
          ],
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

  const _FilterChips({
    required this.selectedFilter,
    required this.onChanged,
  });

  static const filters = [
    "All",
    "Unread",
    "Inquiry",
    "Chat",
  ];

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

  String _filterLabel(
      String filter,
      LanguageProvider lang,
      ) {
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

  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  IconData get icon {
    switch (notification.type) {
      case "chat":
        return Icons.chat_bubble_rounded;
      case "system":
        return Icons.settings_rounded;
      case "inquiry":
      default:
        return Icons.notifications_active_rounded;
    }
  }

  Color get iconColor {
    switch (notification.type) {
      case "chat":
        return const Color(0xFF2563EB);
      case "system":
        return const Color(0xFFF59E0B);
      case "inquiry":
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
                    color: iconColor.withOpacity(
                      isDark ? 0.20 : 0.12,
                    ),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 26,
                  ),
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
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.color,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.message,
                    style: TextStyle(
                      color: isDark
                          ? Colors.white60
                          : Colors.grey.shade700,
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
                        color: isDark
                            ? Colors.white54
                            : Colors.grey.shade500,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _time(notification.time, lang),
                        style: TextStyle(
                          color: isDark
                              ? Colors.white60
                              : Colors.grey.shade600,
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
              color: isDark
                  ? Colors.white38
                  : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  String _title(
      NotificationModel notification,
      LanguageProvider lang,
      ) {
    switch (notification.title) {
      case "New Inquiry Received":
        return lang.t("newInquiryReceived");
      case "New Chat Message":
        return lang.t("newChatMessage");
      case "Inquiry Accepted":
        return notification.title;
      case "Inquiry Rejected":
        return notification.title;
      default:
        return notification.title;
    }
  }

  String _time(
      String value,
      LanguageProvider lang,
      ) {
    final dateTime = DateTime.tryParse(value);

    if (dateTime == null) {
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

    final localTime = dateTime.toLocal();
    final now = DateTime.now();
    final difference = now.difference(localTime);

    if (difference.isNegative) {
      return value;
    }

    if (difference.inSeconds < 60) {
      return "Just now";
    }

    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return minutes == 1
          ? "1 min ago"
          : "$minutes min ago";
    }

    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return hours == 1
          ? "1 hour ago"
          : "$hours hours ago";
    }

    if (difference.inDays == 1) {
      return "Yesterday";
    }

    if (difference.inDays < 7) {
      final days = difference.inDays;
      return days == 1
          ? "1 day ago"
          : "$days days ago";
    }

    final month = localTime.month.toString().padLeft(2, '0');
    final day = localTime.day.toString().padLeft(2, '0');

    return "$day/$month/${localTime.year}";
  }
}

class _EmptyNotificationView extends StatelessWidget {
  final String userRole;

  const _EmptyNotificationView({
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    final message = userRole == "farmer"
        ? lang.t("farmerNotificationEmpty")
        : lang.t("buyerNotificationEmpty");

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.40,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    size: 76,
                    color: isDark
                        ? Colors.white38
                        : Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    lang.t("noNotificationsFound"),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark
                          ? Colors.white60
                          : Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorNotificationView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorNotificationView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.40,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: isDark
                        ? Colors.white38
                        : Colors.grey.shade400,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "Unable to load notifications",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark
                          ? Colors.white60
                          : Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text("Retry"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

