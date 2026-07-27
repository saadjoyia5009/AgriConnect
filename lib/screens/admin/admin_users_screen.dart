import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/responsive/responsive_layout.dart';
import '../../models/admin_user_model.dart';
import '../../providers/admin_users_provider.dart';
import '../../providers/language_provider.dart';
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
  static const Color lightGreen = Color(0xFF9FF2C1);

  bool get isDark {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color get accentColor {
    return isDark ? lightGreen : darkGreen;
  }

  Color get primaryText {
    return isDark ? Colors.white : const Color(0xFF123524);
  }

  Color get secondaryText {
    return isDark ? Colors.white70 : Colors.grey.shade700;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<AdminUsersProvider>().fetchUsers();
    });
  }

  Future<void> _toggleUserStatus(
      AdminUsersProvider provider,
      AdminUserModel user,
      ) async {
    final wasActive = user.isActive;

    final success = await provider.toggleUserStatus(user.id);

    if (!mounted) return;

    if (success) {
      _showMessage(
        wasActive
            ? "${user.name} suspended successfully."
            : "${user.name} activated successfully.",
        backgroundColor: wasActive
            ? Colors.orange
            : Colors.green,
      );
    } else {
      _showMessage(
        provider.errorMessage ??
            "Unable to update user status.",
        backgroundColor: Colors.red,
      );
    }
  }

  void _showMessage(
      String message, {
        required Color backgroundColor,
      }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark
          ? darkBackground
          : lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? darkCard : darkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context
              .watch<LanguageProvider>()
              .t("userManagement"),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: ResponsiveLayout(
        child: SafeArea(
          top: false,
          child: Consumer<AdminUsersProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading &&
                  provider.users.isEmpty) {
                return const AdminUserShimmer();
              }

              if (provider.errorMessage != null &&
                  provider.users.isEmpty) {
                return _errorState(provider);
              }

              return Column(
                children: [
                  _searchAndFilters(provider),
                  Expanded(
                    child: RefreshIndicator(
                      color: accentColor,
                      backgroundColor: isDark
                          ? darkCard
                          : Colors.white,
                      onRefresh: provider.refreshUsers,
                      child: provider.users.isEmpty
                          ? _emptyState()
                          : _usersList(provider),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _usersList(AdminUsersProvider provider) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(
        20,
        4,
        20,
        24,
      ),
      itemCount: provider.users.length,
      itemBuilder: (context, index) {
        final user = provider.users[index];

        return AdminUserCard(
          user: user,
          index: index,
          isProcessing: provider.isUpdatingUser(user.id),
          onToggleStatus: () {
            _toggleUserStatus(
              provider,
              user,
            );
          },
        );
      },
    );
  }

  Widget _emptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.15,
        ),
        Icon(
          Icons.person_search_rounded,
          size: 72,
          color: isDark ? Colors.white38 : darkGreen,
        ),
        const SizedBox(height: 18),
        Text(
          context
              .watch<LanguageProvider>()
              .t("noUsersFound"),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: primaryText,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Try changing the search or selected filter.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _errorState(AdminUsersProvider provider) {
    return RefreshIndicator(
      color: accentColor,
      backgroundColor: isDark
          ? darkCard
          : Colors.white,
      onRefresh: provider.refreshUsers,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.18,
          ),
          Icon(
            Icons.cloud_off_rounded,
            size: 72,
            color: isDark ? Colors.white38 : darkGreen,
          ),
          const SizedBox(height: 18),
          Text(
            "Unable to load users",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            provider.errorMessage ??
                "Something went wrong.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: secondaryText,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              onPressed: provider.isLoading
                  ? null
                  : provider.fetchUsers,
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: provider.isLoading
                  ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Icon(Icons.refresh_rounded),
              label: const Text(
                "Retry",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchAndFilters(
      AdminUsersProvider provider,
      ) {
    final filters = [
      "All",
      "Farmer",
      "Buyer",
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        14,
      ),
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
              hintText: context
                  .watch<LanguageProvider>()
                  .t("searchUsers"),
              hintStyle: TextStyle(
                color: isDark
                    ? Colors.white38
                    : Colors.grey.shade500,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: isDark
                    ? Colors.white60
                    : Colors.grey.shade600,
              ),
              suffixIcon: provider.isLoading
                  ? const Padding(
                padding: EdgeInsets.all(14),
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    color: darkGreen,
                    strokeWidth: 2,
                  ),
                ),
              )
                  : null,
              filled: true,
              fillColor: isDark
                  ? darkCard
                  : Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: isDark
                      ? Colors.white10
                      : Colors.transparent,
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

          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 8.0;

              final itemWidth =
                  (constraints.maxWidth -
                      (spacing * (filters.length - 1))) /
                      filters.length;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: filters.map((filter) {
                  final selected =
                      provider.selectedFilter == filter;

                  return SizedBox(
                    width: itemWidth,
                    child: GestureDetector(
                      onTap: provider.isLoading
                          ? null
                          : () {
                        provider.changeFilter(filter);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 250,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? isDark
                              ? darkGreen.withOpacity(0.45)
                              : darkGreen
                              : isDark
                              ? darkCard
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected
                                ? accentColor
                                : isDark
                                ? Colors.white10
                                : Colors.transparent,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            filter,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: selected
                                  ? isDark
                                  ? lightGreen
                                  : Colors.white
                                  : secondaryText,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}