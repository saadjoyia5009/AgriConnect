import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chat_conversation_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/voice_assistant_provider.dart';
import '../../widgets/farmer_bottom_navbar.dart';
import '../../widgets/farmer_chats/farmer_chat_card.dart';
import '../../widgets/farmer_chats/farmer_chats_empty_state.dart';
import '../../widgets/farmer_chats/farmer_chats_error_state.dart';
import '../../widgets/farmer_chats/farmer_chats_filter_chips.dart';
import '../../widgets/farmer_chats/farmer_chats_header.dart';
import '../../widgets/farmer_chats/farmer_chats_search.dart';
import '../chat/chat_detail_screen.dart';

class FarmerChatsScreen extends StatefulWidget {
  const FarmerChatsScreen({super.key});

  @override
  State<FarmerChatsScreen> createState() => _FarmerChatsScreenState();
}

class _FarmerChatsScreenState extends State<FarmerChatsScreen> {
  static const Color darkGreen = Color(0xff075739);
  static const Color pageBackground = Color(0xfff7faf8);

  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  bool _openedByVoiceAssistant = false;
  bool _unreadAnnouncementHandled = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final arguments = ModalRoute.of(context)?.settings.arguments;

      if (arguments is Map) {
        _openedByVoiceAssistant =
            arguments['openedByVoiceAssistant'] == true;
      }

      context.read<ChatProvider>().fetchConversations().then((_) {
        if (!mounted) return;

        if (_openedByVoiceAssistant && !_unreadAnnouncementHandled) {
          _unreadAnnouncementHandled = true;

          _announceUnreadMessages(
            context.read<ChatProvider>().conversations,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _announceUnreadMessages(
      List<ChatConversationModel> conversations,
      ) async {
    final unreadConversations = conversations
        .where(
          (conversation) => conversation.unreadCount > 0,
    )
        .toList();

    if (unreadConversations.isEmpty) {
      return;
    }

    final languageProvider = context.read<LanguageProvider>();
    final voiceProvider = context.read<VoiceAssistantProvider>();

    final isUrdu = languageProvider.isUrdu;
    String message;

    if (unreadConversations.length == 1) {
      final conversation = unreadConversations.first;
      final name = conversation.buyerName.trim();
      final count = conversation.unreadCount;

      if (isUrdu) {
        message = count == 1
            ? '$name ka 1 unread message hai.'
            : '$name ke $count unread messages hain.';
      } else {
        message = count == 1
            ? 'You have 1 unread message from $name.'
            : 'You have $count unread messages from $name.';
      }
    } else {
      final names = unreadConversations
          .map(
            (conversation) => conversation.buyerName.trim(),
      )
          .where((name) => name.isNotEmpty)
          .toList();

      final totalUnread = unreadConversations.fold<int>(
        0,
            (total, conversation) => total + conversation.unreadCount,
      );

      if (isUrdu) {
        message =
        'Aap ke ${names.length} buyers ke $totalUnread unread messages hain.';
      } else {
        message =
        'You have $totalUnread unread messages from ${names.length} buyers.';
      }
    }

    debugPrint('VOICE UNREAD ANNOUNCEMENT: $message');

    await voiceProvider.speakMessage(
      message,
      language: isUrdu ? 'ur' : 'en',
    );
  }

  List<ChatConversationModel> _filteredChats(
      List<ChatConversationModel> conversations,
      ) {
    final query = _searchController.text.trim().toLowerCase();

    return conversations.where((conversation) {
      if (!conversation.canChat || conversation.id.trim().isEmpty) return false;

      final matchesSearch =
          conversation.buyerName.toLowerCase().contains(query) ||
              conversation.cropName.toLowerCase().contains(query) ||
              conversation.displayLastMessage.toLowerCase().contains(query);

      final status = conversation.inquiryStatus.toLowerCase();
      final matchesFilter = switch (_selectedFilter) {
        'Unread' => conversation.unreadCount > 0,
        'Active' => status == 'accepted',
        'Closed' => status == 'completed' || status == 'rejected',
        _ => true,
      };

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xff121814) : pageBackground,
        bottomNavigationBar: const FarmerBottomNavbar(currentIndex: 2),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              FarmerChatsHeader(
                title: lang.t('chats'),
                isLoading: context.watch<ChatProvider>().isConversationLoading,
                onRefresh: () => context.read<ChatProvider>().fetchConversations(),
              ),
              Expanded(
                child: Column(
                  children: [
                    FarmerChatsSearch(
                      controller: _searchController,
                      hintText: lang.t('searchBuyerCrop'),
                      onChanged: () => setState(() {}),
                    ),
                    const SizedBox(height: 8),
                    FarmerChatsFilterChips(
                      selectedFilter: _selectedFilter,
                      onFilterChanged: (filter) {
                        setState(() => _selectedFilter = filter);
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Consumer<ChatProvider>(
                        builder: (context, provider, _) => _buildContent(provider),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ChatProvider provider) {
    if (provider.isConversationLoading && provider.conversations.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: darkGreen),
      );
    }

    if (provider.conversationErrorMessage != null &&
        provider.conversations.isEmpty) {
      return FarmerChatsErrorState(
        message: provider.conversationErrorMessage!,
        onRetry: provider.fetchConversations,
      );
    }

    final chats = _filteredChats(provider.conversations);

    return RefreshIndicator(
      color: darkGreen,
      onRefresh: provider.fetchConversations,
      child: chats.isEmpty
          ? const FarmerChatsEmptyState()
          : ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 7, 20, 25),
        itemCount: chats.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final conversation = chats[index];
          return FarmerChatCard(
            conversation: conversation,
            onTap: () => _openChat(conversation),
          );
        },
      ),
    );
  }

  Future<void> _openChat(ChatConversationModel conversation) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatDetailScreen(
          conversationId: conversation.id,
          inquiryId: conversation.inquiryId,
          currentUserId:
          context.read<AuthProvider>().userId?.toString() ?? conversation.farmerId,
          otherUserId: conversation.buyerId,
          otherUserName: conversation.buyerName,
          cropName: conversation.cropName,
          cropImageUrl: conversation.cropImage,
        ),
      ),
    );

    if (!mounted) return;
    context.read<ChatProvider>().fetchConversations(showLoading: false);
  }
}