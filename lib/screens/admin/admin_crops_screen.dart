import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_crops_provider.dart';
import '../../widgets/admin/admin_crop_card.dart';
import '../../widgets/admin/admin_crop_shimmer.dart';

class AdminCropsScreen extends StatefulWidget {
  const AdminCropsScreen({super.key});

  @override
  State<AdminCropsScreen> createState() => _AdminCropsScreenState();
}

class _AdminCropsScreenState extends State<AdminCropsScreen> {
  static const Color darkGreen = Color(0xFF0E5A3C);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AdminCropsProvider>().fetchCrops();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5),
      appBar: AppBar(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Crop Management",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: Consumer<AdminCropsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const AdminCropShimmer();
          }

          return Column(
            children: [
              _searchAndFilters(provider),
              Expanded(
                child: provider.crops.isEmpty
                    ? const Center(
                  child: Text(
                    "No crops found",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                )
                    : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  itemCount: provider.crops.length,
                  itemBuilder: (context, index) {
                    final crop = provider.crops[index];

                    return AdminCropCard(
                      crop: crop,
                      index: index,
                      onToggleStatus: () {
                        provider.toggleCropStatus(crop.id);
                      },
                      onDelete: () {
                        _confirmDelete(context, provider, crop.id);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _searchAndFilters(AdminCropsProvider provider) {
    final filters = ["All", "Active", "Inactive", "Reported"];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      child: Column(
        children: [
          TextField(
            onChanged: provider.updateSearch,
            decoration: InputDecoration(
              hintText: "Search crops...",
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final filter = filters[index];
                final selected = provider.selectedFilter == filter;

                return GestureDetector(
                  onTap: () => provider.changeFilter(filter),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: selected ? darkGreen : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        filter,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.grey.shade700,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
      BuildContext context,
      AdminCropsProvider provider,
      String id,
      ) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            "Delete Crop Listing?",
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          content: const Text(
            "This crop listing will be removed from admin records.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                provider.deleteCrop(id);
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}