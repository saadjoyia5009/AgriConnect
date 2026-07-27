import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/responsive/responsive_layout.dart';
import '../../providers/admin_crops_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/admin/admin_crop_card.dart';
import '../../widgets/admin/admin_crop_shimmer.dart';

class AdminCropsScreen extends StatefulWidget {
  const AdminCropsScreen({super.key});

  @override
  State<AdminCropsScreen> createState() =>
      _AdminCropsScreenState();
}

class _AdminCropsScreenState extends State<AdminCropsScreen> {
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
    return isDark
        ? Colors.white
        : const Color(0xFF123524);
  }

  Color get secondaryText {
    return isDark
        ? Colors.white70
        : Colors.grey.shade700;
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context.read<AdminCropsProvider>().fetchCrops();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      isDark ? darkBackground : lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? darkCard : darkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context
              .watch<LanguageProvider>()
              .t("cropManagement"),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: ResponsiveLayout(
        child: Consumer<AdminCropsProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const AdminCropShimmer();
            }

            return Column(
              children: [
                _searchAndFilters(provider),
                Expanded(
                  child: _content(provider),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _content(AdminCropsProvider provider) {
    if (provider.errorMessage != null &&
        provider.crops.isEmpty) {
      return _errorState(provider);
    }

    if (provider.crops.isEmpty) {
      return _emptyState();
    }

    return RefreshIndicator(
      color: darkGreen,
      onRefresh: provider.refreshCrops,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(
          20,
          4,
          20,
          100,
        ),
        itemCount: provider.crops.length,
        itemBuilder: (context, index) {
          final crop = provider.crops[index];

          return AdminCropCard(
            crop: crop,
            index: index,
            onToggleStatus: () async {
              final success =
              await provider.toggleCropStatus(crop.id);

              if (!mounted) return;

              if (success) {
                _showMessage(
                  crop.status == "Active"
                      ? "Crop moved to draft successfully"
                      : "Crop activated successfully",
                );
              } else {
                _showMessage(
                  provider.errorMessage ??
                      "Unable to update crop status",
                  isError: true,
                );
              }
            },
            onDelete: () {
              _confirmDelete(
                context,
                provider,
                crop.id,
              );
            },
          );
        },
      ),
    );
  }

  Widget _searchAndFilters(
      AdminCropsProvider provider,
      ) {
    final filters = <Map<String, dynamic>>[
      {
        "name": "All",
        "count": provider.allCount,
      },
      {
        "name": "Active",
        "count": provider.activeCount,
      },
      {
        "name": "Sold Out",
        "count": provider.soldOutCount,
      },
      {
        "name": "Draft",
        "count": provider.draftCount,
      },
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
                  .t("searchCrops"),
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
              filled: true,
              fillColor: isDark ? darkCard : Colors.white,
              contentPadding:
              const EdgeInsets.symmetric(
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

          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: filters.length,
              separatorBuilder: (_, __) {
                return const SizedBox(width: 10);
              },
              itemBuilder: (context, index) {
                final filter =
                filters[index]["name"] as String;

                final count =
                filters[index]["count"] as int;

                final selected =
                    provider.selectedFilter == filter;

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      provider.changeFilter(filter);
                    },
                    borderRadius:
                    BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration:
                      const Duration(milliseconds: 250),
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? (isDark
                            ? darkGreen.withOpacity(0.45)
                            : darkGreen)
                            : (isDark
                            ? darkCard
                            : Colors.white),
                        borderRadius:
                        BorderRadius.circular(16),
                        border: Border.all(
                          color: selected
                              ? accentColor
                              : (isDark
                              ? Colors.white10
                              : Colors.transparent),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "$filter ($count)",
                          style: TextStyle(
                            color: selected
                                ? (isDark
                                ? lightGreen
                                : Colors.white)
                                : secondaryText,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.grass_outlined,
              size: 60,
              color: isDark
                  ? Colors.white38
                  : Colors.grey.shade400,
            ),
            const SizedBox(height: 14),
            Text(
              "No crops found in this category",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorState(
      AdminCropsProvider provider,
      ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 60,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 14),
            Text(
              provider.errorMessage ??
                  "Unable to load crops",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryText,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: provider.fetchCrops,
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context,
      AdminCropsProvider provider,
      String id,
      ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final dialogIsDark =
            Theme.of(dialogContext).brightness ==
                Brightness.dark;

        return AlertDialog(
          scrollable: true,
          backgroundColor:
          dialogIsDark ? darkCard : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            context
                .read<LanguageProvider>()
                .t("deleteCropListingQuestion"),
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: dialogIsDark
                  ? Colors.white
                  : const Color(0xFF123524),
            ),
          ),
          content: Text(
            context
                .read<LanguageProvider>()
                .t("deleteCropAdminWarning"),
            style: TextStyle(
              color: dialogIsDark
                  ? Colors.white70
                  : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(
                context
                    .read<LanguageProvider>()
                    .t("cancel"),
                style: TextStyle(
                  color: dialogIsDark
                      ? lightGreen
                      : darkGreen,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(
                context
                    .read<LanguageProvider>()
                    .t("delete"),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    final success = await provider.deleteCrop(id);

    if (!mounted) return;

    if (success) {
      _showMessage(
        "Crop deleted successfully",
      );
    } else {
      _showMessage(
        provider.errorMessage ??
            "Unable to delete crop",
        isError: true,
      );
    }
  }

  void _showMessage(
      String message, {
        bool isError = false,
      }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
          isError ? Colors.redAccent : darkGreen,
        ),
      );
  }
}