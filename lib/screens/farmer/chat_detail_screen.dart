import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_provider.dart';
import '../../providers/language_provider.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String receiverId;
  final String receiverName;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  static const Color darkGreen = Color(0xff0F5C3A);

  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ChatProvider>().fetchMessages(chatId: widget.chatId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();

    if (text.isEmpty) return;

    context.read<ChatProvider>().sendMessage(
      chatId: widget.chatId,
      senderId: widget.currentUserId,
      receiverId: widget.receiverId,
      message: text,
    );

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: isDark
                  ? Colors.white12
                  : const Color(0xffDFF4E4),
              child: Text(
                _getInitials(widget.receiverName),
                style: const TextStyle(
                  color: darkGreen,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.receiverName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.phone, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: darkGreen),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.messages.length,
                    itemBuilder: (context, index) {
                      final message = provider.messages[index];
                      final isMe = message.senderId == widget.currentUserId;

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
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? isDark
                                      ? const Color(0xff214A36)
                                      : const Color(0xffDDF8D8)
                                : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withOpacity(0.18)
                                    : Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                message.message,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.color,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _formatTime(message.createdAt),
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white60
                                      : Colors.grey.shade600,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          _messageInput(),
        ],
      ),
    );
  }

  Widget _messageInput() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      color: Theme.of(context).cardColor,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.emoji_emotions_outlined,
                color: isDark ? Colors.white70 : Colors.grey.shade600,
              ),
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                minLines: 1,
                maxLines: 4,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                decoration: InputDecoration(
                  hintText: lang.t("typeMessage"),
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey.shade500,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.attach_file,
                color: isDark ? Colors.white70 : Colors.grey.shade600,
              ),
            ),
            CircleAvatar(
              radius: 24,
              backgroundColor: darkGreen,
              child: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send, color: Colors.white, size: 21),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(" ");

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return "${parts.first[0]}${parts.last[0]}".toUpperCase();
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, "0");
    final period = time.hour >= 12 ? "PM" : "AM";

    return "$hour:$minute $period";
  }
}
