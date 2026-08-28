import 'package:flutter/material.dart';

import '../../models/chat_conversation_model.dart';

class FarmerChatCard extends StatelessWidget {
  final ChatConversationModel conversation;
  final VoidCallback onTap;

  const FarmerChatCard({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  static const Color darkGreen = Color(0xff075739);
  static const Color lightGreen = Color(0xff159447);
  static const Color softGreen = Color(0xffe4f5e9);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 100),
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff1d251f) : Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: conversation.hasUnreadMessages
                ? const Color(0xffc8e6d1)
                : (isDark ? Colors.white10 : const Color(0xffe1e9e4)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.055),
              blurRadius: 20,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 74,
                  width: 74,
                  decoration: const BoxDecoration(
                    color: Color(0xffe0f4e6),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _initials(conversation.buyerName),
                    style: const TextStyle(
                      color: darkGreen,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                if (conversation.hasUnreadMessages)
                  Positioned(
                    right: -1,
                    bottom: 1,
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xff18a34a),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.buyerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xff171d19),
                      fontWeight: conversation.hasUnreadMessages
                          ? FontWeight.w900
                          : FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.eco_rounded, color: lightGreen, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          conversation.cropName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: lightGreen,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    conversation.displayLastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white60 : const Color(0xff6e7772),
                      fontSize: 14,
                      fontWeight: conversation.hasUnreadMessages
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTime(conversation.displayTime),
                  style: TextStyle(
                    color: isDark ? Colors.white60 : const Color(0xff747c77),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 13),
                if (conversation.hasUnreadMessages)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                    decoration: BoxDecoration(
                      color: softGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'New',
                      style: TextStyle(
                        color: darkGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  )
                else
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xff7b837e),
                    size: 27,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return 'B';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';

    final local = time.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(local.year, local.month, local.day);
    final difference = today.difference(messageDay).inDays;

    if (difference == 0) {
      final hour = local.hour == 0 ? 12 : (local.hour > 12 ? local.hour - 12 : local.hour);
      final minute = local.minute.toString().padLeft(2, '0');
      final period = local.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    }

    if (difference == 1) return 'Yesterday';

    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    return '$day/$month/${local.year}';
  }
}
