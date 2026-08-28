import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/responsive/responsive_layout.dart';
import '../../providers/crop_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/farmer_bottom_navbar.dart';
import '../../widgets/my_crops/my_crops_top_bar.dart';
import '../../widgets/my_crops/my_crops_hero.dart';
import '../../widgets/my_crops/my_crops_filter.dart';
import '../../widgets/my_crops/my_crops_content.dart';

class MyCropsScreen extends StatefulWidget {
  const MyCropsScreen({super.key});

  @override
  State<MyCropsScreen> createState() => _MyCropsScreenState();
}

class _MyCropsScreenState extends State<MyCropsScreen> {
  static const Color darkGreen = Color(0xff075739);

  bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  Color _backgroundColor(BuildContext context) =>
      _isDark(context) ? const Color(0xff101713) : const Color(0xfff6faf7);

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
      backgroundColor: _backgroundColor(context),
      bottomNavigationBar: const FarmerBottomNavbar(
        currentIndex: 1,
      ),
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
        textDirection:
        lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
        child: ResponsiveLayout(
          child: Column(
            children: [
              const MyCropsTopBar(),
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
                        const MyCropsHero(),
                        const SizedBox(height: 4),
                        const MyCropsFilter(),
                        const SizedBox(height: 4),
                        MyCropsContent(
                          provider: cropProvider,
                          onEdit: (crop) async {
                            await Navigator.pushNamed(
                              context,
                              '/editCrop',
                              arguments: crop,
                            );

                            if (!mounted) return;
                            cropProvider.fetchCrops();
                          },
                          onDelete: (crop) {
                            _confirmDelete(
                              context,
                              cropProvider,
                              crop.id,
                              crop.name,
                            );
                          },
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

  Future<void> _confirmDelete(
      BuildContext context,
      CropProvider cropProvider,
      String cropId,
      String cropName,
      ) async {
    final lang = context.read<LanguageProvider>();
    final isDark = _isDark(context);

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
          isDark ? const Color(0xff18221c) : Colors.white,
          title: Text(
            _tr(
              lang,
              "deleteCrop",
              en: "Delete Crop",
              ur: "فصل حذف کریں",
            ),
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xff161d19),
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            _tr(
              lang,
              "confirmDeleteCrop",
              en: "Are you sure you want to delete $cropName?",
              ur: "کیا آپ واقعی $cropName حذف کرنا چاہتے ہیں؟",
            ),
            style: TextStyle(
              color:
              isDark ? const Color(0xffb8c6bd) : const Color(0xff68736d),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                _tr(
                  lang,
                  "cancel",
                  en: "Cancel",
                  ur: "منسوخ",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(
                _tr(
                  lang,
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

    if (shouldDelete != true || !mounted) return;

    final success = await cropProvider.deleteCrop(cropId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? _tr(
            lang,
            "cropDeletedSuccessfully",
            en: "Crop deleted successfully.",
            ur: "فصل کامیابی سے حذف ہو گئی۔",
          )
              : cropProvider.errorMessage ??
              _tr(
                lang,
                "unableToDeleteCrop",
                en: "Unable to delete crop.",
                ur: "فصل حذف نہیں ہو سکی۔",
              ),
        ),
        backgroundColor: success ? darkGreen : Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  String _tr(
      LanguageProvider lang,
      String key, {
        required String en,
        required String ur,
      }) {
    final translated = lang.t(key);
    return translated == key ? (lang.isUrdu ? ur : en) : translated;
  }
}
