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
  static const Color darkGreen = Color(0xff075739);
  static const Color lightGreen = Color(0xff159447);
  static const Color softGreen = Color(0xffe4f5e9);
  static const Color pageBackground = Color(0xfff7faf8);

  final TextEditingController _searchController =
  TextEditingController();

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

  // ================================================================
  // EXISTING FILTER LOGIC — UNCHANGED
  // ================================================================

  List<ChatConversationModel> _filteredChats(
      List<ChatConversationModel> conversations,
      ) {
    final query = _searchController.text.trim().toLowerCase();

    return conversations.where((conversation) {
      if (!conversation.canChat ||
          conversation.id.trim().isEmpty) {
        return false;
      }

      final matchesSearch =
          conversation.buyerName.toLowerCase().contains(query) ||
              conversation.cropName
                  .toLowerCase()
                  .contains(query) ||
              conversation.displayLastMessage
                  .toLowerCase()
                  .contains(query);

      bool matchesFilter;

      switch (_selectedFilter) {
        case "Unread":
          matchesFilter =
              conversation.unreadCount > 0;
          break;

        case "Active":
          matchesFilter =
              conversation.inquiryStatus
                  .toLowerCase() ==
                  "accepted";
          break;

        case "Closed":
          final status =
          conversation.inquiryStatus.toLowerCase();

          matchesFilter =
              status == "completed" ||
                  status == "rejected";
          break;

        default:
          matchesFilter = true;
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    final lang =
    context.watch<LanguageProvider>();

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Directionality(
      textDirection:
      lang.isUrdu
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: isDark
            ? const Color(0xff121814)
            : pageBackground,

        // EXISTING BOTTOM NAV — UNCHANGED
        bottomNavigationBar:
        const FarmerBottomNavbar(
          currentIndex: 2,
        ),

        body: SafeArea(
          top: false,
          child: Column(
            children: [
              _premiumHeader(context),

              Expanded(
                child: Column(
                  children: [
                    _searchBox(),

                    const SizedBox(height: 8),

                    _filterChips(),

                    const SizedBox(height: 10),

                    Expanded(
                      child: Consumer<ChatProvider>(
                        builder:
                            (
                            context,
                            provider,
                            _,
                            ) {
                          return _buildContent(
                            provider,
                          );
                        },
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

  // ================================================================
  // PREMIUM HEADER
  // ================================================================

  Widget _premiumHeader(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Container(
      width: double.infinity,
      height: 120,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xff075739),
            Color(0xff0b704a),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // ----------------------------------------------------------
          // LEFT DECORATIVE BUBBLE
          // ----------------------------------------------------------

          Positioned(
            left: -45,
            top: -45,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(
                  alpha: 0.035,
                ),
              ),
            ),
          ),

          // ----------------------------------------------------------
          // RIGHT DECORATIVE BUBBLE
          // ----------------------------------------------------------

          Positioned(
            right: -45,
            bottom: -65,
            child: Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(
                  alpha: 0.035,
                ),
              ),
            ),
          ),

          // ----------------------------------------------------------
          // HEADER CONTENT
          // ----------------------------------------------------------

          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              30,
              20,
              10,
            ),
            child: Row(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.13,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(
                        alpha: 0.08,
                      ),
                    ),
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),

                // Center title
                Expanded(
                  child: Center(
                    child: Text(
                      lang.t("chats"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.6,
                      ),
                    ),
                  ),
                ),

                // Refresh button
                Consumer<ChatProvider>(
                  builder: (
                      context,
                      provider,
                      _,
                      ) {
                    if (provider.isConversationLoading) {
                      return Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.13,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: 0.08,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.all(13),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      );
                    }

                    return GestureDetector(
                      onTap: provider.fetchConversations,
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.13,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: 0.08,
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerIcon({
    required IconData icon,
  }) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.14,
        ),
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.10,
          ),
        ),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 26,
      ),
    );
  }

  // ================================================================
  // SEARCH
  // ================================================================

  Widget _searchBox() {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final lang =
    context.watch<LanguageProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        24,
        20,
        7,
      ),
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xff1d251f)
              : Colors.white,

          // More rounded / pill shape
          borderRadius: BorderRadius.circular(100),

          border: Border.all(
            color: isDark
                ? Colors.white10
                : const Color(0xffe1e9e4),
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.045,
              ),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: TextField(
          controller: _searchController,

          onChanged: (_) {
            setState(() {});
          },

          style: TextStyle(
            color: isDark
                ? Colors.white
                : const Color(0xff202723),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),

          decoration: InputDecoration(
            hintText: lang.t(
              "searchBuyerCrop",
            ),

            hintStyle: TextStyle(
              color: isDark
                  ? Colors.white54
                  : const Color(0xff9ca5a0),
              fontSize: 15,
              fontWeight: FontWeight.w500,

            ),

            prefixIcon: const Padding(
              padding: EdgeInsets.only(
                left: 18,
                right: 8,
              ),
              child: Icon(
                Icons.search_rounded,
                color: Color(0xff222a26),
                size: 27,
              ),
            ),

            suffixIcon:
            _searchController.text.isEmpty
                ? Container(
              margin: const EdgeInsets.all(
                7,
              ),
              width: 42,
              decoration: BoxDecoration(
                color: const Color(
                  0xfff1f8f3,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: darkGreen,
                size: 21,
              ),
            )
                : IconButton(
              onPressed: () {
                _searchController.clear();
                setState(() {});
              },
              icon: const Icon(
                Icons.close_rounded,
              ),
            ),

            border: InputBorder.none,

            contentPadding:
            const EdgeInsets.symmetric(
              vertical: 17,
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // FILTER CHIPS
  // ================================================================

  Widget _filterChips() {
    const filters = [
      "All",
      "Unread",
      "Active",
      "Closed",
    ];

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final lang =
    context.watch<LanguageProvider>();

    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        scrollDirection:
        Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) {
          return const SizedBox(
            width: 12,
          );
        },
        itemBuilder:
            (context, index) {
          final filter =
          filters[index];

          final isSelected =
              _selectedFilter ==
                  filter;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter =
                    filter;
              });
            },
            child: AnimatedContainer(
              duration:
              const Duration(
                milliseconds: 180,
              ),
              padding:
              const EdgeInsets
                  .symmetric(
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? darkGreen
                    : (isDark
                    ? const Color(
                  0xff1d251f,
                )
                    : Colors.white),
                borderRadius:
                BorderRadius.circular(
                  30,
                ),
                border: Border.all(
                  color: isSelected
                      ? darkGreen
                      : (isDark
                      ? Colors.white10
                      : const Color(
                    0xffe1e9e4,
                  )),
                ),
                boxShadow:
                isSelected
                    ? [
                  BoxShadow(
                    color:
                    darkGreen
                        .withValues(
                      alpha:
                      0.16,
                    ),
                    blurRadius:
                    10,
                    offset:
                    const Offset(
                      0,
                      5,
                    ),
                  ),
                ]
                    : null,
              ),
              child: Row(
                mainAxisSize:
                MainAxisSize.min,
                children: [
                  Icon(
                    _filterIcon(
                      filter,
                    ),
                    size: 15,
                    color: isSelected
                        ? Colors.white
                        : darkGreen,
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  Text(
                    _filterLabel(
                      filter,
                      lang,
                    ),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark
                          ? Colors.white
                          : darkGreen),
                      fontSize: 14,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _filterIcon(
      String filter,
      ) {
    switch (filter) {
      case "Unread":
        return Icons
            .mark_email_unread_outlined;

      case "Active":
        return Icons.eco_outlined;

      case "Closed":
        return Icons
            .inventory_2_outlined;

      default:
        return Icons
            .chat_bubble_outline_rounded;
    }
  }

  // ================================================================
  // CONTENT — LOGIC UNCHANGED
  // ================================================================

  Widget _buildContent(
      ChatProvider provider,
      ) {
    if (provider.isConversationLoading &&
        provider.conversations.isEmpty) {
      return const Center(
        child:
        CircularProgressIndicator(
          color: darkGreen,
        ),
      );
    }

    if (provider
        .conversationErrorMessage !=
        null &&
        provider.conversations.isEmpty) {
      return _errorState(
        provider
            .conversationErrorMessage!,
      );
    }

    final chats =
    _filteredChats(
      provider.conversations,
    );

    return RefreshIndicator(
      color: darkGreen,
      onRefresh:
      provider.fetchConversations,
      child: chats.isEmpty
          ? _emptyState()
          : ListView.separated(
        physics:
        const AlwaysScrollableScrollPhysics(),
        padding:
        const EdgeInsets.fromLTRB(
          20,
          7,
          20,
          25,
        ),
        itemCount:
        chats.length,
        separatorBuilder:
            (_, __) {
          return const SizedBox(
            height: 14,
          );
        },
        itemBuilder:
            (context, index) {
          return _chatCard(
            chats[index],
          );
        },
      ),
    );
  }

  // ================================================================
  // PREMIUM CHAT CARD
  // ================================================================

  Widget _chatCard(
      ChatConversationModel conversation,
      ) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return InkWell(
      borderRadius:
      BorderRadius.circular(26),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ChatDetailScreen(
                  conversationId:
                  conversation.id,
                  inquiryId:
                  conversation.inquiryId,
                  currentUserId:
                  (context
                      .read<AuthProvider>()
                      .userId
                      ?.toString() ??
                      conversation
                          .farmerId),
                  otherUserId:
                  conversation.buyerId,
                  otherUserName:
                  conversation.buyerName,
                  cropName:
                  conversation.cropName,
                  cropImageUrl:
                  conversation.cropImage,
                ),
          ),
        );

        if (!mounted) return;

        context
            .read<ChatProvider>()
            .fetchConversations(
          showLoading: false,
        );
      },
      child: Container(
        constraints:
        const BoxConstraints(
          minHeight: 100,
        ),
        padding:
        const EdgeInsets.fromLTRB(
          14,
          16,
          14,
          16,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xff1d251f)
              : Colors.white,
          borderRadius:
          BorderRadius.circular(26),
          border: Border.all(
            color: conversation
                .hasUnreadMessages
                ? const Color(
              0xffc8e6d1,
            )
                : (isDark
                ? Colors.white10
                : const Color(
              0xffe1e9e4,
            )),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.055,
              ),
              blurRadius: 20,
              offset:
              const Offset(0, 9),
            ),
          ],
        ),
        child: Row(
          children: [
            // --------------------------------------------------------
            // AVATAR
            // --------------------------------------------------------

            Stack(
              clipBehavior:
              Clip.none,
              children: [
                Container(
                  height: 74,
                  width: 74,
                  decoration:
                  const BoxDecoration(
                    color:
                    Color(0xffe0f4e6),
                    shape:
                    BoxShape.circle,
                  ),
                  alignment:
                  Alignment.center,
                  child: Text(
                    _getInitials(
                      conversation
                          .buyerName,
                    ),
                    style:
                    const TextStyle(
                      color: darkGreen,
                      fontSize: 25,
                      fontWeight:
                      FontWeight.w900,
                    ),
                  ),
                ),

                if (conversation
                    .hasUnreadMessages)
                  Positioned(
                    right: -1,
                    bottom: 1,
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration:
                      BoxDecoration(
                        color:
                        const Color(
                          0xff18a34a,
                        ),
                        shape:
                        BoxShape.circle,
                        border:
                        Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(
              width: 16,
            ),

            // --------------------------------------------------------
            // MAIN INFO
            // --------------------------------------------------------

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Text(
                    conversation
                        .buyerName,
                    maxLines: 1,
                    overflow:
                    TextOverflow
                        .ellipsis,
                    style: TextStyle(
                      color: isDark
                          ? Colors.white
                          : const Color(
                        0xff171d19,
                      ),
                      fontWeight:
                      conversation
                          .hasUnreadMessages
                          ? FontWeight
                          .w900
                          : FontWeight
                          .w800,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Row(
                    children: [
                      const Icon(
                        Icons.eco_rounded,
                        color:
                        lightGreen,
                        size: 18,
                      ),

                      const SizedBox(
                        width: 6,
                      ),

                      Expanded(
                        child: Text(
                          conversation
                              .cropName,
                          maxLines: 1,
                          overflow:
                          TextOverflow
                              .ellipsis,
                          style:
                          const TextStyle(
                            color:
                            lightGreen,
                            fontWeight:
                            FontWeight
                                .w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    conversation
                        .displayLastMessage,
                    maxLines: 1,
                    overflow:
                    TextOverflow
                        .ellipsis,
                    style: TextStyle(
                      color: isDark
                          ? Colors.white60
                          : const Color(
                        0xff6e7772,
                      ),
                      fontSize: 14,
                      fontWeight:
                      conversation
                          .hasUnreadMessages
                          ? FontWeight
                          .w700
                          : FontWeight
                          .w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              width: 8,
            ),

            // --------------------------------------------------------
            // TIME + UNREAD
            // --------------------------------------------------------

            Column(
              crossAxisAlignment:
              CrossAxisAlignment.end,
              children: [
                Text(
                  _formatConversationTime(
                    conversation
                        .displayTime,
                  ),
                  style: TextStyle(
                    color: isDark
                        ? Colors.white60
                        : const Color(
                      0xff747c77,
                    ),
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height: 13,
                ),

                if (conversation
                    .hasUnreadMessages)
                  Container(
                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration:
                    BoxDecoration(
                      color:
                      softGreen,
                      borderRadius:
                      BorderRadius
                          .circular(
                        20,
                      ),
                    ),
                    child: Text(
                      "New",
                      style:
                      const TextStyle(
                        color:
                        darkGreen,
                        fontSize: 11,
                        fontWeight:
                        FontWeight.w900,
                      ),
                    ),
                  )
                else
                  const Icon(
                    Icons
                        .chevron_right_rounded,
                    color:
                    Color(0xff7b837e),
                    size: 27,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // ERROR STATE
  // ================================================================

  Widget _errorState(
      String message,
      ) {
    return RefreshIndicator(
      color: darkGreen,
      onRefresh: () {
        return context
            .read<ChatProvider>()
            .fetchConversations();
      },
      child: ListView(
        physics:
        const AlwaysScrollableScrollPhysics(),
        padding:
        const EdgeInsets.all(24),
        children: [
          const SizedBox(
            height: 100,
          ),

          Container(
            height: 80,
            width: 80,
            margin:
            const EdgeInsets
                .symmetric(
              horizontal: 120,
            ),
            decoration:
            const BoxDecoration(
              color: Color(0xffffeeee),
              shape: BoxShape.circle,
            ),
            child:
            const Icon(
              Icons.error_outline_rounded,
              size: 42,
              color: Colors.red,
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          Text(
            message,
            textAlign:
            TextAlign.center,
            style:
            const TextStyle(
              fontSize: 14,
              fontWeight:
              FontWeight.w600,
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          Center(
            child:
            ElevatedButton.icon(
              onPressed: () {
                context
                    .read<
                    ChatProvider>()
                    .fetchConversations();
              },
              icon:
              const Icon(
                Icons.refresh_rounded,
              ),
              label: Text(
                context
                    .watch<
                    LanguageProvider>()
                    .t("retry"),
              ),
              style:
              ElevatedButton
                  .styleFrom(
                backgroundColor:
                darkGreen,
                foregroundColor:
                Colors.white,
                elevation: 0,
                padding:
                const EdgeInsets
                    .symmetric(
                  horizontal: 22,
                  vertical: 13,
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    25,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // EMPTY STATE
  // ================================================================

  Widget _emptyState() {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final lang =
    context.watch<LanguageProvider>();

    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(),
      padding:
      const EdgeInsets.all(24),
      children: [
        const SizedBox(
          height: 90,
        ),

        Container(
          height: 100,
          width: 100,
          margin:
          const EdgeInsets
              .symmetric(
            horizontal: 115,
          ),
          decoration:
          const BoxDecoration(
            color: Color(0xffe5f5e9),
            shape: BoxShape.circle,
          ),
          child:
          const Icon(
            Icons
                .chat_bubble_outline_rounded,
            size: 46,
            color: darkGreen,
          ),
        ),

        const SizedBox(
          height: 20,
        ),

        Text(
          lang.t("noChatsFound"),
          textAlign:
          TextAlign.center,
          style: TextStyle(
            color: isDark
                ? Colors.white
                : const Color(
              0xff222a26,
            ),
            fontWeight:
            FontWeight.w800,
            fontSize: 18,
          ),
        ),

        const SizedBox(
          height: 8,
        ),

        Text(
          lang.t(
            "acceptedInquiriesChatSubtitle",
          ),
          textAlign:
          TextAlign.center,
          style: TextStyle(
            color: isDark
                ? Colors.white38
                : const Color(
              0xff7b837e,
            ),
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // ================================================================
  // TRANSLATION
  // ================================================================

  String _filterLabel(
      String filter,
      LanguageProvider lang,
      ) {
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

  // ================================================================
  // EXISTING INITIALS LOGIC — UNCHANGED
  // ================================================================

  String _getInitials(
      String name,
      ) {
    final parts = name
        .trim()
        .split(RegExp(r"\s+"))
        .where(
          (part) => part.isNotEmpty,
    )
        .toList();

    if (parts.isEmpty) return "B";

    if (parts.length == 1) {
      return parts.first[0]
          .toUpperCase();
    }

    return (parts.first[0] +
        parts.last[0])
        .toUpperCase();
  }

  // ================================================================
  // EXISTING TIME LOGIC — UNCHANGED
  // ================================================================

  String _formatConversationTime(
      DateTime? time,
      ) {
    if (time == null) return "";

    final localTime =
    time.toLocal();

    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final messageDay = DateTime(
      localTime.year,
      localTime.month,
      localTime.day,
    );

    final difference =
        today.difference(
          messageDay,
        ).inDays;

    if (difference == 0) {
      final hour =
      localTime.hour == 0
          ? 12
          : (localTime.hour > 12
          ? localTime.hour - 12
          : localTime.hour);

      final minute =
      localTime.minute
          .toString()
          .padLeft(2, "0");

      final period =
      localTime.hour >= 12
          ? "PM"
          : "AM";

      return "$hour:$minute $period";
    }

    if (difference == 1) {
      return "Yesterday";
    }

    final day = localTime.day
        .toString()
        .padLeft(2, "0");

    final month = localTime.month
        .toString()
        .padLeft(2, "0");

    return "$day/$month/${localTime.year}";
  }
}