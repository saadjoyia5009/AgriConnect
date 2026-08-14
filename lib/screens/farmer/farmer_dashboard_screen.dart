import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import '../../providers/crop_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/farmer_bottom_navbar.dart';
import '../../services/voice_assistant_service.dart';
import '../../widgets/voice_assistant_sheet.dart';
import 'add_crop_screen.dart';
import 'price_prediction_screen.dart';
import 'disease_detection_screen.dart';
import 'weather_forecast_screen.dart';
import 'farmer_top_bar.dart';
import 'farmer_notification_screen.dart';

class FarmerDashboardScreen extends StatefulWidget {
  const FarmerDashboardScreen({super.key});

  @override
  State<FarmerDashboardScreen> createState() => _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState extends State<FarmerDashboardScreen> {
  static const Color darkGreen = Color(0xff075739);
  static const Color mediumGreen = Color(0xff2d7153);
  static const Color lightGreen = Color(0xffe8f7ef);
  static const Color blueColor = Color(0xff168ad1);
  static const Color orangeColor = Color(0xffffa41b);

  bool _isLoading = false;
  String? _errorMessage;

  final VoiceAssistantService _voiceAssistantService =
  VoiceAssistantService();
  bool _isListening = false;
  String _voiceText = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadDashboardData);
  }

  void _openVoiceAssistant() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return VoiceAssistantSheet(
          // onAction: _handleVoiceAction,
        );
      },
    );
  }

  Future<void> _loadDashboardData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      await context.read<CropProvider>().fetchFarmerDashboard();

      if (!mounted) return;
      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = "failedLoadDashboard";
      });
    }
  }

  Future<void> _toggleVoiceAssistant() async {
    if (_isListening) {
      await _voiceAssistantService.stopListening();

      if (!mounted) return;

      setState(() {
        _isListening = false;
      });

      return;
    }

    final initialized = await _voiceAssistantService.initialize(
      onError: (message) {
        if (!mounted) return;

        setState(() {
          _isListening = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      },
      onStatus: (status) {
        if (!mounted) return;

        if (status == "done" || status == "notListening") {
          setState(() {
            _isListening = false;
          });
        }
      },
    );

    if (!initialized) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Microphone permission is required.",
          ),
        ),
      );

      return;
    }

    if (!mounted) return;

    setState(() {
      _isListening = true;
      _voiceText = "";
    });

    final started = await _voiceAssistantService.startListening(
      onResult: (text) {
        if (!mounted) return;

        setState(() {
          _voiceText = text;
        });
      },
      onError: (message) {
        if (!mounted) return;

        setState(() {
          _isListening = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      },
      onStatus: (status) {
        if (!mounted) return;

        if (status == "done" || status == "notListening") {
          setState(() {
            _isListening = false;
          });
        }
      }, localeId: 'en_US',
    );

    if (!started && mounted) {
      setState(() {
        _isListening = false;
      });
    }
  }

  bool _isDark() => Theme.of(context).brightness == Brightness.dark;

  Color get _cardColor => Theme.of(context).cardColor;

  Color get _textColor =>
      Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

  Color get _subTextColor =>
      _isDark() ? Colors.white70 : const Color(0xff5f6964);

  @override
  Widget build(BuildContext context) {
    final cropProvider = context.watch<CropProvider>();
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      appBar: FarmerTopBar(
        title: lang.t("dashboard"),
        onNotificationTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const FarmerNotificationScreen()),
          );
        },
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: const FarmerBottomNavbar(currentIndex: 0),
      body: SafeArea(
        child: RefreshIndicator(
          color: darkGreen,
          onRefresh: _loadDashboardData,
          child: _isLoading
              ? const Center(
              child: CircularProgressIndicator(color: darkGreen))
              : _errorMessage != null
              ? _errorView()
              : SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _welcomeCard(
                  lang: lang,
                  activeCrops: cropProvider.activeCrops,
                  newInquiries: cropProvider.newInquiries,
                ),
                const SizedBox(height: 26),
                _sectionHeader(lang.t("quickActions")),
                const SizedBox(height: 14),
                _quickActionsGrid(lang),
                const SizedBox(height: 22),
                cropProvider.weatherAlert != null
                    ? _weatherAlertCard(cropProvider.weatherAlert!)
                    : _emptyWeatherCard(),
                const SizedBox(height: 22),
                _dailyTipCard(),
                const SizedBox(height: 22),
                _marketAdvisoryCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _welcomeCard({
    required LanguageProvider lang,
    required int activeCrops,
    required int newInquiries,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff004f34), Color(0xff0b8b58)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withOpacity(0.28),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -34,
            top: 22,
            child: Icon(
              Icons.landscape_rounded,
              size: 170,
              color: Colors.white.withOpacity(0.06),
            ),
          ),
          Positioned(
            right: 8,
            top: -18,
            child: Icon(
              Icons.eco_rounded,
              size: 84,
              color: Colors.white.withOpacity(0.12),
            ),
          ),
          // Clean Mic Button Position (Top Right - Opens Voice Assistant Sheet)
          Positioned(
            top: 18,
            right: 18,
            child: GestureDetector(
              onTap: _openVoiceAssistant,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.35),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.mic_none_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.watch<LanguageProvider>().t("welcomeBackComma"),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(right: 60),
                child: Text(
                  context
                      .watch<LanguageProvider>()
                      .t("growSmarterSellBetter"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (_voiceText.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  _voiceText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: _greenMainStat(
                      icon: Icons.local_florist_rounded,
                      title: lang.t("activeCrops"),
                      value: activeCrops.toString(),
                      subtitle: lang.t("updated"),
                      iconColor: lightGreen,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _greenMainStat(
                      icon: Icons.chat_bubble_rounded,
                      title: lang.t("newInquiries"),
                      value: newInquiries.toString(),
                      subtitle: lang.t("actionRequired"),
                      iconColor: orangeColor,
                      warning: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Divider(color: Colors.white.withOpacity(0.22)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _greenBottomInfo(
                      icon: Icons.calendar_month_rounded,
                      title: lang.t("thisSeason"),
                      value: lang.t("goodProgress"),
                    ),
                  ),
                  _smallDivider(),
                  Expanded(
                    child: _greenBottomInfo(
                      icon: Icons.trending_up_rounded,
                      title: lang.t("priceTrend"),
                      value: lang.t("rising"),
                    ),
                  ),
                  _smallDivider(),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, "/weather"),
                      child: _greenBottomInfo(
                        icon: Icons.cloud_outlined,
                        title: lang.t("weather"),
                        value: lang.t("checkNow"),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _greenMainStat({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color iconColor,
    bool warning = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Icon(
                warning ? Icons.info_rounded : Icons.access_time_rounded,
                color: warning ? orangeColor : Colors.white70,
                size: 13,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: warning ? orangeColor : Colors.white70,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _greenBottomInfo({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 7),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _smallDivider() {
    return Container(
      height: 42,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white.withOpacity(0.22),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: _textColor,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.watch<LanguageProvider>().t("viewAll"),
              style: const TextStyle(
                color: darkGreen,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: darkGreen, size: 14),
          ],
        ),
      ],
    );
  }

  Widget _quickActionsGrid(LanguageProvider lang) {
    final actions = [
      _quickAction(
        icon: Icons.add_rounded,
        title: lang.t("addCrop"),
        subtitle: context.watch<LanguageProvider>().t("manageCrops"),
        screen: const AddCropScreen(),
        bgColor: const Color(0xffeef8ef),
        iconColor: const Color(0xff25b968),
      ),
      _quickAction(
        icon: Icons.trending_up_rounded,
        title: lang.t("pricePrediction"),
        subtitle: context.watch<LanguageProvider>().t("checkPrices"),
        screen: const PricePredictionScreen(),
        bgColor: const Color(0xffeef8f2),
        iconColor: mediumGreen,
      ),
      _quickAction(
        icon: Icons.health_and_safety_rounded,
        title: lang.t("diseaseDetection"),
        subtitle: context.watch<LanguageProvider>().t("findIssues"),
        screen: const DiseaseDetectionScreen(),
        bgColor: const Color(0xfffff4e5),
        iconColor: orangeColor,
      ),
      _quickAction(
        icon: Icons.cloud_outlined,
        title: lang.t("weather"),
        subtitle: context.watch<LanguageProvider>().t("planDay"),
        screen: const WeatherForecastScreen(),
        bgColor: const Color(0xffeef7ff),
        iconColor: blueColor,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 600 ? 4 : 2;
        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: columns == 2 ? .92 : .72,
          children: actions,
        );
      },
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget screen,
    required Color bgColor,
    required Color iconColor,
  }) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 350),
      closedElevation: 0,
      openElevation: 0,
      closedColor: Colors.transparent,
      openColor: Theme.of(context).scaffoldBackgroundColor,
      closedBuilder: (context, openContainer) {
        return InkWell(
          onTap: openContainer,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: _isDark() ? _cardColor : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: _isDark() ? Colors.white12 : const Color(0xffe6eee9),
              ),
              boxShadow: [
                BoxShadow(
                  color: _isDark()
                      ? Colors.black.withOpacity(0.18)
                      : Colors.black.withOpacity(0.055),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 27),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.1,
                    color: _textColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Flexible(
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      height: 1.1,
                      color: _subTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      openBuilder: (context, _) => screen,
    );
  }

  Widget _dailyTipCard() {
    final lang = context.watch<LanguageProvider>();

    final tips = [
      {
        "title": lang.t("tipWaterTitle"),
        "tip": lang.t("tipWaterBody"),
        "icon": Icons.water_drop_outlined,
      },
      {
        "title": lang.t("tipLeavesTitle"),
        "tip": lang.t("tipLeavesBody"),
        "icon": Icons.health_and_safety_outlined,
      },
      {
        "title": lang.t("tipFertilizerTitle"),
        "tip": lang.t("tipFertilizerBody"),
        "icon": Icons.eco_outlined,
      },
      {
        "title": lang.t("tipMarketTitle"),
        "tip": lang.t("tipMarketBody"),
        "icon": Icons.trending_up_rounded,
      },
      {
        "title": lang.t("tipWeedsTitle"),
        "tip": lang.t("tipWeedsBody"),
        "icon": Icons.grass_outlined,
      },
    ];

    final todayIndex = DateTime.now().day % tips.length;
    final todayTip = tips[todayIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDark() ? _cardColor : lightGreen,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _isDark() ? Colors.white12 : const Color(0xffbfe8ce),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: darkGreen,
              borderRadius: BorderRadius.circular(19),
            ),
            child: Icon(
              todayTip["icon"] as IconData,
              color: Colors.white,
              size: 29,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang.t("dailyFarmingTip"),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: darkGreen,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  todayTip["title"] as String,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  todayTip["tip"] as String,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: _subTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _marketAdvisoryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDark() ? _cardColor : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _isDark() ? Colors.white12 : const Color(0xffdceee4),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: const Color(0xfffff3df),
              borderRadius: BorderRadius.circular(19),
            ),
            child: const Icon(
              Icons.analytics_rounded,
              color: orangeColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              context.watch<LanguageProvider>().t("cropPriceTip"),
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: _subTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _weatherAlertCard(dynamic weather) {
    final lang = context.watch<LanguageProvider>();

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/weather"),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _isDark() ? _cardColor : const Color(0xffeffaff),
          border: Border.all(
            color: _isDark() ? Colors.white12 : const Color(0xffb6def7),
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: blueColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.cloudy_snowing,
                color: Colors.white,
                size: 34,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.t("weatherAlert"),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: blueColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    weather.title ?? lang.t("weatherUpdate"),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    weather.description ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: _subTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: blueColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyWeatherCard() {
    final lang = context.watch<LanguageProvider>();

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/weather"),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(
          color: _cardColor,
          border: Border.all(
            color: _isDark() ? Colors.white12 : const Color(0xffdceee4),
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              height: 58,
              width: 58,
              decoration: BoxDecoration(
                color: blueColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.cloud_done_outlined,
                color: blueColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                lang.t("noWeatherAlert"),
                style: TextStyle(
                  fontSize: 15,
                  height: 1.35,
                  fontWeight: FontWeight.w700,
                  color: _subTextColor,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 17,
              color: blueColor,
            ),
          ],
        ),
      ),
    );
  }

  void _handleVoiceAction(
      Map<String, dynamic> action,
      ) {
    final type = action['type']?.toString();
    final target = action['target']?.toString();

    debugPrint(
      'VOICE ACTION RECEIVED: $action',
    );

    if (type == 'navigate' &&
        target == 'my_crops') {
      Navigator.pop(context);

      // Yahan baad mein MyCropsScreen open karenge.
    }
  }

  Widget _errorView() {
    final lang = context.watch<LanguageProvider>();

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 220),
        const Icon(Icons.error_outline, size: 55, color: Colors.red),
        const SizedBox(height: 15),
        Center(
          child: Text(
            lang.t(_errorMessage!),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: ElevatedButton(
            onPressed: _loadDashboardData,
            style: ElevatedButton.styleFrom(
              backgroundColor: darkGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(lang.t("retry")),
          ),
        ),
      ],
    );
  }
}