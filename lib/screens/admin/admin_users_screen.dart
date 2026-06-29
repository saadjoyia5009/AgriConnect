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
      backgroundColor: const Color(0xFFF4F8F5),
      appBar: AppBar(
        backgroundColor: darkGreen,
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
                    ? const Center(
                  child: Text(
                    "No users found",
                    style: TextStyle(fontWeight: FontWeight.w800),
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
            decoration: InputDecoration(
              hintText: "Search users...",
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
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
                      color: selected ? darkGreen : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        filter,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.grey.shade700,
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