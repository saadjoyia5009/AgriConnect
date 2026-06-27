import 'package:flutter/material.dart';
import '../../models/crop_model.dart';
import 'send_inquiry_screen.dart';

class BuyerCropDetailScreen extends StatelessWidget {
  final CropModel crop;

  const BuyerCropDetailScreen({
    super.key,
    required this.crop,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAF7),
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
                    _titleSection(),
                    const SizedBox(height: 18),
                    _farmerCard(),
                    const SizedBox(height: 18),
                    _detailsGrid(),
                    const SizedBox(height: 18),
                    _descriptionSection(),
                    const SizedBox(height: 18),
                    _attributeSection(),
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
              color: const Color(0xffEAF7EF),
              child: const Icon(
                Icons.image_not_supported_outlined,
                size: 60,
                color: Color(0xff0F5C3A),
              ),
            );
          },
        ),
        Positioned(
          top: 14,
          left: 14,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xff0F5C3A)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        Positioned(
          top: 14,
          right: 14,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.favorite_border, color: Color(0xff0F5C3A)),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _titleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          crop.name,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Color(0xff10291D),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          crop.category,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xff6A756D),
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

  Widget _farmerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Color(0xffEAF7EF),
            child: Icon(Icons.person, color: Color(0xff0F5C3A)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  crop.location,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff10291D),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Farmer uploaded crop",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff5F675F),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.verified, color: Color(0xff0F8A4C)),
        ],
      ),
    );
  }

  Widget _detailsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _detailBox(
                title: "Quantity",
                value: crop.quantity,
                icon: Icons.inventory_2_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _detailBox(
                title: "Price",
                value: "${crop.price}${crop.unit}",
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
                title: "Harvest Date",
                value: crop.harvestDate,
                icon: Icons.calendar_month_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _detailBox(
                title: "Status",
                value: crop.status,
                icon: Icons.info_outline,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _detailBox({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xff0F5C3A)),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xff6A756D),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xff10291D),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _descriptionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Description",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xff10291D),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            crop.description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xff4E5A52),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attributeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Crop Attributes",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xff10291D),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (crop.isOrganic) const _AttributeChip(text: "Organic"),
              if (crop.isReadyToShip) const _AttributeChip(text: "Ready to Ship"),
              _AttributeChip(text: crop.category),
              _AttributeChip(text: crop.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xffDCE7DD)),
            ),
            child: IconButton(
              icon: const Icon(Icons.favorite_border),
              color: const Color(0xff0F5C3A),
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
                  backgroundColor: const Color(0xff0F5C3A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Send Inquiry",
                  style: TextStyle(
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

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xffDCE7DD)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.035),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xffEAF7EF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Color(0xff0F5C3A),
        ),
      ),
    );
  }
}

class _AttributeChip extends StatelessWidget {
  final String text;

  const _AttributeChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xffF2F8F4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffDCE7DD)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 16, color: Color(0xff0F8A4C)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xff33443B),
            ),
          ),
        ],
      ),
    );
  }
}