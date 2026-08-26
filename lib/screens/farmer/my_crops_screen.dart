import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/responsive/responsive_layout.dart';
import '../../models/crop_model.dart';
import '../../providers/crop_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/farmer_bottom_navbar.dart';

class MyCropsScreen extends StatefulWidget {
  const MyCropsScreen({super.key});

  @override
  State<MyCropsScreen> createState() => _MyCropsScreenState();
}

class _MyCropsScreenState extends State<MyCropsScreen> {
  static const Color darkGreen = Color(0xff075739);
  static const Color accentGreen = Color(0xff0b704a);

  // Theme-aware colors. Geometry/layout/logic remain unchanged.
  bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  Color _backgroundColor(BuildContext context) =>
      _isDark(context) ? const Color(0xff101713) : const Color(0xfff6faf7);

  Color _cardColor(BuildContext context) =>
      _isDark(context) ? const Color(0xff18221c) : Colors.white;

  Color _primaryText(BuildContext context) =>
      _isDark(context) ? Colors.white : const Color(0xff161d19);

  Color _secondaryText(BuildContext context) =>
      _isDark(context) ? const Color(0xffb8c6bd) : const Color(0xff68736d);

  Color _softGreen(BuildContext context) =>
      _isDark(context) ? const Color(0xff1d3327) : const Color(0xffe4f3e9);

  Color _softChip(BuildContext context) =>
      _isDark(context) ? const Color(0xff202b24) : const Color(0xfff7faf8);

  Color _borderColor(BuildContext context) =>
      _isDark(context) ? Colors.white12 : const Color(0xffdcebe2);

  // Uses the existing LanguageProvider. If an older provider does not yet
  // contain a key, the local English/Urdu fallback keeps this screen usable.
  String _tr(
      LanguageProvider lang,
      String key, {
        required String en,
        required String ur,
      }) {
    final translated = lang.t(key);
    return translated == key ? (lang.isUrdu ? ur : en) : translated;
  }

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

    return Scaffold(
      backgroundColor: _backgroundColor(context),

      // EXISTING NAVBAR — unchanged
      bottomNavigationBar: const FarmerBottomNavbar(
        currentIndex: 1,
      ),

      // EXISTING ADD CROP NAVIGATION — unchanged
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        elevation: 8,
        onPressed: () {
          Navigator.pushNamed(context, '/addCrop');
        },
        child: const Icon(
          Icons.add_rounded,
          size: 30,
        ),
      ),

      body: Directionality(
        textDirection: context.watch<LanguageProvider>().isUrdu
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: ResponsiveLayout(
          child: Column(
            children: [
              _topBar(context),

              Expanded(
                child: RefreshIndicator(
                  color: darkGreen,
                  onRefresh: cropProvider.fetchCrops,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 100,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _heroSection(context),

                        const SizedBox(height: 4),

                        _filterSection(context),

                        const SizedBox(height: 4),

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

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _topBar(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Container(
      height: 120,
      width: double.infinity,
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
          // Left decorative bubble
          Positioned(
            left: -45,
            top: -55,
            child: Container(
              height: 155,
              width: 155,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.035),
              ),
            ),
          ),

          // Right decorative bubble
          Positioned(
            right: -45,
            bottom: -70,
            child: Container(
              height: 165,
              width: 165,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.035),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              30,
              20,
              10,
            ),
            child: Row(
              children: [
                // Agriculture icon
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: const Icon(
                    Icons.agriculture_outlined,
                    color: Colors.white,
                    size: 27,
                  ),
                ),

                // Center title
                Expanded(
                  child: Center(
                    child: Text(
                      lang.t("crops"),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.6,
                      ),
                    ),
                  ),
                ),

                // Balance the left icon
                const SizedBox(
                  width: 48,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HERO
  // ============================================================

  Widget _heroSection(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        25,
        18,
        18,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        lang.t("myCrops"),
                        style: TextStyle(
                          color: _primaryText(context),
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    const Icon(
                      Icons.eco_rounded,
                      color: Color(0xff329a60),
                      size: 19,
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                Text(
                  _tr(
                    lang,
                    "manageCrops",
                    en: "Manage your crops and track their performance",
                    ur: "اپنی فصلوں کا انتظام کریں اور ان کی کارکردگی دیکھیں",
                  ),
                  style: TextStyle(
                    color: _secondaryText(context),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Container(
            height: 82,
            width: 96,
            decoration: BoxDecoration(
              color: _softGreen(context),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  bottom: 8,
                  left: 10,
                  right: 10,
                  child: Container(
                    height: 17,
                    decoration: BoxDecoration(
                      color: const Color(0xffcce8d5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                Image.asset(
                  'assets/images/img_5.png',
                  width: 105,
                  height: 105,
                  fit: BoxFit.contain,
                ),

                const Positioned(
                  top: 9,
                  right: 14,
                  child: Icon(
                    Icons.eco_rounded,
                    color: Color(0xff4ea971),
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FILTERS
  // ============================================================

  Widget _filterSection(BuildContext context) {
    final cropProvider = context.watch<CropProvider>();
    final lang = context.watch<LanguageProvider>();

    return Container(
      margin: const EdgeInsets.fromLTRB(
        18,
        0,
        18,
        18,
      ),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: _borderColor(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _filterChip(
              context,
              title: "All",
              displayTitle: lang.t("all"),
              count: cropProvider.allCount,
              selected:
              cropProvider.selectedFilter == "All",
              icon: Icons.grid_view_rounded,
            ),
          ),

          Expanded(
            child: _filterChip(
              context,
              title: "Active",
              displayTitle: lang.t("active"),
              count: cropProvider.activeCount,
              selected:
              cropProvider.selectedFilter == "Active",
              icon: Icons.eco_outlined,
            ),
          ),

          Expanded(
            child: _filterChip(
              context,
              title: "Sold Out",
              displayTitle: lang.t("soldOut"),
              count: cropProvider.soldOutCount,
              selected:
              cropProvider.selectedFilter == "Sold Out",
              icon: Icons.inventory_2_outlined,
            ),
          ),
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
        required IconData icon,
      }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.read<CropProvider>().changeFilter(title);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: selected
              ? darkGreen
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 17,
              color: selected
                  ? Colors.white
                  : darkGreen,
            ),

            const SizedBox(width: 6),

            Flexible(
              child: Text(
                "$displayTitle ($count)",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : darkGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CROP CONTENT
  // ============================================================

  Widget _buildCropContent(
      BuildContext context,
      CropProvider cropProvider,
      ) {
    // SAME ORIGINAL LOADING LOGIC
    if (cropProvider.isLoading &&
        cropProvider.allCrops.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(
          child: CircularProgressIndicator(
            color: darkGreen,
          ),
        ),
      );
    }

    // SAME ORIGINAL ERROR LOGIC
    if (cropProvider.errorMessage != null &&
        cropProvider.allCrops.isEmpty) {
      return _errorState(
        context,
        cropProvider,
      );
    }

    // SAME ORIGINAL EMPTY LOGIC
    if (cropProvider.crops.isEmpty) {
      return _emptyState(context);
    }

    // IMPORTANT:
    // No complicated LayoutBuilder here.
    // Directly show the crops.
    return Column(
      children: cropProvider.crops.map((crop) {
        return MyCropCard(
          crop: crop,

          // SAME EDIT LOGIC
          onEdit: () async {
            await Navigator.pushNamed(
              context,
              '/editCrop',
              arguments: crop,
            );

            if (!mounted) return;

            cropProvider.fetchCrops();
          },

          // SAME DELETE LOGIC
          onDelete: () {
            _confirmDelete(
              context,
              cropProvider,
              crop.id,
              crop.name,
            );
          },
        );
      }).toList(),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _errorState(
      BuildContext context,
      CropProvider cropProvider,
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      padding: const EdgeInsets.all(30),
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.red,
            size: 55,
          ),

          const SizedBox(height: 14),

          Text(
            cropProvider.errorMessage ??
                _tr(
                  context.watch<LanguageProvider>(),
                  "unableToLoadCrops",
                  en: "Unable to load crops.",
                  ur: "فصلیں لوڈ نہیں ہو سکیں۔",
                ),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _primaryText(context),
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: cropProvider.fetchCrops,
            icon: const Icon(Icons.refresh),
            label: Text(
              context.watch<LanguageProvider>().t("retry"),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: darkGreen,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _emptyState(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final provider = context.read<CropProvider>();

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 45,
      ),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _borderColor(context),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 78,
            width: 78,
            decoration: const BoxDecoration(
              color: Color(0xffe9f6ed),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.eco_outlined,
              size: 42,
              color: darkGreen,
            ),
          ),

          const SizedBox(height: 17),

          Text(
            _tr(
              lang,
              "noCropsFound",
              en: "No ${lang.tDynamic(provider.selectedFilter)} crops found",
              ur: "${lang.tDynamic(provider.selectedFilter)} کی کوئی فصل نہیں ملی",
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            _tr(
              lang,
              "addCropOrFilter",
              en: "Add a crop or select another filter.",
              ur: "فصل شامل کریں یا کوئی اور فلٹر منتخب کریں۔",
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _secondaryText(context),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DELETE
  // ============================================================

  Future<void> _confirmDelete(
      BuildContext context,
      CropProvider cropProvider,
      String cropId,
      String cropName,
      ) async {
    final shouldDelete =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: _cardColor(context),
          titleTextStyle: TextStyle(
            color: _primaryText(context),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
          contentTextStyle: TextStyle(
            color: _secondaryText(context),
            fontSize: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            _tr(
              context.read<LanguageProvider>(),
              "deleteCrop",
              en: "Delete Crop",
              ur: "فصل حذف کریں",
            ),
            style: TextStyle(
              color: _primaryText(context),
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            _tr(
              context.read<LanguageProvider>(),
              "confirmDeleteCrop",
              en: "Are you sure you want to delete $cropName?",
              ur: "کیا آپ واقعی $cropName حذف کرنا چاہتے ہیں؟",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: Text(
                _tr(
                  context.read<LanguageProvider>(),
                  "cancel",
                  en: "Cancel",
                  ur: "منسوخ",
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(
                _tr(
                  context.read<LanguageProvider>(),
                  "delete",
                  en: "Delete",
                  ur: "حذف",
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    final success =
    await cropProvider.deleteCrop(cropId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? _tr(
            context.read<LanguageProvider>(),
            "cropDeletedSuccessfully",
            en: "Crop deleted successfully.",
            ur: "فصل کامیابی سے حذف ہو گئی۔",
          )
              : cropProvider.errorMessage ??
              _tr(
                context.read<LanguageProvider>(),
                "unableToDeleteCrop",
                en: "Unable to delete crop.",
                ur: "فصل حذف نہیں ہو سکی۔",
              ),
        ),
        backgroundColor:
        success ? darkGreen : Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}

// ============================================================================
// MY CROP CARD
// ============================================================================

class MyCropCard extends StatelessWidget {
  final CropModel crop;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MyCropCard({
    super.key,
    required this.crop,
    required this.onEdit,
    required this.onDelete,
  });

  static const Color darkGreen = Color(0xff075739);

  bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  Color _cardColor(BuildContext context) =>
      _isDark(context) ? const Color(0xff18221c) : Colors.white;

  Color _primaryText(BuildContext context) =>
      _isDark(context) ? Colors.white : const Color(0xff171d19);

  Color _secondaryText(BuildContext context) =>
      _isDark(context) ? const Color(0xffb8c6bd) : const Color(0xff68736d);

  Color _borderColor(BuildContext context) =>
      _isDark(context) ? Colors.white12 : const Color(0xffdcebe2);

  Color _softChip(BuildContext context) =>
      _isDark(context) ? const Color(0xff202b24) : const Color(0xfff7faf8);

  String _tr(
      LanguageProvider lang,
      String key, {
        required String en,
        required String ur,
      }) {
    final translated = lang.t(key);
    return translated == key ? (lang.isUrdu ? ur : en) : translated;
  }

  bool get _isActive {
    return crop.status.trim().toLowerCase() == "active";
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Container(
      width: double.infinity,
      height: 215,
      margin: const EdgeInsets.only(
        left: 18,
        right: 18,
        bottom: 18,
      ),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _borderColor(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.055),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Row(
          children: [
            // ============================================================
            // IMAGE PANEL
            // ============================================================

            Expanded(
              flex: 34,
              child: _buildImagePanel(context),
            ),

            // ============================================================
            // DETAILS PANEL
            // ============================================================

            Expanded(
              flex: 66,
              child: _buildDetails(
                context,
                lang,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // IMAGE PANEL
  // ================================================================

  Widget _buildImagePanel(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Green shape behind image
        CustomPaint(
          painter: _GreenImageEdgePainter(),
        ),

        // Actual image
        ClipPath(
          clipper: _CropImageClipper(),
          child: Image.network(
            crop.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Container(
                color: const Color(0xffedf7f0),
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 25,
                    color: darkGreen,
                  ),
                ),
              );
            },
            loadingBuilder: (
                context,
                child,
                loadingProgress,
                ) {
              if (loadingProgress == null) {
                return child;
              }

              return Container(
                color: const Color(0xffedf7f0),
                child: const Center(
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: darkGreen,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ================================================================
  // DETAILS
  // ================================================================

  Widget _buildDetails(
      BuildContext context,
      LanguageProvider lang,
      ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        15,
        14,
        12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 45,
                decoration: BoxDecoration(
                  color: _isDark(context)
                      ? const Color(0xff20392b)
                      : const Color(0xffe7f5eb),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  _categoryIcon(),
                  color: darkGreen,
                  size: 20,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Text(
                  crop.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _primaryText(context),
                    height: 1.05,
                  ),
                ),
              ),

              const SizedBox(width: 6),

              _statusBadge(context, lang),
            ],
          ),

          const SizedBox(height: 12),

          // ------------------------------------------------------------
          // PRICE
          // ------------------------------------------------------------

          Text(
            "${lang.isUrdu ? "روپے" : "Rs."} ${crop.price} / "
                "${lang.tDynamic(crop.unit)}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: _isActive
                  ? darkGreen
                  : Colors.grey,
            ),
          ),

          const SizedBox(height: 13),

          // ------------------------------------------------------------
          // QUANTITY + CATEGORY
          // ------------------------------------------------------------

          Wrap(
            spacing: 8,
            runSpacing: 7,
            children: [
              _infoChip(
                context,
                Icons.inventory_2_outlined,
                "${crop.quantity} ${lang.tDynamic(crop.unit)}",
              ),

              if (crop.category.isNotEmpty)
                _infoChip(
                  context,
                  Icons.eco_outlined,
                  lang.tDynamic(crop.category),
                ),
            ],
          ),

          const Spacer(),

          // ------------------------------------------------------------
          // DIVIDER
          // ------------------------------------------------------------

          Divider(
            height: 1,
            color: _isDark(context)
                ? Colors.white12
                : const Color(0xffe1e7e3),
          ),

          const SizedBox(height: 11),

          // ------------------------------------------------------------
          // BUTTONS
          // ------------------------------------------------------------

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(
                    Icons.edit_rounded,
                    size: 17,
                  ),
                  label: Text(
                    lang.t("edit"),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: darkGreen,
                    side: const BorderSide(
                      color: Color(0xffcce2d4),
                    ),
                    minimumSize:
                    const Size(0, 41),
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        23,
                      ),
                    ),
                    textStyle:
                    const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                  ),
                  label: Text(
                    lang.t("delete"),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor:
                    const Color(0xffef4949),
                    backgroundColor:
                    const Color(0xfffff1f1),
                    minimumSize:
                    const Size(0, 41),
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        23,
                      ),
                    ),
                    textStyle:
                    const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================================================================
  // STATUS BADGE
  // ================================================================

  Widget _statusBadge(
      BuildContext context,
      LanguageProvider lang,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: _isActive
            ? (_isDark(context)
            ? const Color(0xff1e392a)
            : const Color(0xffe4f5e9))
            : (_isDark(context)
            ? const Color(0xff292f2b)
            : const Color(0xffeeeeee)),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 7,
            width: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isActive
                  ? const Color(0xff16824d)
                  : Colors.grey,
            ),
          ),

          const SizedBox(width: 5),

          Text(
            lang.tDynamic(crop.status),
            style: TextStyle(
              color: _isActive
                  ? const Color(0xff197344)
                  : (_isDark(context)
                  ? Colors.white60
                  : Colors.grey.shade700),
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // INFO CHIP
  // ================================================================

  Widget _infoChip(
      BuildContext context,
      IconData icon,
      String text,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: _softChip(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: darkGreen,
          ),

          const SizedBox(width: 6),

          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.5,
              color: _primaryText(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // CATEGORY ICON
  // ================================================================

  IconData _categoryIcon() {
    final category =
    crop.category.toLowerCase();

    if (category.contains("fruit")) {
      return Icons.spa_outlined;
    }

    if (category.contains("grain")) {
      return Icons.grass_outlined;
    }

    if (category.contains("vegetable")) {
      return Icons.eco_outlined;
    }

    return Icons.local_florist_outlined;
  }
}

// ==================================================================
// IMAGE CLIPPER
// ==================================================================

class _CropImageClipper
    extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // TOP LEFT rounded corner
    path.moveTo(15, 0);

    path.lineTo(
      size.width - 30,
      0,
    );

    // --------------------------------------------------------------
    // TOP -> CENTER CURVE
    // --------------------------------------------------------------

    path.cubicTo(
      size.width - 5,
      size.height * 0.12,
      size.width + 4,
      size.height * 0.32,
      size.width - 3,
      size.height * 0.48,
    );

    // --------------------------------------------------------------
    // CENTER -> BOTTOM CURVE
    // --------------------------------------------------------------

    path.cubicTo(
      size.width - 10,
      size.height * 0.67,
      size.width - 35,
      size.height * 0.86,
      size.width - 70,
      size.height,
    );

    // --------------------------------------------------------------
    // BOTTOM EDGE
    // --------------------------------------------------------------

    path.lineTo(
      22,
      size.height,
    );

    // BOTTOM LEFT rounded corner
    path.quadraticBezierTo(
      0,
      size.height,
      0,
      size.height - 22,
    );

    // LEFT EDGE
    path.lineTo(
      0,
      22,
    );

    // TOP LEFT rounded corner
    path.quadraticBezierTo(
      0,
      0,
      22,
      0,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(
      covariant CustomClipper<Path> oldClipper,
      ) {
    return false;
  }
}

// ==================================================================
// GREEN CURVE PAINTER
// ==================================================================

class _GreenImageEdgePainter
    extends CustomPainter {
  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final path = Path();

    path.moveTo(
      size.width - 20,
      0,
    );

    path.cubicTo(
      size.width + 2,
      size.height * 0.15,
      size.width + 8,
      size.height * 0.33,
      size.width + 1,
      size.height * 0.50,
    );

    path.cubicTo(
      size.width - 6,
      size.height * 0.68,
      size.width - 32,
      size.height * 0.88,
      size.width - 66,
      size.height,
    );

    path.lineTo(
      size.width - 45,
      size.height,
    );

    path.cubicTo(
      size.width - 12,
      size.height * 0.84,
      size.width + 4,
      size.height * 0.67,
      size.width + 9,
      size.height * 0.50,
    );

    path.cubicTo(
      size.width + 15,
      size.height * 0.31,
      size.width + 7,
      size.height * 0.13,
      size.width - 10,
      0,
    );

    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xff075739)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ) {
    return false;
  }
}
