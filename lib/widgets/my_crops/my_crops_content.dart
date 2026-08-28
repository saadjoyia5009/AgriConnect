import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/crop_model.dart';
import '../../providers/crop_provider.dart';
import '../../providers/language_provider.dart';
import 'my_crop_card.dart';

class MyCropsContent extends StatelessWidget {
  final CropProvider provider;
  final ValueChanged<CropModel> onEdit;
  final ValueChanged<CropModel> onDelete;

  const MyCropsContent({
    super.key,
    required this.provider,
    required this.onEdit,
    required this.onDelete,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    if (provider.isLoading && provider.allCrops.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(
          child: CircularProgressIndicator(color: darkGreen),
        ),
      );
    }

    if (provider.errorMessage != null && provider.allCrops.isEmpty) {
      return _errorState(context);
    }

    if (provider.crops.isEmpty) {
      return _emptyState(context);
    }

    return Column(
      children: provider.crops.map((crop) {
        return MyCropCard(
          crop: crop,
          onEdit: () => onEdit(crop),
          onDelete: () => onDelete(crop),
        );
      }).toList(),
    );
  }

  Widget _errorState(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(30),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff18221c) : Colors.white,
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
            provider.errorMessage ??
                _tr(
                  lang,
                  "unableToLoadCrops",
                  en: "Unable to load crops.",
                  ur: "فصلیں لوڈ نہیں ہو سکیں۔",
                ),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xff161d19),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: provider.fetchCrops,
            icon: const Icon(Icons.refresh),
            label: Text(lang.t("retry")),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 45,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff18221c) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xffdcebe2),
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
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xff161d19),
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
              color: isDark
                  ? const Color(0xffb8c6bd)
                  : const Color(0xff68736d),
              fontSize: 14,
            ),
          ),
        ],
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
