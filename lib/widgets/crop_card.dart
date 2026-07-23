import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/crop_model.dart';
import '../providers/language_provider.dart';

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

  bool get _isActive {
    return crop.status.trim().toLowerCase() == "active";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final lang = context.watch<LanguageProvider>();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1E1E1E) : Colors.white,
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xffd8e6de),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _imageSection(context, isDark, lang),
          _informationSection(context, isDark, lang),
        ],
      ),
    );
  }

  Widget _imageSection(
    BuildContext context,
    bool isDark,
    LanguageProvider lang,
  ) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          child: Image.network(
            crop.imageUrl,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Container(
                height: 150,
                width: double.infinity,
                color: isDark ? Colors.white10 : const Color(0xffeef7f1),
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 45,
                  color: isDark ? Colors.white54 : darkGreen,
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _isActive
                  ? darkGreen
                  : (isDark ? Colors.white12 : Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              lang.tDynamic(crop.status),
              style: TextStyle(
                fontSize: 11,
                color: _isActive
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.grey.shade700),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _informationSection(
    BuildContext context,
    bool isDark,
    LanguageProvider lang,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  crop.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xff222222),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Rs. ${crop.price} / "
                "${lang.tDynamic(crop.unit)}",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: _isActive
                      ? (isDark ? const Color(0xff4CAF50) : darkGreen)
                      : Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 14,
                color: isDark ? Colors.white60 : const Color(0xff4f5955),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  "${crop.quantity} "
                  "${lang.tDynamic(crop.unit)}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
              if (crop.category.isNotEmpty) ...[
                const SizedBox(width: 14),
                Icon(
                  Icons.eco_outlined,
                  size: 14,
                  color: isDark ? Colors.white60 : const Color(0xff4f5955),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    lang.tDynamic(crop.category),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            height: 1,
            color: isDark ? Colors.white12 : Colors.grey.shade300,
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, size: 14),
                label: Text(lang.t("edit")),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white : Colors.black87,
                  side: BorderSide(
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                  ),
                  minimumSize: const Size(70, 34),
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(width: 10),
              TextButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 14),
                label: Text(lang.t("delete")),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
