import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chat_conversation_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/farmer_bottom_navbar.dart';
import '../chat/chat_detail_screen.dart';

class FarmerChatsScreen extends StatefulWidget {
  const FarmerChatsScreen({super.key});

  @override
  State<FarmerChatsScreen> createState() {
    return _FarmerChatsScreenState();
  }
}

class _FarmerChatsScreenState extends State<FarmerChatsScreen> {
  static const Color darkGreen = Color(0xff0F5C3A);
  static const Color lightGreen = Color(0xff0F8A3B);

  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = "All";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<ChatProvider>().fetchConversations();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ChatConversationModel> _filteredChats(
      List<ChatConversationModel> conversations,
      ) {
    final query = _searchController.text.trim().toLowerCase();

    return conversations.where((conversation) {
      if (!conversation.canChat || conversation.id.trim().isEmpty) {
        return false;
      }

      final matchesSearch =
          conversation.buyerName.toLowerCase().contains(query) ||
              conversation.cropName.toLowerCase().contains(query) ||
              conversation.displayLastMessage.toLowerCase().contains(query);

      bool matchesFilter;

      switch (_selectedFilter) {
        case "Unread":
          matchesFilter = conversation.unreadCount > 0;
          break;

        case "Active":
          matchesFilter =
              conversation.inquiryStatus.toLowerCase() == "accepted";
          break;

        case "Closed":
          final status = conversation.inquiryStatus.toLowerCase();

          matchesFilter = status == "completed" || status == "rejected";
          break;

        default:
          matchesFilter = true;
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Directionality(
      textDirection: lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        bottomNavigationBar: const FarmerBottomNavbar(currentIndex: 2),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: darkGreen,
          elevation: 0,
          centerTitle: true,
          title: Text(
            lang.t("chats"),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 22,
            ),
          ),
          actions: [
            Consumer<ChatProvider>(
              builder: (context, provider, _) {
                if (provider.isConversationLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 21,
                      height: 21,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.2,
                      ),
                    ),
                  );
                }

                return IconButton(
                  tooltip: lang.t("refreshChats"),
                  onPressed: provider.fetchConversations,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            _searchBox(),
            _filterChips(),
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, provider, _) {
                  return _buildContent(provider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ChatProvider provider) {
    if (provider.isConversationLoading && provider.conversations.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: darkGreen));
    }

    if (provider.conversationErrorMessage != null &&
        provider.conversations.isEmpty) {
      return _errorState(provider.conversationErrorMessage!);
    }

    final chats = _filteredChats(provider.conversations);

    return RefreshIndicator(
      color: darkGreen,
      onRefresh: provider.fetchConversations,
      child: chats.isEmpty
          ? _emptyState()
          : ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        itemCount: chats.length,
        separatorBuilder: (_, __) {
          return const SizedBox(height: 14);
        },
        itemBuilder: (context, index) {
          return _chatCard(chats[index]);
        },
      ),
    );
  }

  Widget _searchBox() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
      child: TextField(
        controller: _searchController,
        onChanged: (_) {
          setState(() {});
        },
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        decoration: InputDecoration(
          hintText: lang.t("searchBuyerCrop"),
          hintStyle: TextStyle(
            color: isDark ? Colors.white54 : Colors.grey.shade500,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).iconTheme.color,
          ),
          suffixIcon: _searchController.text.isEmpty
              ? null
              : IconButton(
            onPressed: () {
              _searchController.clear();
              setState(() {});
            },
            icon: const Icon(Icons.close),
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: _searchBorder(isDark),
          enabledBorder: _searchBorder(isDark),
          focusedBorder: _searchBorder(isDark, color: darkGreen),
        ),
      ),
    );
  }

  OutlineInputBorder _searchBorder(bool isDark, {Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(26),
      borderSide: BorderSide(
        color: color ?? (isDark ? Colors.white12 : Colors.grey.shade200),
      ),
    );
  }

  Widget _filterChips() {
    const filters = ["All", "Unread", "Active", "Closed"];

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return SizedBox(
      height: 54,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 10);
        },
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;

          return ChoiceChip(
            label: Text(
              _filterLabel(filter, lang),
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.black),
                fontWeight: FontWeight.w800,
              ),
            ),
            selected: isSelected,
            selectedColor: lightGreen,
            backgroundColor: Theme.of(context).cardColor,
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: isDark ? Colors.white12 : Colors.grey.shade200,
              ),
            ),
            onSelected: (_) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          );
        },
      ),
    );
  }

  Widget _chatCard(ChatConversationModel conversation) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatDetailScreen(
              conversationId: conversation.id,
              inquiryId: conversation.inquiryId,
              currentUserId:
              (context.read<AuthProvider>().userId?.toString() ??
                  conversation.farmerId),
              otherUserId: conversation.buyerId,
              otherUserName: conversation.buyerName,
              cropName: conversation.cropName,
              cropImageUrl: conversation.cropImage,
            ),
          ),
        );

        if (!mounted) return;

        context.read<ChatProvider>().fetchConversations(showLoading: false);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: conversation.hasUnreadMessages
                ? lightGreen
                : (isDark ? Colors.white10 : Colors.grey.shade200),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.18)
                  : Colors.black.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: isDark
                  ? Colors.white12
                  : const Color(0xffDFF4E4),
              child: Text(
                _getInitials(conversation.buyerName),
                style: const TextStyle(
                  color: darkGreen,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.buyerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: conversation.hasUnreadMessages
                          ? FontWeight.w900
                          : FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.eco_outlined,
                        color: lightGreen,
                        size: 17,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          conversation.cropName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: lightGreen,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    conversation.displayLastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                      fontWeight: conversation.hasUnreadMessages
                          ? FontWeight.w800
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatConversationTime(conversation.displayTime),
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.grey.shade600,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                if (conversation.hasUnreadMessages)
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: lightGreen,
                    child: Text(
                      conversation.unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 26),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorState(String message) {
    return RefreshIndicator(
      color: darkGreen,
      onRefresh: () {
        return context.read<ChatProvider>().fetchConversations();
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 100),
          const Icon(Icons.error_outline, size: 58, color: Colors.red),
          const SizedBox(height: 14),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 18),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<ChatProvider>().fetchConversations();
              },
              icon: const Icon(Icons.refresh),
              label: Text(context.watch<LanguageProvider>().t("retry")),
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 100),
        const Icon(Icons.chat_bubble_outline, size: 62, color: darkGreen),
        const SizedBox(height: 16),
        Text(
          lang.t("noChatsFound"),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? Colors.white60 : Colors.grey.shade600,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          lang.t("acceptedInquiriesChatSubtitle"),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? Colors.white38 : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  String _filterLabel(String filter, LanguageProvider lang) {
    switch (filter) {
      case "All":
        return lang.t("all");
      case "Unread":
        return lang.t("unread");
      case "Active":
        return lang.t("active");
      case "Closed":
        return lang.t("closed");
      default:
        return filter;
    }
  }

  String _getInitials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r"\s+"))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return "B";

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  String _formatConversationTime(DateTime? time) {
    if (time == null) return "";

    final localTime = time.toLocal();
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final messageDay = DateTime(localTime.year, localTime.month, localTime.day);

    final difference = today.difference(messageDay).inDays;

    if (difference == 0) {
      final hour = localTime.hour == 0
          ? 12
          : (localTime.hour > 12 ? localTime.hour - 12 : localTime.hour);

      final minute = localTime.minute.toString().padLeft(2, "0");

      final period = localTime.hour >= 12 ? "PM" : "AM";

      return "$hour:$minute $period";
    }

    if (difference == 1) {
      return "Yesterday";
    }

    final day = localTime.day.toString().padLeft(2, "0");

    final month = localTime.month.toString().padLeft(2, "0");

    return "$day/$month/${localTime.year}";
  }
}
