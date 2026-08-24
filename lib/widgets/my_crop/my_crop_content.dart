import 'package:flutter/material.dart';

import '../../core/responsive/responsive_layout.dart';
import '../../providers/crop_provider.dart';
import 'my_crop_card.dart';
import 'my_crop_empty_state.dart';
import 'my_crop_error_state.dart';

class MyCropContent extends StatelessWidget {
  final CropProvider cropProvider;
  final Future<void> Function(
      String cropId,
      String cropName,
      ) onDelete;

  const MyCropContent({
    super.key,
    required this.cropProvider,
    required this.onDelete,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
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

    if (cropProvider.errorMessage != null &&
        cropProvider.allCrops.isEmpty) {
      return MyCropErrorState(
        message: cropProvider.errorMessage!,
        onRetry: cropProvider.fetchCrops,
      );
    }

    if (cropProvider.crops.isEmpty) {
      return const MyCropEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cropCards = List.generate(
          cropProvider.crops.length,
              (index) {
            final crop = cropProvider.crops[index];

            return MyCropCard(
              crop: crop,
              onEdit: () async {
                await Navigator.pushNamed(
                  context,
                  '/editCrop',
                  arguments: crop,
                );

                if (!context.mounted) return;

                cropProvider.fetchCrops();
              },
              onDelete: () {
                onDelete(
                  crop.id,
                  crop.name,
                );
              },
            );
          },
        );

        if (constraints.maxWidth < 600) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: cropCards,
          );
        }

        return ResponsiveGrid(
          mobileColumns: 1,
          tabletColumns: 2,
          desktopColumns: 3,
          wideDesktopColumns: 4,
          childAspectRatio: 0.90,
          children: cropCards,
        );
      },
    );
  }
}