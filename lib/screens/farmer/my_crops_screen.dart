import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/crop_provider.dart';
import '../../widgets/crop_card.dart';
import '../../widgets/farmer_bottom_navbar.dart';

class MyCropsScreen extends StatelessWidget {
  const MyCropsScreen({super.key});

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final cropProvider = Provider.of<CropProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: const FarmerBottomNavbar(
        currentIndex: 1,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, '/addCrop');
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Crops",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        _filterChip(
                          context,
                          title: "All",
                          count: cropProvider.allCount,
                          selected: cropProvider.selectedFilter == "All",
                        ),
                        const SizedBox(width: 10),
                        _filterChip(
                          context,
                          title: "Active",
                          count: cropProvider.activeCount,
                          selected: cropProvider.selectedFilter == "Active",
                        ),
                        const SizedBox(width: 10),
                        _filterChip(
                          context,
                          title: "Sold Out",
                          count: cropProvider.soldOutCount,
                          selected: cropProvider.selectedFilter == "Sold Out",
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    ListView.builder(
                      itemCount: cropProvider.crops.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final crop = cropProvider.crops[index];

                        return MyCropCard(
                          crop: crop,
                          onEdit: () {
                            Navigator.pushNamed(context, '/editCrop');
                          },
                          onDelete: () {
                            cropProvider.deleteCrop(crop.id);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white12 : const Color(0xffe4eee8),
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
                "AgriConnect",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : darkGreen,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(
      BuildContext context, {
        required String title,
        required int count,
        required bool selected,
      }) {
    final cropProvider = Provider.of<CropProvider>(context, listen: false);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        cropProvider.changeFilter(title);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? darkGreen : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? darkGreen
                : isDark
                ? Colors.white12
                : const Color(0xffd8e6de),
          ),
        ),
        child: Text(
          "$title ($count)",
          style: TextStyle(
            color: selected
                ? Colors.white
                : isDark
                ? Colors.white
                : const Color(0xff333333),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}