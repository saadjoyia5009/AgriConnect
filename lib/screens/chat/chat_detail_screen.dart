import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_provider.dart';
import '../../providers/language_provider.dart';

class ChatDetailScreen extends StatefulWidget {
  final String conversationId;
  final String? inquiryId;
  final String currentUserId;
  final String otherUserName;
  final String? otherUserId;
  final String? cropName;
  final String? cropImageUrl;
  final String? quantity;
  final String? offeredPrice;
  final String? cropUnit;
  final String? status;

  const ChatDetailScreen({
    super.key,
    required this.conversationId,
    required this.currentUserId,
    required this.otherUserName,
    this.inquiryId,
    this.otherUserId,
    this.cropName,
    this.cropImageUrl,
    this.quantity,
    this.offeredPrice,
    this.cropUnit,
    this.status,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  static const Color primaryGreen = Color(0xFF0B6B45);
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadChat());
  }

  Future<void> _loadChat() async {
    if (!mounted) return;
    final provider = context.read<ChatProvider>();
    final conversationId = widget.conversationId.trim();
    final inquiryId = widget.inquiryId?.trim() ?? '';

    if (conversationId.isNotEmpty) {
      await provider.fetchMessages(conversationId: conversationId);
    } else if (inquiryId.isNotEmpty) {
      await provider.createConversationAndFetchMessages(inquiryId: inquiryId);
    } else {
      return;
    }
    if (mounted) _scrollToBottom();
  }

  Future<void> _refreshMessages() async {
    await context.read<ChatProvider>().refreshMessages();
    if (mounted) _scrollToBottom();
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;
    FocusScope.of(context).unfocus();
    final success = await context.read<ChatProvider>().sendMessage(
      message: message,
    );
    if (!mounted) return;
    if (success) {
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Directionality(
      textDirection: lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          title: Text(
            widget.otherUserName.trim().isEmpty
                ? lang.t('chatTitle')
                : widget.otherUserName,
          ),
          actions: [
            IconButton(
              onPressed: _refreshMessages,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              if (_hasSummary) _buildInquirySummary(isDark),
              Expanded(child: _buildMessages(isDark)),
              _buildMessageInput(isDark),
            ],
          ),
        ),
      ),
    );
  }

  bool get _hasSummary =>
      (widget.cropName?.trim().isNotEmpty ?? false) ||
      (widget.quantity?.trim().isNotEmpty ?? false) ||
      (widget.offeredPrice?.trim().isNotEmpty ?? false);

  Widget _buildInquirySummary(bool isDark) {
    final quantity = widget.quantity?.trim() ?? '';
    final unit = widget.cropUnit?.trim() ?? '';
    final details = <String>[
      if (quantity.isNotEmpty) '$quantity${unit.isEmpty ? '' : ' $unit'}',
      if (widget.offeredPrice?.trim().isNotEmpty ?? false)
        'Rs. ${widget.offeredPrice!.trim()}',
      if (widget.status?.trim().isNotEmpty ?? false) widget.status!.trim(),
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      color: isDark ? Theme.of(context).cardColor : const Color(0xFFE8F4ED),
      child: Row(
        children: [
          const Icon(Icons.eco_outlined, color: primaryGreen),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.cropName?.trim().isNotEmpty ?? false)
                  Text(
                    widget.cropName!,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                if (details.isNotEmpty)
                  Text(
                    details.join(' • '),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages(bool isDark) {
    return Consumer<ChatProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.messages.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: primaryGreen),
          );
        }
        if (provider.errorMessage != null && provider.messages.isEmpty) {
          return _StateMessage(
            icon: Icons.error_outline,
            message: provider.errorMessage!,
            actionLabel: context.read<LanguageProvider>().t('retry'),
            onAction: _loadChat,
          );
        }
        if (provider.messages.isEmpty) {
          return _StateMessage(
            icon: Icons.chat_bubble_outline,
            message: context.read<LanguageProvider>().t('noMessagesYet'),
          );
        }
        return RefreshIndicator(
          color: primaryGreen,
          onRefresh: _refreshMessages,
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: provider.messages.length,
            itemBuilder: (context, index) {
              final message = provider.messages[index];
              final isMe =
                  message.senderId.toString() ==
                  widget.currentUserId.toString();
              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * .76,
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? primaryGreen : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(color: isMe ? Colors.white : null),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMessageInput(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: context.watch<LanguageProvider>().t('writeMessage'),
                filled: true,
                fillColor: isDark ? Colors.white10 : const Color(0xFFF1F5F2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Consumer<ChatProvider>(
            builder: (context, provider, _) {
              return IconButton(
                onPressed: provider.isSending ? null : _sendMessage,
                color: primaryGreen,
                icon: provider.isSending
                    ? const SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StateMessage extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _StateMessage({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: primaryGreen),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            if (onAction != null) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: onAction,
                child: Text(
                  actionLabel ?? context.watch<LanguageProvider>().t('retry'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static const primaryGreen = Color(0xFF0B6B45);
}
