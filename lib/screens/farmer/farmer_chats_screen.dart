import 'package:flutter/material.dart';

import 'chat_detail_screen.dart';
import '../../widgets/farmer_bottom_navbar.dart';

class FarmerChatsScreen extends StatefulWidget {
  const FarmerChatsScreen({super.key});

  @override
  State<FarmerChatsScreen> createState() => _FarmerChatsScreenState();
}

class _FarmerChatsScreenState extends State<FarmerChatsScreen> {
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

    return Scaffold(
      bottomNavigationBar: const FarmerBottomNavbar(currentIndex: 3),
      backgroundColor: const Color(0xffF6FAF7),
      appBar: AppBar(
        backgroundColor: const Color(0xff0F5C3A),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Buyer Chats",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: "Search buyer or crop...",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: const Icon(Icons.tune),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: const BorderSide(color: Color(0xff0F5C3A)),
          ),
        ),
      ),
    );
  }

  Widget _filterChips() {
    final filters = ["All", "Unread", "Active", "Closed"];

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
              filter,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
            selected: isSelected,
            selectedColor: const Color(0xff0F8A3B),
            backgroundColor: Colors.white,
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: Colors.grey.shade200),
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
    final initials = _getInitials(chat["buyerName"]);

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
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xffDFF4E4),
              child: Text(
                initials,
                style: const TextStyle(
                  color: Color(0xff0F5C3A),
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
                    style: const TextStyle(
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
                            color: Color(0xff0F8A3B),
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    chat["lastMessage"],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade600,
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
                  chat["time"],
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                if (chat["unread"] > 0)
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: const Color(0xff0F8A3B),
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
    return Center(
      child: Text(
        "No chats found",
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w700,
          fontSize: 16,
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
}