import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/buyer_inquiry_model.dart';
import '../../providers/chat_provider.dart';

class BuyerFarmerChatScreen extends StatefulWidget {
  final BuyerInquiryModel inquiry;

  const BuyerFarmerChatScreen({
    super.key,
    required this.inquiry,
  });

  @override
  State<BuyerFarmerChatScreen> createState() => _BuyerFarmerChatScreenState();
}

class _BuyerFarmerChatScreenState extends State<BuyerFarmerChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  String get chatId => "${widget.inquiry.buyerId}_${widget.inquiry.farmerId}_${widget.inquiry.cropId}";

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ChatProvider>().fetchMessages(chatId: chatId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _messageController.clear();

    await context.read<ChatProvider>().sendMessage(
      chatId: chatId,
      senderId: widget.inquiry.buyerId,
      receiverId: widget.inquiry.farmerId,
      message: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    final inquiry = widget.inquiry;

    return Scaffold(
      backgroundColor: const Color(0xffF8FAF7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff0F5C3A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xffEAF7EF),
              child: Text(
                inquiry.farmerName.isNotEmpty
                    ? inquiry.farmerName[0].toUpperCase()
                    : "F",
                style: const TextStyle(
                  color: Color(0xff0F5C3A),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    inquiry.farmerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xff10291D),
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    inquiry.cropName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xff5F675F),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _inquirySummary(inquiry),
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage != null) {
                  return Center(child: Text(provider.errorMessage!));
                }

                final messages = provider.messages;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == inquiry.buyerId;

                    return _messageBubble(
                      text: message.message,
                      isMe: isMe,
                      time: _formatTime(message.createdAt),
                    );
                  },
                );
              },
            ),
          ),
          _messageInput(),
        ],
      ),
    );
  }

  Widget _inquirySummary(BuyerInquiryModel inquiry) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffEAF7EF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffDCE7DD)),
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
                  color: Colors.white,
                  child: const Icon(Icons.image_not_supported_outlined),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inquiry.cropName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xff10291D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Qty: ${inquiry.quantity} • Offer: ${inquiry.offerPrice}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff5F675F),
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

  Widget _messageBubble({
    required String text,
    required bool isMe,
    required String time,
  }) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xff0F5C3A) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          border: isMe ? null : Border.all(color: const Color(0xffDCE7DD)),
        ),
        child: Column(
          crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : const Color(0xff10291D),
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              time,
              style: TextStyle(
                color: isMe ? Colors.white70 : const Color(0xff7A837C),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Type your message...",
                filled: true,
                fillColor: const Color(0xffF8FAF7),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: Color(0xffDCE7DD)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: Color(0xffDCE7DD)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xff0F5C3A),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }
}