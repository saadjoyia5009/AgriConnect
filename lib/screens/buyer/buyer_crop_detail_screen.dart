import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/crop_model.dart';
import '../../providers/language_provider.dart';
import 'send_inquiry_screen.dart';

class BuyerCropDetailScreen extends StatelessWidget {
  final CropModel crop;

  const BuyerCropDetailScreen({super.key, required this.crop});

  static const Color darkGreen = Color(0xff0F5C3A);
  static const Color lightBackground = Color(0xffF8FAF7);
  static const Color darkBackground = Color(0xFF0B1410);
  static const Color darkCard = Color(0xFF15251E);
  static const Color lightGreen = Color(0xff9ff2c1);

  bool _isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color _accent(BuildContext context) {
    return _isDark(context) ? lightGreen : darkGreen;
  }

  Color _primaryText(BuildContext context) {
    return _isDark(context) ? Colors.white : const Color(0xff10291D);
  }

  Color _secondaryText(BuildContext context) {
    return _isDark(context) ? Colors.white70 : const Color(0xff6A756D);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _isDark(context);

    return Scaffold(
      backgroundColor: isDark ? darkBackground : lightBackground,
      bottomNavigationBar: _bottomButtons(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _imageHeader(context),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _titleSection(context),
                    const SizedBox(height: 18),
                    _farmerCard(context),
                    const SizedBox(height: 18),
                    _detailsGrid(context),
                    const SizedBox(height: 18),
                    _descriptionSection(context),
                    const SizedBox(height: 18),
                    _attributeSection(context),
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageHeader(BuildContext context) {
    final isDark = _isDark(context);

    return Stack(
      children: [
        Image.network(
          crop.imageUrl,
          height: 280,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(
              height: 280,
              width: double.infinity,
              color: isDark ? darkCard : const Color(0xffEAF7EF),
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 60,
                color: _accent(context),
              ),
            );
          },
        ),
        Positioned(
          top: 14,
          left: 14,
          child: CircleAvatar(
            backgroundColor: isDark ? const Color(0xff1E1E1E) : Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: _accent(context)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        Positioned(
          top: 14,
          right: 14,
          child: CircleAvatar(
            backgroundColor: isDark ? const Color(0xff1E1E1E) : Colors.white,
            child: IconButton(
              icon: Icon(Icons.favorite_border, color: _accent(context)),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _titleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          crop.name,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: _primaryText(context),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.watch<LanguageProvider>().tDynamic(crop.category),
          style: TextStyle(
            fontSize: 14,
            color: _secondaryText(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _SmallChip(text: crop.category),
            if (crop.isOrganic) const _SmallChip(text: "Organic"),
            if (crop.isReadyToShip) const _SmallChip(text: "Ready to Ship"),
          ],
        ),
      ],
    );
  }

  Widget _farmerCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: _isDark(context)
                ? darkGreen.withOpacity(0.22)
                : const Color(0xffEAF7EF),
            child: Icon(Icons.person, color: _accent(context)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  crop.farmerName.trim().isNotEmpty
                      ? crop.farmerName
                      : 'Farmer',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: _primaryText(context),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: _secondaryText(context),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        crop.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: _secondaryText(context),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  context.watch<LanguageProvider>().t("farmerUploadedCrop"),
                  style: TextStyle(
                    fontSize: 12,
                    color: _secondaryText(context),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.verified, color: _accent(context)),
        ],
      ),
    );
  }

  Widget _detailsGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _detailBox(
                context: context,
                title: context.watch<LanguageProvider>().t("quantity"),
                value:
                    "${crop.quantity} ${context.watch<LanguageProvider>().tDynamic(crop.unit)}",
                icon: Icons.inventory_2_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _detailBox(
                context: context,
                title: context.watch<LanguageProvider>().t("price"),
                value:
                    "Rs. ${crop.price} / ${context.watch<LanguageProvider>().tDynamic(crop.unit)}",
                icon: Icons.sell_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _detailBox(
                context: context,
                title: context.watch<LanguageProvider>().t("harvestDate"),
                value: crop.harvestDate,
                icon: Icons.calendar_month_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _detailBox(
                context: context,
                title: context.watch<LanguageProvider>().t("status"),
                value: context.watch<LanguageProvider>().tDynamic(crop.status),
                icon: Icons.info_outline,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _detailBox({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _accent(context)),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: _secondaryText(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              color: _primaryText(context),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _descriptionSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.watch<LanguageProvider>().t("description"),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: _primaryText(context),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            crop.description,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: _isDark(context)
                  ? Colors.white70
                  : const Color(0xff4E5A52),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attributeSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.watch<LanguageProvider>().t("cropAttributes"),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: _primaryText(context),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (crop.isOrganic) const _AttributeChip(text: "Organic"),
              if (crop.isReadyToShip)
                const _AttributeChip(text: "Ready to Ship"),
              _AttributeChip(text: crop.category),
              _AttributeChip(text: crop.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomButtons(BuildContext context) {
    final isDark = _isDark(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
      decoration: BoxDecoration(
        color: isDark ? darkCard : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white10 : const Color(0xffDCE7DD),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 58,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xff1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? Colors.white12 : const Color(0xffDCE7DD),
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.favorite_border),
              color: _accent(context),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SendInquiryScreen(crop: crop),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  context.watch<LanguageProvider>().t("sendInquiry"),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration(BuildContext context) {
    final isDark = _isDark(context);

    return BoxDecoration(
      color: isDark ? darkCard : Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: isDark ? Colors.white10 : const Color(0xffDCE7DD),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.20 : 0.035),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }
}

class _SmallChip extends StatelessWidget {
  final String text;

  const _SmallChip({required this.text});

  static const Color darkGreen = Color(0xff0F5C3A);
  static const Color lightGreen = Color(0xff9ff2c1);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? darkGreen.withOpacity(0.25) : const Color(0xffEAF7EF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white10 : Colors.transparent),
      ),
      child: Text(
        lang.tDynamic(text),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: isDark ? lightGreen : darkGreen,
        ),
      ),
    );
  }
}

class _AttributeChip extends StatelessWidget {
  final String text;

  const _AttributeChip({required this.text});

  static const Color lightGreen = Color(0xff9ff2c1);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1E1E1E) : const Color(0xffF2F8F4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xffDCE7DD),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: isDark ? lightGreen : const Color(0xff0F8A4C),
          ),
          const SizedBox(width: 6),
          Text(
            lang.tDynamic(text),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white70 : const Color(0xff33443B),
            ),
          ),
        ],
      ),
    );
  }
}
