import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_provider.dart';

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
  final TextEditingController _messageController =
  TextEditingController();

  final ScrollController _scrollController =
  ScrollController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await context.read<ChatProvider>().fetchMessages(
        conversationId: widget.chatId,
      );

      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();

    if (message.isEmpty) return;

    final success =
    await context.read<ChatProvider>().sendMessage(
      message: message,
    );

    if (success) {
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF0B6B45);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F6),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        title: Text(widget.receiverName),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading &&
                      provider.messages.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (provider.errorMessage != null &&
                      provider.messages.isEmpty) {
                    return Center(
                      child: Text(
                        provider.errorMessage!,
                      ),
                    );
                  }

                  if (provider.messages.isEmpty) {
                    return const Center(
                      child: Text(
                        "No messages yet",
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.messages.length,
                    itemBuilder: (context, index) {
                      final message =
                      provider.messages[index];

                      final isMe =
                          message.senderId ==
                              widget.currentUserId;

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          constraints:
                          const BoxConstraints(
                            maxWidth: 280,
                          ),
                          margin:
                          const EdgeInsets.only(
                            bottom: 10,
                          ),
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? primaryGreen
                                : Colors.white,
                            borderRadius:
                            BorderRadius.circular(16),
                          ),
                          child: Text(
                            message.message,
                            style: TextStyle(
                              color: isMe
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            _buildMessageInput(primaryGreen),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(Color primaryGreen) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        12,
        10,
        12,
        12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Color(0x14000000),
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              minLines: 1,
              maxLines: 4,
              textInputAction:
              TextInputAction.newline,
              decoration: InputDecoration(
                hintText: "Write a message...",
                filled: true,
                fillColor:
                const Color(0xFFF1F5F2),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Consumer<ChatProvider>(
            builder: (context, provider, child) {
              return IconButton(
                onPressed:
                provider.isSending
                    ? null
                    : _sendMessage,
                icon: provider.isSending
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(Icons.send),
                color: primaryGreen,
              );
            },
          ),
        ],
      ),
    );
  }
}