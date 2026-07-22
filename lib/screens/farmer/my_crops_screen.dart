import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/responsive/responsive_layout.dart';
import '../../providers/crop_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/crop_card.dart';
import '../../widgets/farmer_bottom_navbar.dart';

class MyCropsScreen extends StatefulWidget {
  const MyCropsScreen({super.key});

  @override
  State<MyCropsScreen> createState() {
    return _MyCropsScreenState();
  }
}

class _MyCropsScreenState extends State<MyCropsScreen> {
  static const Color darkGreen = Color(0xff075739);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<CropProvider>().fetchCrops();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cropProvider = context.watch<CropProvider>();
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar:
      const FarmerBottomNavbar(currentIndex: 1),
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, '/addCrop');
        },
        child: const Icon(Icons.add),
      ),
      body: ResponsiveLayout(
        child: SafeArea(
          child: Column(
            children: [
              _topBar(context),
              Expanded(
                child: RefreshIndicator(
                  color: darkGreen,
                  onRefresh: cropProvider.fetchCrops,
                  child: SingleChildScrollView(
                    physics:
                    const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      18,
                      20,
                      18,
                      90,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.t("myCrops"),
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.color,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _filterChip(
                              context,
                              title: "All",
                              displayTitle: lang.t("all"),
                              count: cropProvider.allCount,
                              selected:
                              cropProvider.selectedFilter ==
                                  "All",
                            ),
                            _filterChip(
                              context,
                              title: "Active",
                              displayTitle: lang.t("active"),
                              count: cropProvider.activeCount,
                              selected:
                              cropProvider.selectedFilter ==
                                  "Active",
                            ),
                            _filterChip(
                              context,
                              title: "Sold Out",
                              displayTitle:
                              lang.t("soldOut"),
                              count:
                              cropProvider.soldOutCount,
                              selected:
                              cropProvider.selectedFilter ==
                                  "Sold Out",
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        _buildCropContent(
                          context,
                          cropProvider,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCropContent(
      BuildContext context,
      CropProvider cropProvider,
      ) {
    if (
    cropProvider.isLoading &&
        cropProvider.allCrops.isEmpty
    ) {
      return const SizedBox(
        height: 300,
        child: Center(
          child: CircularProgressIndicator(
            color: darkGreen,
          ),
        ),
      );
    }

    if (
    cropProvider.errorMessage != null &&
        cropProvider.allCrops.isEmpty
    ) {
      return _errorState(
        context,
        cropProvider,
      );
    }

    if (cropProvider.crops.isEmpty) {
      return _emptyState(context);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cropCards = List.generate(
          cropProvider.crops.length,
              (index) {
            final crop = cropProvider.crops[index];

            return MyCropCard(
              crop: crop,
              onEdit: () async {
                await Navigator.pushNamed(
                  context,
                  '/editCrop',
                  arguments: crop,
                );

                if (!mounted) return;

                cropProvider.fetchCrops();
              },
              onDelete: () {
                _confirmDelete(
                  context,
                  cropProvider,
                  crop.id,
                  crop.name,
                );
              },
            );
          },
        );

        // Mobile par natural-height cards.
        if (constraints.maxWidth < 600) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: cropCards,
          );
        }

        // Tablet aur desktop par responsive grid.
        return ResponsiveGrid(
          mobileColumns: 1,
          tabletColumns: 2,
          desktopColumns: 3,
          wideDesktopColumns: 4,
          childAspectRatio: 0.90,
          children: cropCards,
        );
      },
    );
  }

  Widget _errorState(
      BuildContext context,
      CropProvider cropProvider,
      ) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 55,
          ),
          const SizedBox(height: 14),
          Text(
            cropProvider.errorMessage ??
                "Unable to load crops.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: cropProvider.fetchCrops,
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
            style: ElevatedButton.styleFrom(
              backgroundColor: darkGreen,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.grass_outlined,
            size: 65,
            color: darkGreen,
          ),
          const SizedBox(height: 14),
          Text(
            "No ${lang.tDynamic(
              context.read<CropProvider>().selectedFilter,
            )} crops found",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.color,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            "Add a crop or select another filter.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context,
      CropProvider cropProvider,
      String cropId,
      String cropName,
      ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Delete Crop",
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            "Are you sure you want to delete $cropName?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) return;

    final success = await cropProvider.deleteCrop(
      cropId,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Crop deleted successfully."
              : cropProvider.errorMessage ??
              "Unable to delete crop.",
        ),
        backgroundColor:
        success ? darkGreen : Colors.red,
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white12
                : const Color(0xffe4eee8),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.agriculture_outlined,
            color: isDark ? Colors.white : darkGreen,
            size: 22,
          ),
          Expanded(
            child: Center(
              child: Text(
                lang.t("appName"),
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color:
                  isDark ? Colors.white : darkGreen,
                ),
              ),
            ),
          ),
          const SizedBox(width: 22),
        ],
      ),
    );
  }

  Widget _filterChip(
      BuildContext context, {
        required String title,
        required String displayTitle,
        required int count,
        required bool selected,
      }) {
    final cropProvider =
    context.read<CropProvider>();

    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        cropProvider.changeFilter(title);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? darkGreen
              : (
              isDark
                  ? Theme.of(context).cardColor
                  : Colors.white
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected
                ? darkGreen
                : (
                isDark
                    ? Colors.white12
                    : const Color(0xffcfe5d8)
            ),
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.035,
                ),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
          ],
        ),
        child: Text(
          "$displayTitle ($count)",
          style: TextStyle(
            color: selected
                ? Colors.white
                : (
                isDark
                    ? Colors.white
                    : darkGreen
            ),
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}