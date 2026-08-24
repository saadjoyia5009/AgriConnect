import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/crop_model.dart';
import '../../providers/language_provider.dart';

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
  static const Color softGreen = Color(0xffe8f5ec);

  bool get _isActive {
    return crop.status.trim().toLowerCase() == "active";
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1a211d) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white10
              : const Color(0xffe0ebe4),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.055),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontal = constraints.maxWidth >= 390;

            if (horizontal) {
              return _horizontalCard(
                context,
                lang,
                isDark,
              );
            }

            return _verticalCard(
              context,
              lang,
              isDark,
            );
          },
        ),
      ),
    );
  }

  Widget _horizontalCard(
      BuildContext context,
      LanguageProvider lang,
      bool isDark,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 125,
          child: _image(context, isDark),
        ),
        Expanded(
          child: _details(
            context,
            lang,
            isDark,
            compact: false,
          ),
        ),
      ],
    );
  }

  Widget _verticalCard(
      BuildContext context,
      LanguageProvider lang,
      bool isDark,
      ) {
    return Column(
      children: [
        SizedBox(
          height: 165,
          width: double.infinity,
          child: _image(context, isDark),
        ),
        _details(
          context,
          lang,
          isDark,
          compact: true,
        ),
      ],
    );
  }

  Widget _image(
      BuildContext context,
      bool isDark,
      ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          crop.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(
              color: isDark
                  ? const Color(0xff20382a)
                  : const Color(0xffedf7f0),
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 45,
                color: isDark
                    ? Colors.white54
                    : darkGreen,
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return Container(
              color: isDark
                  ? const Color(0xff20382a)
                  : const Color(0xffedf7f0),
              child: const Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: darkGreen,
                  ),
                ),
              ),
            );
          },
        ),

        // Green curved overlay
        Positioned(
          right: -35,
          top: -20,
          bottom: -20,
          child: Container(
            width: 55,
            decoration: const BoxDecoration(
              color: darkGreen,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(60),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _details(
      BuildContext context,
      LanguageProvider lang,
      bool isDark, {
        required bool compact,
      }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        compact ? 16 : 18,
        16,
        16,
        14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xff234c35)
                            : softGreen,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        _categoryIcon(),
                        color: darkGreen,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        crop.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: compact ? 19 : 20,
                          fontWeight: FontWeight.w900,
                          color: isDark
                              ? Colors.white
                              : const Color(0xff171d19),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _statusBadge(lang),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            "Rs. ${crop.price} / ${lang.tDynamic(crop.unit)}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _isActive
                  ? (isDark
                  ? const Color(0xff54bd82)
                  : darkGreen)
                  : Colors.grey,
              fontSize: compact ? 16 : 17,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 13),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _infoChip(
                icon: Icons.inventory_2_outlined,
                text:
                "${crop.quantity} ${lang.tDynamic(crop.unit)}",
                isDark: isDark,
              ),
              if (crop.category.isNotEmpty)
                _infoChip(
                  icon: Icons.eco_outlined,
                  text: lang.tDynamic(crop.category),
                  isDark: isDark,
                ),
            ],
          ),

          const SizedBox(height: 15),

          Divider(
            height: 1,
            color: isDark
                ? Colors.white10
                : const Color(0xffe1e6e3),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _editButton(
                  context,
                  lang,
                  isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _deleteButton(
                  context,
                  lang,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: _isActive
            ? const Color(0xffe4f5e9)
            : const Color(0xffeeeeee),
        borderRadius: BorderRadius.circular(20),
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
          const SizedBox(width: 6),
          Text(
            lang.tDynamic(crop.status),
            style: TextStyle(
              color: _isActive
                  ? const Color(0xff197344)
                  : Colors.grey.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip({
    required IconData icon,
    required String text,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xff202b24)
            : const Color(0xfff7faf8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 17,
            color: darkGreen,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark
                  ? Colors.white70
                  : const Color(0xff39423d),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _editButton(
      BuildContext context,
      LanguageProvider lang,
      bool isDark,
      ) {
    return OutlinedButton.icon(
      onPressed: onEdit,
      icon: const Icon(
        Icons.edit_rounded,
        size: 17,
      ),
      label: Text(
        lang.t("edit"),
        overflow: TextOverflow.ellipsis,
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: darkGreen,
        side: BorderSide(
          color: isDark
              ? const Color(0xff326b4d)
              : const Color(0xffc9e1d2),
        ),
        minimumSize: const Size(0, 43),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        textStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _deleteButton(
      BuildContext context,
      LanguageProvider lang,
      ) {
    return TextButton.icon(
      onPressed: onDelete,
      icon: const Icon(
        Icons.delete_outline_rounded,
        size: 18,
      ),
      label: Text(
        lang.t("delete"),
        overflow: TextOverflow.ellipsis,
      ),
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xffed4b4b),
        backgroundColor: const Color(0xfffff1f1),
        minimumSize: const Size(0, 43),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        textStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  IconData _categoryIcon() {
    final category = crop.category.toLowerCase();

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