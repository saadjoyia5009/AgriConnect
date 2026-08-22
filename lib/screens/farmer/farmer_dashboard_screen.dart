import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import '../../providers/crop_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/farmer_bottom_navbar.dart';
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
  State<FarmerDashboardScreen> createState() =>
      _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState extends State<FarmerDashboardScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color darkGreen = Color(0xff075739);
  static const Color primaryGreen = Color(0xff178447);
  static const Color mediumGreen = Color(0xff2d7153);
  static const Color lightGreen = Color(0xffe8f7ef);

  static const Color blueColor = Color(0xff168ad1);
  static const Color orangeColor = Color(0xffffa41b);
  static const Color purpleColor = Color(0xff7251c7);
  static const Color redColor = Color(0xffdf514d);

  bool _isLoading = false;
  String? _errorMessage;

  String _voiceText = "";

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void initState() {
    super.initState();

    Future.microtask(_loadDashboardData);
  }

  // ============================================================
  // EXISTING DASHBOARD LOGIC
  // ============================================================

  Future<void> _loadDashboardData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      await context.read<CropProvider>().fetchFarmerDashboard();

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = "failedLoadDashboard";
      });
    }
  }

  // ============================================================
  // VOICE ASSISTANT
  // ============================================================

  void _openVoiceAssistant() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return VoiceAssistantSheet(
          onAction: _handleVoiceAction,
        );
      },
    );
  }

  void _handleVoiceAction(Map<String, dynamic> action) {
    final type = action['type']?.toString();
    final target = action['target']?.toString();

    debugPrint('VOICE ACTION RECEIVED: $action');

    if (type != 'navigate' && type != 'open_add_crop') {
      return;
    }

    switch (target) {
      case 'add_crop':
        Navigator.pushNamed(
          context,
          '/addCrop',
        );
        break;

      case 'my_crops':
        Navigator.pushNamed(
          context,
          '/myCrops',
        );
        break;

      case 'farmer_dashboard':
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/farmerDashboard',
          (route) => false,
        );
        break;

      default:
        debugPrint(
          'Unknown voice navigation target: $target',
        );
    }
  }

  // ============================================================
  // THEME HELPERS
  // ============================================================

  bool _isDark() {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color get _cardColor {
    return Theme.of(context).cardColor;
  }

  Color get _textColor {
    return Theme.of(context).textTheme.bodyLarge?.color ??
        Colors.black;
  }

  Color get _subTextColor {
    return _isDark()
        ? Colors.white70
        : const Color(0xff64706a);
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final cropProvider = context.watch<CropProvider>();
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: _isDark()
          ? Theme.of(context).scaffoldBackgroundColor
          : const Color(0xfff7faf8),

      appBar: FarmerTopBar(
        title: lang.t("dashboard"),
        onNotificationTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const FarmerNotificationScreen(),
            ),
          );
        },
      ),

      bottomNavigationBar:
          const FarmerBottomNavbar(currentIndex: 0),

      body: SafeArea(
        child: RefreshIndicator(
          color: darkGreen,
          onRefresh: _loadDashboardData,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: darkGreen,
                  ),
                )
              : _errorMessage != null
                  ? _errorView()
                  : SingleChildScrollView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        18,
                        16,
                        18,
                        30,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          // ------------------------------------------------
                          // OVERVIEW
                          // ------------------------------------------------

                          _farmerOverview(
                            lang: lang,
                            activeCrops:
                                cropProvider.activeCrops,
                            newInquiries:
                                cropProvider.newInquiries,
                          ),

                          const SizedBox(height: 28),

                          // ------------------------------------------------
                          // QUICK ACTIONS
                          // ------------------------------------------------

                          _sectionHeader(
                            title: "Quick Actions",
                            showViewAll: true,
                          ),

                          const SizedBox(height: 14),

                          _quickActions(),

                          const SizedBox(height: 26),

                          // ------------------------------------------------
                          // ATTENTION NEEDED
                          // ------------------------------------------------

                          _attentionNeeded(
                            newInquiries:
                                cropProvider.newInquiries,
                            weatherAlert:
                                cropProvider.weatherAlert,
                          ),

                          const SizedBox(height: 26),

                          // ------------------------------------------------
                          // MARKET + WEATHER
                          // ------------------------------------------------

                          LayoutBuilder(
                            builder:
                                (context, constraints) {
                              if (constraints.maxWidth >=
                                  720) {
                                return Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                   
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child:
                                          _weatherToday(
                                        cropProvider
                                            .weatherAlert,
                                      ),
                                    ),
                                  ],
                                );
                              }

                              return Column(
                                children: [
                                  
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  _weatherToday(
                                    cropProvider
                                        .weatherAlert,
                                  ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          // ------------------------------------------------
                          // AI FARMING INSIGHT
                          // ------------------------------------------------

                          _aiFarmingInsight(
                            weatherAlert:
                                cropProvider.weatherAlert,
                          ),

                          const SizedBox(height: 20),

                          // ------------------------------------------------
                          // DAILY TIP
                          // ------------------------------------------------

                          _dailyFarmingTip(),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  // ============================================================
  // FARMER OVERVIEW
  // ============================================================

  Widget _farmerOverview({
    required LanguageProvider lang,
    required int activeCrops,
    required int newInquiries,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xffeaf8ef),
            Color(0xfff8fcf9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xffb7dfc3),
        ),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative background
          Positioned(
            right: -25,
            bottom: 35,
            child: Icon(
              Icons.landscape_rounded,
              size: 180,
              color: primaryGreen.withOpacity(0.07),
            ),
          ),

          Positioned(
            right: 22,
            top: 20,
            child: Icon(
              Icons.eco_rounded,
              size: 75,
              color: primaryGreen.withOpacity(0.08),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // ----------------------------------------------------------
                // GREETING + BUTTONS
                // ----------------------------------------------------------

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang.t("welcomeBackComma"),
                            style: TextStyle(
                              color: darkGreen,
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.w900,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Grow smarter. Sell better.",
                            style: TextStyle(
                              color: _subTextColor,
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Notification
                  

                    const SizedBox(width: 8),

                    // Voice
                    _roundHeaderButton(
                      icon: Icons.mic_none_rounded,
                      background:
                          darkGreen,
                      iconColor:
                          Colors.white,
                      onTap:
                          _openVoiceAssistant,
                    ),
                  ],
                ),

                // Voice response
                if (_voiceText.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          Colors.white.withOpacity(0.75),
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Text(
                      _voiceText,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        color: darkGreen,
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 22),

                // ----------------------------------------------------------
                // MAIN STATS
                // ----------------------------------------------------------

                Row(
                  children: [
                    Expanded(
                      child: _overviewStat(
                        icon:
                            Icons.eco_rounded,
                        value:
                            activeCrops.toString(),
                        title:
                            "Active Crops",
                        iconColor:
                            primaryGreen,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: _overviewStat(
                        icon:
                            Icons.chat_bubble_rounded,
                        value:
                            newInquiries.toString(),
                        title:
                            "Inquiries",
                        iconColor:
                            orangeColor,
                        showBadge:
                            newInquiries > 0,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ----------------------------------------------------------
                // SMALL INFORMATION ROW
                // ----------------------------------------------------------

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.82),
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child:
                            _overviewInfo(
                          icon:
                              Icons.calendar_month_rounded,
                          title:
                              "This Season",
                          value:
                              "Good Progress",
                          iconColor:
                              primaryGreen,
                        ),
                      ),

                      _verticalDivider(),

                      Expanded(
                        child:
                            _overviewInfo(
                          icon:
                              Icons.trending_up_rounded,
                          title:
                              "Price Trend",
                          value:
                              "Rising",
                          iconColor:
                              orangeColor,
                        ),
                      ),

                      _verticalDivider(),

                      Expanded(
                        child:
                            GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/weather",
                            );
                          },
                          child:
                              _overviewInfo(
                            icon:
                                Icons.cloud_outlined,
                            title:
                                "Weather",
                            value:
                                "Check Now",
                            iconColor:
                                blueColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER ROUND BUTTON
  // ============================================================

  Widget _roundHeaderButton({
    required IconData icon,
    required VoidCallback onTap,
    Color background = Colors.white,
    Color iconColor = darkGreen,
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    darkGreen.withOpacity(0.10),
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset:
                      const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),

          if (badge != null)
            Positioned(
              right: -2,
              top: -4,
              child: Container(
                padding:
                    const EdgeInsets.all(5),
                constraints:
                    const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                decoration:
                    const BoxDecoration(
                  color: Color(0xffdf4646),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badge,
                  textAlign:
                      TextAlign.center,
                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // OVERVIEW STAT
  // ============================================================

  Widget _overviewStat({
    required IconData icon,
    required String value,
    required String title,
    required Color iconColor,
    bool showBadge = false,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white
            .withOpacity(0.82),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xffd3ead9),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: iconColor
                  .withOpacity(0.11),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 23,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style:
                      const TextStyle(
                    color: darkGreen,
                    fontSize: 25,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                Text(
                  title,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        _subTextColor,
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // OVERVIEW SMALL INFO
  // ============================================================

  Widget _overviewInfo({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 25,
          ),
          const SizedBox(height: 7),
          Text(
            title,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _subTextColor,
              fontSize: 10,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style:
                TextStyle(
              color: iconColor,
              fontSize: 11.5,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 50,
      width: 1,
      color: const Color(0xffd6e7dc),
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _sectionHeader({
    required String title,
    bool showViewAll = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: _textColor,
              fontSize: 18,
              fontWeight:
                  FontWeight.w900,
              letterSpacing: 0.2,
            ),
          ),
        ),

        if (showViewAll)
          GestureDetector(
            onTap: () {
              // Existing section does not
              // have a dedicated "view all"
              // route, so no logic is changed.
            },
            child: Row(
              children: [
                Text(
                  "View All",
                  style:
                      const TextStyle(
                    color: darkGreen,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: darkGreen,
                  size: 12,
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ============================================================
  // QUICK ACTIONS
  // ============================================================

  Widget _quickActions() {
    final actions = [
      _ActionData(
        icon: Icons.eco_rounded,
        title: "Add Crop",
        subtitle: "Create New Listing",
        iconColor: primaryGreen,
        background:
            const Color(0xfff1faef),
        screen:
            const AddCropScreen(),
      ),

      _ActionData(
        icon: Icons.grass_rounded,
        title: "My Crops",
        subtitle: "Manage Your Crops",
        iconColor: orangeColor,
        background:
            const Color(0xfffff8ed),
        onTap: () {
          Navigator.pushNamed(
            context,
            "/myCrops",
          );
        },
      ),

      _ActionData(
        icon:
            Icons.trending_up_rounded,
        title: "Price AI",
        subtitle: "AI Price Prediction",
        iconColor: purpleColor,
        background:
            const Color(0xfff7f1ff),
        screen:
            const PricePredictionScreen(),
      ),

      _ActionData(
        icon:
            Icons.cloud_outlined,
        title: "Weather",
        subtitle: "Check Weather Forecast",
        iconColor: blueColor,
        background:
            const Color(0xffeff8ff),
        screen:
            const WeatherForecastScreen(),
      ),
    ];

    return LayoutBuilder(
      builder:
          (context, constraints) {
        int columns;

        if (constraints.maxWidth >= 900) {
          columns = 4;
        } else if (constraints.maxWidth >=
            600) {
          columns = 4;
        } else {
          columns = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                columns,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio:
                columns == 2
                    ? 1.08
                    : 1.05,
          ),
          itemBuilder:
              (context, index) {
            return _quickActionCard(
              action: actions[index],
            );
          },
        );
      },
    );
  }

  Widget _quickActionCard({
    required _ActionData action,
  }) {
    return OpenContainer(
      transitionDuration:
          const Duration(
        milliseconds: 350,
      ),
      closedElevation: 0,
      openElevation: 0,
      closedColor:
          Colors.transparent,
      openColor:
          Theme.of(context)
              .scaffoldBackgroundColor,
      closedBuilder:
          (context, openContainer) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius:
                BorderRadius.circular(20),
            onTap: action.onTap ??
                openContainer,
            child: Container(
              padding:
                  const EdgeInsets.all(12),
              decoration:
                  BoxDecoration(
                color: _isDark()
                    ? _cardColor
                    : action.background,
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
                border: Border.all(
                  color: action.iconColor
                      .withOpacity(0.18),
                ),
              ),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration:
                        BoxDecoration(
                      color: action.iconColor
                          .withOpacity(
                        0.11,
                      ),
                      shape:
                          BoxShape.circle,
                    ),
                    child: Icon(
                      action.icon,
                      color:
                          action.iconColor,
                      size: 27,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    action.title,
                    textAlign:
                        TextAlign.center,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _textColor,
                      fontSize: 13,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    action.subtitle,
                    textAlign:
                        TextAlign.center,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                          _subTextColor,
                      fontSize: 10.5,
                      height: 1.2,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      openBuilder:
          (context, _) =>
              action.screen ??
              const SizedBox.shrink(),
    );
  }

  // ============================================================
  // ATTENTION NEEDED
  // ============================================================

  Widget _attentionNeeded({
    required int newInquiries,
    required dynamic weatherAlert,
  }) {
    final items = <_AttentionData>[];

    if (newInquiries > 0) {
      items.add(
        _AttentionData(
          icon:
              Icons.chat_bubble_rounded,
          iconColor: primaryGreen,
          text:
              "$newInquiries buyer ${newInquiries == 1 ? "inquiry needs" : "inquiries need"} your response",
          onTap: () {
            Navigator.pushNamed(
              context,
              "/myCrops",
            );
          },
        ),
      );
    }


    if (weatherAlert != null) {
      items.add(
        _AttentionData(
          icon:
              Icons.cloud_outlined,
          iconColor: blueColor,
          text:
              weatherAlert.title ??
                  "Weather alert available",
          onTap: () {
            Navigator.pushNamed(
              context,
              "/weather",
            );
          },
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _isDark()
            ? _cardColor
            : const Color(0xfffffaf1),
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: _isDark()
              ? Colors.white12
              : const Color(0xffffdfaa),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "ATTENTION NEEDED",
                  style:
                      const TextStyle(
                    color: Color(0xff8c4710),
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),

              Container(
                height: 38,
                width: 38,
                decoration:
                    BoxDecoration(
                  color: orangeColor
                      .withOpacity(0.10),
                  shape:
                      BoxShape.circle,
                ),
                child:
                    const Icon(
                  Icons.priority_high_rounded,
                  color: orangeColor,
                  size: 22,
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xff8c4710),
                size: 14,
              ),
            ],
          ),

          const SizedBox(height: 14),

          ...items.map(
            (item) =>
                _attentionItem(item),
          ),
        ],
      ),
    );
  }

  Widget _attentionItem(
    _AttentionData item,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 8,
      ),
      child: Material(
        color: _isDark()
            ? Colors.white.withOpacity(
                0.04,
              )
            : Colors.white,
        borderRadius:
            BorderRadius.circular(14),
        child: InkWell(
          onTap: item.onTap,
          borderRadius:
              BorderRadius.circular(14),
          child: Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 13,
            ),
            decoration:
                BoxDecoration(
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
              border: Border.all(
                color: _isDark()
                    ? Colors.white12
                    : const Color(
                        0xffffe5c0,
                      ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 36,
                  width: 36,
                  decoration:
                      BoxDecoration(
                    color: item.iconColor
                        .withOpacity(0.10),
                    shape:
                        BoxShape.circle,
                  ),
                  child: Icon(
                    item.icon,
                    color:
                        item.iconColor,
                    size: 19,
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(
                  child: Text(
                    item.text,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                          _textColor,
                      fontSize: 12.5,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),

                const Icon(
                  Icons
                      .arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(
                    0xff777777,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 

  // ============================================================
  // WEATHER TODAY
  // ============================================================

  Widget _weatherToday(
    dynamic weather,
  ) {
    final hasAlert =
        weather != null;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/weather",
        );
      },
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _isDark()
              ? _cardColor
              : const Color(0xfff4fbff),
          borderRadius:
              BorderRadius.circular(22),
          border: Border.all(
            color: _isDark()
                ? Colors.white12
                : const Color(0xffcce5f5),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "WEATHER TODAY",
                    style:
                        TextStyle(
                      color: Color(
                        0xff14567d,
                      ),
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ),

                const Text(
                  "View Forecast",
                  style:
                      TextStyle(
                    color: blueColor,
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  width: 4,
                ),

                const Icon(
                  Icons
                      .arrow_forward_ios_rounded,
                  color: blueColor,
                  size: 11,
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Container(
                  height: 62,
                  width: 62,
                  decoration:
                      BoxDecoration(
                    color: Colors.white,
                    shape:
                        BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: blueColor
                            .withOpacity(
                          0.10,
                        ),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child:
                      const Icon(
                    Icons
                        .wb_sunny_rounded,
                    color:
                        Color(0xffffb52e),
                    size: 38,
                  ),
                ),

                const SizedBox(
                  width: 13,
                ),

                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        "31°C",
                        style:
                            TextStyle(
                          color: Color(
                            0xff176eab,
                          ),
                          fontSize: 30,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                      Text(
                        "Lahore, Punjab",
                        style:
                            TextStyle(
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Sunny",
                        style:
                            TextStyle(
                          color:
                              Colors.grey,
                          fontSize: 11,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child:
                      _weatherMetric(
                    icon: Icons
                        .water_drop_outlined,
                    title: "Humidity",
                    value: "62%",
                  ),
                ),

                Expanded(
                  child:
                      _weatherMetric(
                    icon: Icons
                        .air_rounded,
                    title: "Wind",
                    value:
                        "12 km/h",
                  ),
                ),

                Expanded(
                  child:
                      _weatherMetric(
                    icon: Icons
                        .water_drop_rounded,
                    title: "Rain",
                    value: "20%",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(
                vertical: 9,
              ),
              decoration:
                  BoxDecoration(
                color: blueColor
                    .withOpacity(0.08),
                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
              ),
              child:
                  Text(
                hasAlert
                    ? "Weather update available"
                    : "Good conditions for field work",
                textAlign:
                    TextAlign.center,
                style:
                    const TextStyle(
                  color: blueColor,
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _weatherMetric({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: blueColor,
          size: 18,
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            color:
                _subTextColor,
            fontSize: 9,
            fontWeight:
                FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style:
              TextStyle(
            color: _textColor,
            fontSize: 10.5,
            fontWeight:
                FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // AI FARMING INSIGHT
  // ============================================================

  Widget _aiFarmingInsight({
    required dynamic weatherAlert,
  }) {
    final title =
        weatherAlert != null
            ? "Rain is expected tomorrow."
            : "Plan your farming activities smarter.";

    final description =
        weatherAlert != null
            ? "Consider reducing irrigation today to avoid overwatering."
            : "Use weather and market information to make better farming decisions.";

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(0xfffaf5ff),
            Color(0xfff6efff),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: const Color(
            0xffdfc9fa,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: purpleColor,
                size: 18,
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  "AI FARMING INSIGHT",
                  style:
                      TextStyle(
                    color: purpleColor,
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),
              const Text(
                "Learn More",
                style:
                    TextStyle(
                  color: purpleColor,
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons
                    .arrow_forward_ios_rounded,
                color: purpleColor,
                size: 11,
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Container(
                height: 62,
                width: 62,
                decoration:
                    BoxDecoration(
                  color: purpleColor
                      .withOpacity(
                    0.10,
                  ),
                  shape:
                      BoxShape.circle,
                ),
                child:
                    const Icon(
                  Icons
                      .psychology_rounded,
                  color: purpleColor,
                  size: 32,
                ),
              ),

              const SizedBox(
                width: 14,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(
                        color:
                            _textColor,
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      description,
                      style:
                          TextStyle(
                        color:
                            _subTextColor,
                        fontSize: 11.5,
                        height: 1.35,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DAILY FARMING TIP
  // ============================================================

  Widget _dailyFarmingTip() {
    final lang =
        context.watch<LanguageProvider>();

    final tips = [
      {
        "title":
            lang.t("tipWaterTitle"),
        "tip":
            lang.t("tipWaterBody"),
        "icon":
            Icons.water_drop_outlined,
      },
      {
        "title":
            lang.t("tipLeavesTitle"),
        "tip":
            lang.t("tipLeavesBody"),
        "icon":
            Icons
                .health_and_safety_outlined,
      },
      {
        "title":
            lang.t("tipFertilizerTitle"),
        "tip":
            lang.t("tipFertilizerBody"),
        "icon":
            Icons.eco_outlined,
      },
      {
        "title":
            lang.t("tipMarketTitle"),
        "tip":
            lang.t("tipMarketBody"),
        "icon":
            Icons
                .trending_up_rounded,
      },
      {
        "title":
            lang.t("tipWeedsTitle"),
        "tip":
            lang.t("tipWeedsBody"),
        "icon":
            Icons.grass_outlined,
      },
    ];

    final todayIndex =
        DateTime.now().day %
            tips.length;

    final todayTip =
        tips[todayIndex];

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _isDark()
            ? _cardColor
            : const Color(0xfff4fbf2),
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: _isDark()
              ? Colors.white12
              : const Color(0xffcce6c9),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_rounded,
                color: Color(
                  0xffffae1a,
                ),
                size: 19,
              ),

              const SizedBox(
                width: 7,
              ),

              const Expanded(
                child: Text(
                  "DAILY FARMING TIP",
                  style:
                      TextStyle(
                    color: darkGreen,
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),

              const Text(
                "More Tips",
                style:
                    TextStyle(
                  color: darkGreen,
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const SizedBox(
                width: 4,
              ),

              const Icon(
                Icons
                    .arrow_forward_ios_rounded,
                color: darkGreen,
                size: 11,
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Container(
                height: 58,
                width: 58,
                decoration:
                    BoxDecoration(
                  color: primaryGreen
                      .withOpacity(
                    0.10,
                  ),
                  shape:
                      BoxShape.circle,
                ),
                child:
                    Icon(
                  todayTip[
                      "icon"] as IconData,
                  color:
                      primaryGreen,
                  size: 28,
                ),
              ),

              const SizedBox(
                width: 14,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      todayTip[
                          "title"] as String,
                      style:
                          TextStyle(
                        color:
                            _textColor,
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      todayTip[
                          "tip"] as String,
                      maxLines: 3,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          TextStyle(
                        color:
                            _subTextColor,
                        fontSize: 11.5,
                        height: 1.35,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              const Icon(
                Icons
                    .search_rounded,
                color: primaryGreen,
                size: 34,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR VIEW
  // ============================================================

  Widget _errorView() {
    final lang =
        context.watch<LanguageProvider>();

    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(
          height: 220,
        ),

        Container(
          height: 80,
          width: 80,
          margin:
              const EdgeInsets.symmetric(
            horizontal: 150,
          ),
          decoration:
              BoxDecoration(
            color:
                Colors.red.withOpacity(
              0.08,
            ),
            shape:
                BoxShape.circle,
          ),
          child:
              const Icon(
            Icons
                .error_outline_rounded,
            size: 45,
            color: redColor,
          ),
        ),

        const SizedBox(
          height: 18,
        ),

        Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Text(
              lang.t(
                _errorMessage!,
              ),
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                fontSize: 17,
                fontWeight:
                    FontWeight.w700,
                color:
                    _textColor,
              ),
            ),
          ),
        ),

        const SizedBox(
          height: 18,
        ),

        Center(
          child:
              ElevatedButton(
            onPressed:
                _loadDashboardData,
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  darkGreen,
              foregroundColor:
                  Colors.white,
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 28,
                vertical: 13,
              ),
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),
            ),
            child: Text(
              lang.t("retry"),
            ),
          ),
        ),
      ],
    );
  }
}

// ================================================================
// ACTION MODEL
// ================================================================

class _ActionData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color background;
  final Widget? screen;
  final VoidCallback? onTap;

  const _ActionData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.background,
    this.screen,
    this.onTap,
  });
}

// ================================================================
// ATTENTION MODEL
// ================================================================

class _AttentionData {
  final IconData icon;
  final Color iconColor;
  final String text;
  final VoidCallback onTap;

  const _AttentionData({
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.onTap,
  });
}

// ================================================================
// MARKET CHART PAINTER
// ================================================================

class _MarketChartPainter
    extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final linePaint = Paint()
      ..color =
          const Color(0xff4ca95d)
      ..strokeWidth = 2.2
      ..style =
          PaintingStyle.stroke
      ..strokeCap =
          StrokeCap.round;

    final fillPaint = Paint()
      ..shader =
          const LinearGradient(
        colors: [
          Color(0x304ca95d),
          Color(0x004ca95d),
        ],
        begin:
            Alignment.topCenter,
        end:
            Alignment.bottomCenter,
      ).createShader(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ),
      )
      ..style =
          PaintingStyle.fill;

    final points = [
      Offset(
        0,
        size.height * 0.72,
      ),
      Offset(
        size.width * 0.12,
        size.height * 0.58,
      ),
      Offset(
        size.width * 0.22,
        size.height * 0.66,
      ),
      Offset(
        size.width * 0.34,
        size.height * 0.48,
      ),
      Offset(
        size.width * 0.45,
        size.height * 0.50,
      ),
      Offset(
        size.width * 0.57,
        size.height * 0.30,
      ),
      Offset(
        size.width * 0.67,
        size.height * 0.38,
      ),
      Offset(
        size.width * 0.79,
        size.height * 0.13,
      ),
      Offset(
        size.width * 0.91,
        size.height * 0.19,
      ),
      Offset(
        size.width,
        size.height * 0.08,
      ),
    ];

    final path = Path();

    path.moveTo(
      points.first.dx,
      points.first.dy,
    );

    for (int i = 1;
        i < points.length;
        i++) {
      path.lineTo(
        points[i].dx,
        points[i].dy,
      );
    }

    final fillPath =
        Path.from(path);

    fillPath.lineTo(
      size.width,
      size.height,
    );

    fillPath.lineTo(
      0,
      size.height,
    );

    fillPath.close();

    canvas.drawPath(
      fillPath,
      fillPaint,
    );

    canvas.drawPath(
      path,
      linePaint,
    );

    final dotPaint = Paint()
      ..color =
          const Color(0xff4ca95d);

    for (final point in points) {
      canvas.drawCircle(
        point,
        2.8,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}