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
