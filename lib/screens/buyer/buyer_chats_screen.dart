import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chat_conversation_model.dart';
import '../../providers/buyer_chat_provider.dart';
import '../chat/chat_detail_screen.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/buyer/buyer_bottom_navbar.dart';
import '../../widgets/buyer/buyer_app_bar.dart';

class BuyerChatsScreen extends StatefulWidget {
  const BuyerChatsScreen({super.key});

  @override
  State<BuyerChatsScreen> createState() => _BuyerChatsScreenState();
}

class _BuyerChatsScreenState extends State<BuyerChatsScreen> {
  static const Color primaryGreen = Color(0xFF0B6B45);
  static const Color lightBackground = Color(0xFFF5F9F6);

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context.read<BuyerChatProvider>().fetchBuyerConversations();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshChats() async {
    await context.read<BuyerChatProvider>().fetchBuyerConversations();
  }

  void _openChat(ChatConversationModel conversation) {
    if (conversation.id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<LanguageProvider>().t("conversationIdNotFound"),
          ),
        ),
      );
      return;
    }

    if (!conversation.canChat) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<LanguageProvider>().t("chatAfterAcceptance"),
          ),
        ),
      );
      return;
    }

    final userId = context.read<AuthProvider>().userId;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<LanguageProvider>().t("loginInformationNotFound"),
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatDetailScreen(
          conversationId: conversation.id,
          inquiryId: conversation.inquiryId,
          currentUserId: userId.toString(),
          otherUserId: conversation.farmerId,
          otherUserName: conversation.farmerName,
          cropName: conversation.cropName,
          cropImageUrl: conversation.cropImage,
        ),
      ),
    ).then((_) {
      if (!mounted) return;
      context.read<BuyerChatProvider>().fetchBuyerConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      bottomNavigationBar: BuyerBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          debugPrint("Chats Screen -> $index");

          if (index == 2) return;

          final routes = {
            0: '/buyerDashboard',
            1: '/buyerFavorites',
            2: '/buyerChats',
            3: '/buyer-inquiries',
            4: '/buyerProfile',
          };

          final route = routes[index];
          if (route != null) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
      ),
      appBar: BuyerAppBar(title: context.watch<LanguageProvider>().t("chats")),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchField(),
            Expanded(
              child: Consumer<BuyerChatProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading && provider.conversations.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(color: primaryGreen),
                    );
                  }

                  if (provider.errorMessage != null &&
                      provider.conversations.isEmpty) {
                    return _buildErrorState(provider.errorMessage!);
                  }

                  final conversations = provider.filteredConversations;

                  if (conversations.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    color: primaryGreen,
                    onRefresh: _refreshChats,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: conversations.length,
                      separatorBuilder: (_, __) {
                        return const SizedBox(height: 12);
                      },
                      itemBuilder: (context, index) {
                        final conversation = conversations[index];

                        return _buildConversationCard(conversation);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          context.read<BuyerChatProvider>().search(value);
        },
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: context.watch<LanguageProvider>().t("searchFarmerCrop"),
          prefixIcon: const Icon(Icons.search, color: primaryGreen),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            onPressed: () {
              _searchController.clear();

              context.read<BuyerChatProvider>().search("");

              setState(() {});
            },
            icon: const Icon(Icons.close),
          )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFDCE8E1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: primaryGreen, width: 1.4),
          ),
        ),
      ),
    );
  }

  Widget _buildConversationCard(ChatConversationModel conversation) {
    final hasUnread = conversation.unreadCount > 0;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _openChat(conversation),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: hasUnread
                  ? primaryGreen.withOpacity(0.35)
                  : const Color(0xFFE0E9E4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildCropImage(conversation),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.farmerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: hasUnread
                                  ? FontWeight.w900
                                  : FontWeight.w800,
                              color: const Color(0xFF1E2B24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTime(conversation.lastMessageTime),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: hasUnread
                                ? FontWeight.w800
                                : FontWeight.w500,
                            color: hasUnread
                                ? primaryGreen
                                : const Color(0xFF7D8982),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.agriculture_outlined,
                          size: 15,
                          color: primaryGreen,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            conversation.cropName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: primaryGreen,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.lastMessage.isEmpty
                                ? context.watch<LanguageProvider>().t(
                              "startConversation",
                            )
                                : conversation.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: hasUnread
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              color: hasUnread
                                  ? const Color(0xFF28352E)
                                  : const Color(0xFF748078),
                            ),
                          ),
                        ),
                        if (hasUnread) ...[
                          const SizedBox(width: 10),
                          Container(
                            constraints: const BoxConstraints(
                              minWidth: 23,
                              minHeight: 23,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: primaryGreen,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              conversation.unreadCount > 99
                                  ? "99+"
                                  : conversation.unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: Color(0xFF9AA69F)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCropImage(ChatConversationModel conversation) {
    final image = conversation.cropImage.trim();

    if (image.isEmpty) {
      return Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: const Color(0xFFE4F2E9),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.eco_outlined, color: primaryGreen, size: 29),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        image,
        width: 58,
        height: 58,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 58,
            height: 58,
            color: const Color(0xFFE4F2E9),
            alignment: Alignment.center,
            child: const Icon(
              Icons.eco_outlined,
              color: primaryGreen,
              size: 29,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      color: primaryGreen,
      onRefresh: _refreshChats,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        children: [
          const SizedBox(height: 140),
          const Icon(Icons.forum_outlined, size: 65, color: primaryGreen),
          const SizedBox(height: 18),
          Text(
            context.watch<LanguageProvider>().t("noActiveChats"),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: primaryGreen,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            context.watch<LanguageProvider>().t("buyerChatEmptySubtitle"),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF69756E),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return RefreshIndicator(
      color: primaryGreen,
      onRefresh: _refreshChats,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        children: [
          const SizedBox(height: 130),
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 58),
          const SizedBox(height: 18),
          Text(
            context.watch<LanguageProvider>().t("unableLoadChats"),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: primaryGreen,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF69756E), height: 1.5),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: _refreshChats,
              icon: const Icon(Icons.refresh),
              label: Text(context.watch<LanguageProvider>().t("retry")),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) {
      return "";
    }

    final localTime = dateTime.toLocal();
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final messageDate = DateTime(
      localTime.year,
      localTime.month,
      localTime.day,
    );

    final daysDifference = today.difference(messageDate).inDays;

    if (daysDifference == 0) {
      final hour = localTime.hour == 0
          ? 12
          : localTime.hour > 12
          ? localTime.hour - 12
          : localTime.hour;

      final minute = localTime.minute.toString().padLeft(2, "0");

      final period = localTime.hour >= 12 ? "PM" : "AM";

      return "$hour:$minute $period";
    }

    if (daysDifference == 1) {
      return "Yesterday";
    }

    if (daysDifference < 7) {
      const weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

      return weekDays[localTime.weekday - 1];
    }

    return "${localTime.day}/${localTime.month}/${localTime.year}";
  }
}
