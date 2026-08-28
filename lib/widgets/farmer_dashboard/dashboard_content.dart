import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/crop_provider.dart';
import '../../providers/language_provider.dart';
import 'ai_farming_insight.dart';
import 'attention_needed.dart';
import 'daily_farming_tip.dart';
import 'dashboard_colors.dart';
import 'farmer_overview.dart';
import 'quick_actions.dart';
import 'weather_today.dart';

class DashboardContent extends StatelessWidget {
  final CropProvider cropProvider;
  final LanguageProvider lang;
  final bool isDark;
  final Color cardColor;
  final Color textColor;
  final Color subTextColor;
  final Color softBorderColor;
  final String voiceText;
  final VoidCallback onVoiceTap;
  final List<Map<String, dynamic>> dailyTips;

  const DashboardContent({
    required this.cropProvider,
    required this.lang,
    required this.isDark,
    required this.cardColor,
    required this.textColor,
    required this.subTextColor,
    required this.softBorderColor,
    required this.voiceText,
    required this.onVoiceTap,
    required this.dailyTips,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FarmerOverview(
            isDark: isDark,
            cardColor: cardColor,
            subTextColor: subTextColor,
            softBorderColor: softBorderColor,
            welcomeText: lang.t("welcomeBackComma"),
            subtitleText: lang.t("growSmarterSellBetter"),
            activeCrops: cropProvider.activeCrops.toString(),
            activeCropsTitle: lang.t("activeCrops"),
            inquiries: cropProvider.newInquiries.toString(),
            inquiriesTitle: lang.t("inquiries"),
            thisSeasonTitle: lang.t("thisSeason"),
            thisSeasonValue: lang.t("goodProgress"),
            priceTrendTitle: lang.t("priceTrend"),
            priceTrendValue: lang.t("rising"),
            weatherTitle: lang.t("weather"),
            weatherValue: lang.t("checkNow"),
            onWeatherTap: () => Navigator.pushNamed(context, "/weather"),
            onVoiceTap: onVoiceTap,
            voiceText: voiceText,
          ),
          const SizedBox(height: 28),
          _SectionHeader(
            title: lang.t("quickActions"),
            showViewAll: true,
          ),
          const SizedBox(height: 14),
          QuickActions(
            addCropTitle: lang.t("addCrop"),
            addCropSubtitle: lang.t("listNewCrop"),
            myCropsTitle: lang.t("myCrops"),
            myCropsSubtitle: lang.t("manageCrops"),
            pricePredictionTitle: lang.t("pricePrediction"),
            pricePredictionSubtitle: lang.t("checkPrices"),
            weatherTitle: lang.t("weather"),
            weatherSubtitle: lang.t("weatherForecast"),
            cardColor: cardColor,
            textColor: textColor,
            subTextColor: subTextColor,
            onMyCropsTap: () =>
                Navigator.pushNamed(context, "/myCrops"),
          ),
          const SizedBox(height: 26),
          AttentionNeeded(
            newInquiries: cropProvider.newInquiries,
            weatherAlert: cropProvider.weatherAlert,
            isDark: isDark,
            cardColor: cardColor,
            textColor: textColor,
            title: lang.t("actionRequired"),
            weatherAlertFallback: lang.t("weatherAlert"),
            isUrdu: lang.isUrdu,
            onMyCropsTap: () =>
                Navigator.pushNamed(context, "/myCrops"),
            onWeatherTap: () =>
                Navigator.pushNamed(context, "/weather"),
          ),
          const SizedBox(height: 26),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 720) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: WeatherToday(
                        weather: cropProvider.weatherAlert,
                        isDark: isDark,
                        cardColor: cardColor,
                        textColor: textColor,
                        subTextColor: subTextColor,
                        weatherUpdate: lang.t("weatherUpdate"),
                        weatherForecast: lang.t("weatherForecast"),
                        humidityTitle: lang.t("humidity"),
                        windTitle: lang.t("wind"),
                        rainChanceTitle: lang.t("rainChanceLabel"),
                        goodConditionsText: lang.isUrdu
                            ? "کھیت کے کام کے لیے حالات اچھے ہیں"
                            : "Good conditions for field work",
                        onTap: () =>
                            Navigator.pushNamed(context, "/weather"),
                        isUrdu: lang.isUrdu,
                      ),
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  const SizedBox(height: 16),
                  WeatherToday(
                    weather: cropProvider.weatherAlert,
                    isDark: isDark,
                    cardColor: cardColor,
                    textColor: textColor,
                    subTextColor: subTextColor,
                    weatherUpdate: lang.t("weatherUpdate"),
                    weatherForecast: lang.t("weatherForecast"),
                    humidityTitle: lang.t("humidity"),
                    windTitle: lang.t("wind"),
                    rainChanceTitle: lang.t("rainChanceLabel"),
                    goodConditionsText: lang.isUrdu
                        ? "کھیت کے کام کے لیے حالات اچھے ہیں"
                        : "Good conditions for field work",
                    onTap: () =>
                        Navigator.pushNamed(context, "/weather"),
                    isUrdu: lang.isUrdu,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          AiFarmingInsight(
            weatherAlert: cropProvider.weatherAlert,
            isDark: isDark,
            textColor: textColor,
            subTextColor: subTextColor,
            sectionTitle: lang.t("dailyFarmingTip"),
            seeMore: lang.t("seeMore"),
            isUrdu: lang.isUrdu,
          ),
          const SizedBox(height: 20),
          DailyFarmingTip(
            isDark: isDark,
            cardColor: cardColor,
            textColor: textColor,
            subTextColor: subTextColor,
            sectionTitle: lang.t("dailyFarmingTip"),
            seeMore: lang.t("seeMore"),
            tips: dailyTips,
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool showViewAll;

  const _SectionHeader({
    required this.title,
    this.showViewAll = false,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Row(
      children: [
        Expanded(
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.2,
            ),
          ),
        ),
        if (showViewAll)
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  lang.t("viewAll"),
                  style: const TextStyle(
                    color: DashboardColors.darkGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: DashboardColors.darkGreen,
                  size: 12,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
