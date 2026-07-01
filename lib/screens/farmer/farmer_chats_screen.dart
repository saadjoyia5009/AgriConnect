import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';
import 'chat_detail_screen.dart';
import '../../widgets/farmer_bottom_navbar.dart';

class FarmerChatsScreen extends StatefulWidget {
  const FarmerChatsScreen({super.key});

  @override
  State<FarmerChatsScreen> createState() => _FarmerChatsScreenState();
}

class _FarmerChatsScreenState extends State<FarmerChatsScreen> {
  static const Color darkGreen = Color(0xff0F5C3A);
  static const Color lightGreen = Color(0xff0F8A3B);

  final TextEditingController _searchController = TextEditingController();

  String selectedFilter = "All";

  final List<Map<String, dynamic>> chats = [
    {
      "chatId": "chat_1",
      "buyerId": "buyer_1",
      "buyerName": "Ali Khan",
      "cropName": "Organic Asparagus",
      "cropIcon": "🌿",
      "lastMessage": "Hello, is this crop available?",
      "time": "10:30 AM",
      "unread": 2,
      "status": "Unread",
    },
    {
      "chatId": "chat_2",
      "buyerId": "buyer_2",
      "buyerName": "M. Rizwan",
      "cropName": "Premium Blueberries",
      "cropIcon": "🫐",
      "lastMessage": "Price final kar len?",
      "time": "Yesterday",
      "unread": 1,
      "status": "Unread",
    },
    {
      "chatId": "chat_3",
      "buyerId": "buyer_3",
      "buyerName": "Sara Johnson",
      "cropName": "Fresh Strawberries",
      "cropIcon": "🍓",
      "lastMessage": "Kitni quantity available hai?",
      "time": "Yesterday",
      "unread": 0,
      "status": "Active",
    },
    {
      "chatId": "chat_4",
      "buyerId": "buyer_4",
      "buyerName": "Ahmed Hassan",
      "cropName": "Organic Asparagus",
      "cropIcon": "🌱",
      "lastMessage": "Delivery kab tak ho sakti hai?",
      "time": "25 May",
      "unread": 1,
      "status": "Unread",
    },
  ];

  List<Map<String, dynamic>> get filteredChats {
    final query = _searchController.text.toLowerCase();

    return chats.where((chat) {
      final matchesSearch =
          chat["buyerName"].toString().toLowerCase().contains(query) ||
          chat["cropName"].toString().toLowerCase().contains(query);

      final matchesFilter = selectedFilter == "All"
          ? true
          : selectedFilter == "Unread"
          ? chat["unread"] > 0
          : chat["status"] == selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = filteredChats;
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
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
          IconButton(
            icon: const Icon(Icons.add_comment_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _searchBox(),
          _filterChips(),
          Expanded(
            child: list.isEmpty
                ? _emptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      return _chatCard(list[index]);
                    },
                  ),
          ),
        ],
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
        onChanged: (_) => setState(() {}),
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
          suffixIcon: Icon(
            Icons.tune,
            color: Theme.of(context).iconTheme.color,
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: BorderSide(
              color: isDark ? Colors.white12 : Colors.grey.shade200,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: BorderSide(
              color: isDark ? Colors.white12 : Colors.grey.shade200,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: const BorderSide(color: darkGreen),
          ),
        ),
      ),
    );
  }

  Widget _filterChips() {
    final filters = ["All", "Unread", "Active", "Closed"];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return SizedBox(
      height: 54,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return ChoiceChip(
            label: Text(
              _filterLabel(filter, lang),
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : isDark
                    ? Colors.white
                    : Colors.black,
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
                selectedFilter = filter;
              });
            },
          );
        },
      ),
    );
  }

  Widget _chatCard(Map<String, dynamic> chat) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initials = _getInitials(chat["buyerName"]);
    final lang = context.watch<LanguageProvider>();

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatDetailScreen(
              chatId: chat["chatId"],
              currentUserId: "farmer_1",
              receiverId: chat["buyerId"],
              receiverName: chat["buyerName"],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.18)
                  : Colors.black.withOpacity(0.06),
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
                initials,
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
                    chat["buyerName"],
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(chat["cropIcon"]),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          chat["cropName"],
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
                    _chatPreview(chat["lastMessage"], lang),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
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
                  _chatTime(chat["time"], lang),
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                if (chat["unread"] > 0)
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: lightGreen,
                    child: Text(
                      chat["unread"].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return Center(
      child: Text(
        lang.t("noChatsFound"),
        style: TextStyle(
          color: isDark ? Colors.white60 : Colors.grey.shade600,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
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

  String _chatTime(String value, LanguageProvider lang) {
    return value == "Yesterday" ? lang.t("yesterday") : value;
  }

  String _chatPreview(String value, LanguageProvider lang) {
    switch (value) {
      case "Hello, is this crop available?":
        return lang.t("chatSampleAvailable");
      case "Price final kar len?":
        return lang.t("chatSamplePriceFinal");
      case "Kitni quantity available hai?":
        return lang.t("chatSampleQuantity");
      case "Delivery kab tak ho sakti hai?":
        return lang.t("chatSampleDelivery");
      default:
        return value;
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(" ");

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return "${parts.first[0]}${parts.last[0]}".toUpperCase();
  }
}
