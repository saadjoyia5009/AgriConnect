import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/buyer_inquiry_model.dart';
import '../../providers/chat_provider.dart';
import '../../providers/language_provider.dart';

class BuyerFarmerChatScreen extends StatefulWidget {
  final BuyerInquiryModel inquiry;

  const BuyerFarmerChatScreen({
    super.key,
    required this.inquiry,
  });

  @override
  State<BuyerFarmerChatScreen> createState() {
    return _BuyerFarmerChatScreenState();
  }
}

class _BuyerFarmerChatScreenState
    extends State<BuyerFarmerChatScreen> {
  final TextEditingController _messageController =
  TextEditingController();

  final ScrollController _scrollController =
  ScrollController();

  static const Color darkGreen = Color(0xff0F5C3A);
  static const Color lightBackground = Color(0xffF8FAF7);
  static const Color darkBackground = Color(0xFF0B1410);
  static const Color darkCard = Color(0xFF15251E);
  static const Color lightGreen = Color(0xff9ff2c1);

  bool get isDark {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color get accentColor {
    return isDark ? lightGreen : darkGreen;
  }

  Color get primaryText {
    return isDark
        ? Colors.white
        : const Color(0xff10291D);
  }

  Color get secondaryText {
    return isDark
        ? Colors.white70
        : const Color(0xff5F675F);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _initializeChat();
    });
  }

  Future<void> _initializeChat() async {
    final provider = context.read<ChatProvider>();

    await provider.initializeChat(
      inquiryId: widget.inquiry.id,
      conversationId: widget.inquiry.conversationId,
    );

    if (!mounted) return;

    _scrollToBottom();
  }

  Future<void> _refreshMessages() async {
    await context.read<ChatProvider>().fetchMessages(
      conversationId: widget.inquiry.conversationId,
      showLoading: false,
    );

    if (!mounted) return;

    _scrollToBottom();
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();

    if (message.isEmpty) return;

    FocusScope.of(context).unfocus();

    final provider = context.read<ChatProvider>();

    final success = await provider.sendMessage(
      message: message,
    );

    if (!mounted) return;

    if (success) {
      _messageController.clear();
      _scrollToBottom();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          provider.errorMessage ?? "Failed to send message.",
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
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
    final inquiry = widget.inquiry;
    final lang = context.watch<LanguageProvider>();

    return Directionality(
      textDirection:
      lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor:
        isDark ? darkBackground : lightBackground,
        appBar: _appBar(inquiry),
        body: Column(
          children: [
            _inquirySummary(inquiry),
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, provider, _) {
                  return _chatContent(provider);
                },
              ),
            ),
            _messageInput(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(
      BuyerInquiryModel inquiry,
      ) {
    final farmerName = inquiry.farmerName.trim().isNotEmpty
        ? inquiry.farmerName.trim()
        : "Farmer";

    return AppBar(
      backgroundColor: isDark ? darkCard : Colors.white,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: accentColor,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: isDark
                ? darkGreen.withValues(alpha: 0.25)
                : const Color(0xffEAF7EF),
            child: Text(
              _getInitials(farmerName),
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  farmerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  inquiry.cropName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: "Refresh messages",
            onPressed: _refreshMessages,
            icon: Icon(
              Icons.refresh,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatContent(ChatProvider provider) {
    if (provider.isLoading && provider.messages.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          color: accentColor,
        ),
      );
    }

    if (
    provider.errorMessage != null &&
        provider.messages.isEmpty
    ) {
      return _errorState(provider.errorMessage!);
    }

    if (provider.messages.isEmpty) {
      return RefreshIndicator(
        color: accentColor,
        onRefresh: _refreshMessages,
        child: ListView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.16,
            ),
            Icon(
              Icons.chat_bubble_outline,
              size: 58,
              color: accentColor,
            ),
            const SizedBox(height: 14),
            Text(
              "No messages yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryText,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              "Send a message to start the conversation.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: secondaryText,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: accentColor,
      onRefresh: _refreshMessages,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: provider.messages.length,
        itemBuilder: (context, index) {
          final message = provider.messages[index];

          final isMe =
              message.senderId == widget.inquiry.buyerId;

          return _messageBubble(
            text: message.message,
            isMe: isMe,
            time: _formatTime(message.createdAt),
          );
        },
      ),
    );
  }

  Widget _errorState(String message) {
    return RefreshIndicator(
      color: accentColor,
      onRefresh: _refreshMessages,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.13,
          ),
          Icon(
            Icons.error_outline,
            size: 58,
            color: isDark
                ? Colors.red.shade200
                : Colors.red,
          ),
          const SizedBox(height: 14),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondaryText,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: ElevatedButton.icon(
              onPressed: _initializeChat,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
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

  Widget _inquirySummary(
      BuyerInquiryModel inquiry,
      ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? darkCard
            : const Color(0xffEAF7EF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white10
              : const Color(0xffDCE7DD),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              inquiry.imageUrl,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 52,
                  height: 52,
                  color: isDark
                      ? const Color(0xff1E1E1E)
                      : Colors.white,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: isDark
                        ? Colors.white60
                        : Colors.grey,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  inquiry.cropName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Qty: ${inquiry.displayQuantity}",
                  style: TextStyle(
                    fontSize: 12,
                    color: secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatOffer(inquiry),
                  style: TextStyle(
                    fontSize: 12,
                    color: accentColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          _acceptedChip(),
        ],
      ),
    );
  }

  Widget _acceptedChip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? darkGreen.withValues(alpha: 0.30)
            : const Color(0xffD4F0DC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "Accepted",
        style: TextStyle(
          color: accentColor,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _messageBubble({
    required String text,
    required bool isMe,
    required String time,
  }) {
    return Align(
      alignment: isMe
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.76,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? darkGreen
              : (isDark ? darkCard : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          border: isMe
              ? null
              : Border.all(
            color: isDark
                ? Colors.white10
                : const Color(0xffDCE7DD),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : primaryText,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              time,
              style: TextStyle(
                color: isMe
                    ? Colors.white70
                    : (
                    isDark
                        ? Colors.white54
                        : const Color(0xff7A837C)
                ),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageInput() {
    return Consumer<ChatProvider>(
      builder: (context, provider, _) {
        final chatReady =
            provider.conversationId?.isNotEmpty ?? false;

        return Container(
          padding: EdgeInsets.fromLTRB(
            12,
            10,
            12,
            14 + MediaQuery.paddingOf(context).bottom,
          ),
          decoration: BoxDecoration(
            color: isDark ? darkCard : Colors.white,
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.white10
                    : const Color(0xffDCE7DD),
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  minLines: 1,
                  maxLines: 4,
                  maxLength: 5000,
                  enabled: chatReady && !provider.isLoading,
                  textInputAction: TextInputAction.newline,
                  style: TextStyle(
                    color: primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                  cursorColor: accentColor,
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: chatReady
                        ? context
                        .watch<LanguageProvider>()
                        .t("typeMessage")
                        : "Loading chat...",
                    hintStyle: TextStyle(
                      color: isDark
                          ? Colors.white38
                          : Colors.grey,
                    ),
                    filled: true,
                    fillColor: isDark
                        ? const Color(0xff1E1E1E)
                        : lightBackground,
                    contentPadding:
                    const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: _messageBorder(),
                    enabledBorder: _messageBorder(),
                    focusedBorder: _messageBorder(
                      color: accentColor,
                      width: 1.2,
                    ),
                    disabledBorder: _messageBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 48,
                height: 48,
                child: provider.isSending
                    ? Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: accentColor,
                      strokeWidth: 2.5,
                    ),
                  ),
                )
                    : IconButton.filled(
                  onPressed: chatReady
                      ? _sendMessage
                      : null,
                  style: IconButton.styleFrom(
                    backgroundColor: darkGreen,
                    disabledBackgroundColor:
                    Colors.grey.shade400,
                  ),
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  OutlineInputBorder _messageBorder({
    Color? color,
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(22),
      borderSide: BorderSide(
        color: color ??
            (
                isDark
                    ? Colors.white12
                    : const Color(0xffDCE7DD)
            ),
        width: width,
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r"\s+"))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return "F";

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return (
        parts.first[0] + parts.last[0]
    ).toUpperCase();
  }

  String _formatOffer(BuyerInquiryModel inquiry) {
    if (inquiry.cropUnit.trim().isEmpty) {
      return "Offer: Rs. ${inquiry.offerPrice}";
    }

    return "Offer: Rs. ${inquiry.offerPrice} / "
        "${inquiry.cropUnit}";
  }

  String _formatTime(DateTime dateTime) {
    final localTime = dateTime.toLocal();
    final hour = localTime.hour.toString().padLeft(2, "0");
    final minute =
    localTime.minute.toString().padLeft(2, "0");

    return "$hour:$minute";
  }
}