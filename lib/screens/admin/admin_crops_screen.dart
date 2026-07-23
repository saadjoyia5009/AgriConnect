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
  State<AdminCropsScreen> createState() => _AdminCropsScreenState();
}

class _AdminCropsScreenState extends State<AdminCropsScreen> {
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
      context.read<AdminCropsProvider>().fetchCrops();
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
        title: Text(
          context.watch<LanguageProvider>().t("cropManagement"),
          style: TextStyle(fontWeight: FontWeight.w900),
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
                  child: provider.crops.isEmpty
                      ? Center(
                          child: Text(
                            context.watch<LanguageProvider>().t("noCropsFound"),
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: primaryText,
                            ),
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                          itemCount: provider.crops.length,
                          itemBuilder: (context, index) {
                            final crop = provider.crops[index];

                            return AdminCropCard(
                              crop: crop,
                              index: index,
                              onToggleStatus: () {
                                provider.toggleCropStatus(crop.id);
                              },
                              onDelete: () {
                                _confirmDelete(context, provider, crop.id);
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _searchAndFilters(AdminCropsProvider provider) {
    final filters = ["All", "Active", "Inactive", "Reported"];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      child: Column(
        children: [
          TextField(
            onChanged: provider.updateSearch,
            style: TextStyle(color: primaryText, fontWeight: FontWeight.w600),
            cursorColor: accentColor,
            decoration: InputDecoration(
              hintText: context.watch<LanguageProvider>().t("searchCrops"),
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
                borderSide: BorderSide(color: accentColor, width: 1.3),
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
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final filter = filters[index];
                final selected = provider.selectedFilter == filter;

                return GestureDetector(
                  onTap: () => provider.changeFilter(filter),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    AdminCropsProvider provider,
    String id,
  ) {
    showDialog(
      context: context,
      builder: (_) {
        final dialogIsDark = Theme.of(context).brightness == Brightness.dark;

        return AlertDialog(
          scrollable: true,
          backgroundColor: dialogIsDark ? darkCard : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            context.read<LanguageProvider>().t("deleteCropListingQuestion"),
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: dialogIsDark ? Colors.white : const Color(0xFF123524),
            ),
          ),
          content: Text(
            context.read<LanguageProvider>().t("deleteCropAdminWarning"),
            style: TextStyle(
              color: dialogIsDark ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                context.read<LanguageProvider>().t("cancel"),
                style: TextStyle(
                  color: dialogIsDark ? lightGreen : darkGreen,
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
                provider.deleteCrop(id);
                Navigator.pop(context);
              },
              child: Text(context.read<LanguageProvider>().t("delete")),
            ),
          ],
        );
      },
    );
  }
}
