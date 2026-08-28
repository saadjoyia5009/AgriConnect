import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import '../../screens/farmer/add_crop_screen.dart';
import '../../screens/farmer/price_prediction_screen.dart';
import '../../screens/farmer/weather_forecast_screen.dart';
import 'dashboard_colors.dart';
import 'dashboard_models.dart';

class QuickActions extends StatelessWidget {
  final String addCropTitle;
  final String addCropSubtitle;
  final String myCropsTitle;
  final String myCropsSubtitle;
  final String pricePredictionTitle;
  final String pricePredictionSubtitle;
  final String weatherTitle;
  final String weatherSubtitle;
  final Color cardColor;
  final Color textColor;
  final Color subTextColor;
  final VoidCallback onMyCropsTap;

  const QuickActions({
    super.key,
    required this.addCropTitle,
    required this.addCropSubtitle,
    required this.myCropsTitle,
    required this.myCropsSubtitle,
    required this.pricePredictionTitle,
    required this.pricePredictionSubtitle,
    required this.weatherTitle,
    required this.weatherSubtitle,
    required this.cardColor,
    required this.textColor,
    required this.subTextColor,
    required this.onMyCropsTap,
  });

  @override
  Widget build(BuildContext context) {
    final actions = [
      DashboardActionData(
        icon: Icons.eco_rounded,
        title: addCropTitle,
        subtitle: addCropSubtitle,
        iconColor: DashboardColors.primaryGreen,
        background: const Color(0xfff1faef),
        screen: const AddCropScreen(),
      ),
      DashboardActionData(
        icon: Icons.grass_rounded,
        title: myCropsTitle,
        subtitle: myCropsSubtitle,
        iconColor: DashboardColors.orangeColor,
        background: const Color(0xfffff8ed),
        onTap: onMyCropsTap,
      ),
      DashboardActionData(
        icon: Icons.trending_up_rounded,
        title: pricePredictionTitle,
        subtitle: pricePredictionSubtitle,
        iconColor: DashboardColors.purpleColor,
        background: const Color(0xfff7f1ff),
        screen: const PricePredictionScreen(),
      ),
      DashboardActionData(
        icon: Icons.cloud_outlined,
        title: weatherTitle,
        subtitle: weatherSubtitle,
        iconColor: DashboardColors.blueColor,
        background: const Color(0xffeff8ff),
        screen: const WeatherForecastScreen(),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 600 ? 4 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: columns == 2 ? 1.08 : 1.05,
          ),
          itemBuilder: (context, index) {
            return _QuickActionCard(
              action: actions[index],
              cardColor: cardColor,
              textColor: textColor,
              subTextColor: subTextColor,
            );
          },
        );
      },
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final DashboardActionData action;
  final Color cardColor;
  final Color textColor;
  final Color subTextColor;

  const _QuickActionCard({
    required this.action,
    required this.cardColor,
    required this.textColor,
    required this.subTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 350),
      closedElevation: 0,
      openElevation: 0,
      closedColor: Colors.transparent,
      openColor: Theme.of(context).scaffoldBackgroundColor,
      closedBuilder: (context, openContainer) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: action.onTap ?? openContainer,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? cardColor
                    : action.background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: action.iconColor.withOpacity(0.18),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: action.iconColor.withOpacity(0.11),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      action.icon,
                      color: action.iconColor,
                      size: 27,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    action.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    action.subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 10.5,
                      height: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      openBuilder: (context, _) =>
      action.screen ?? const SizedBox.shrink(),
    );
  }
}
