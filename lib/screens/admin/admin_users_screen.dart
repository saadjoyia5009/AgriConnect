import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_users_provider.dart';
import '../../widgets/admin/admin_user_card.dart';
import '../../widgets/admin/admin_user_shimmer.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  static const Color darkGreen = Color(0xFF0E5A3C);
  static const Color lightBackground = Color(0xFFF4F8F5);
  static const Color darkBackground = Color(0xFF0B1410);
  static const Color darkCard = Color(0xFF15251E);
  static const Color lightGreen = Color(0xff9ff2c1);

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get accentColor => isDark ? lightGreen : darkGreen;
  Color get primaryText => isDark ? Colors.white : const Color(0xFF123524);
  Color get secondaryText => isDark ? Colors.white70 : Colors.grey.shade700;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AdminUsersProvider>().fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? darkBackground : lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? darkCard : darkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "User Management",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: Consumer<AdminUsersProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const AdminUserShimmer();
          }

          return Column(
            children: [
              _searchAndFilters(provider),
              Expanded(
                child: provider.users.isEmpty
                    ? Center(
                  child: Text(
                    "No users found",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: primaryText,
                    ),
                  ),
                )
                    : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  itemCount: provider.users.length,
                  itemBuilder: (context, index) {
                    final user = provider.users[index];

                    return AdminUserCard(
                      user: user,
                      index: index,
                      onToggleStatus: () {
                        provider.toggleUserStatus(user.id);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _searchAndFilters(AdminUsersProvider provider) {
    final filters = ["All", "Farmer", "Buyer"];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      child: Column(
        children: [
          TextField(
            onChanged: provider.updateSearch,
            style: TextStyle(
              color: primaryText,
              fontWeight: FontWeight.w600,
            ),
            cursorColor: accentColor,
            decoration: InputDecoration(
              hintText: "Search users...",
              hintStyle: TextStyle(
                color: isDark ? Colors.white38 : Colors.grey.shade500,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: isDark ? Colors.white60 : Colors.grey.shade600,
              ),
              filled: true,
              fillColor: isDark ? darkCard : Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: isDark ? Colors.white10 : Colors.transparent,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: accentColor,
                  width: 1.3,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: filters.map((filter) {
              final selected = provider.selectedFilter == filter;

              return Expanded(
                child: GestureDetector(
                  onTap: () => provider.changeFilter(filter),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selected
                          ? (isDark ? darkGreen.withOpacity(0.45) : darkGreen)
                          : (isDark ? darkCard : Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected
                            ? accentColor
                            : (isDark ? Colors.white10 : Colors.transparent),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        filter,
                        style: TextStyle(
                          color: selected
                              ? (isDark ? lightGreen : Colors.white)
                              : secondaryText,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}