import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/crop_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/farmer_bottom_navbar.dart';
import '../../widgets/voice_assistant_sheet.dart';
import '../../widgets/farmer_dashboard/dashboard_content.dart';
import '../../widgets/farmer_dashboard/dashboard_colors.dart';
import '../../widgets/farmer_dashboard/dashboard_error_view.dart';
import 'farmer_notification_screen.dart';
import 'farmer_top_bar.dart';

class FarmerDashboardScreen extends StatefulWidget {
  const FarmerDashboardScreen({super.key});

  @override
  State<FarmerDashboardScreen> createState() => _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState extends State<FarmerDashboardScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  final String _voiceText = "";
  bool _isNavigatingFromVoiceAction = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadDashboardData);
  }

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

  Future<void> _handleVoiceAction(
      Map<String, dynamic> action,
      ) async {
    debugPrint(
      '[NAV-TRACE-7] _handleVoiceAction entered, mounted=$mounted, '
          '_isNavigatingFromVoiceAction=$_isNavigatingFromVoiceAction',
    );

    if (!mounted || _isNavigatingFromVoiceAction) {
      debugPrint(
        '[NAV-TRACE-7b] ABORT: mounted=$mounted, '
            '_isNavigatingFromVoiceAction=$_isNavigatingFromVoiceAction',
      );
      return;
    }

    final type = action['type']?.toString();
    final target = action['target']?.toString();

    debugPrint('VOICE ACTION RECEIVED: $action');
    debugPrint('[NAV-TRACE-7c] type=$type  target=$target');

    if (type != 'navigate' && type != 'open_add_crop') {
      debugPrint(
        '[NAV-TRACE-7d] ABORT: type "$type" does not match '
            'navigate/open_add_crop',
      );
      return;
    }

    final routeName = switch (target) {
      'add_crop' => '/addCrop',
      'my_crops' => '/myCrops',
      'chat' => '/farmerChats',
      _ => null,
    };

    debugPrint('[NAV-TRACE-8] routeName resolved to: $routeName');

    if (routeName != null) {
      _isNavigatingFromVoiceAction = true;

      final nav = Navigator.of(
        context,
        rootNavigator: true,
      );

      debugPrint(
        '[NAV-TRACE-9] navigator=$nav '
            'canPop=${nav.canPop()}',
      );

      debugPrint(
        '[NAV-TRACE-9b] exact route being pushed: $routeName',
      );

      debugPrint(
        '[NAV-TRACE-10] >>> calling pushNamed("$routeName") NOW',
      );

      final arguments = target == 'chat'
          ? <String, dynamic>{
        'openedByVoiceAssistant': true,
      }
          : null;

      nav.pushNamed(
        routeName,
        arguments: arguments,
      ).whenComplete(() {
        debugPrint(
          '[NAV-TRACE-10b] pushNamed("$routeName") whenComplete fired',
        );

        if (mounted) {
          _isNavigatingFromVoiceAction = false;
        }
      });

      debugPrint(
        '[NAV-TRACE-11] pushNamed("$routeName") called — future is pending',
      );

      return;
    }

    switch (target) {
      case 'farmer_dashboard':
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/farmerDashboard',
              (route) => false,
        );
        break;

      default:
        debugPrint('Unknown voice navigation target: $target');
    }
  }

  bool _isDark() =>
      Theme.of(context).brightness == Brightness.dark;

  Color get _cardColor => Theme.of(context).cardColor;

  Color get _textColor =>
      Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

  Color get _subTextColor =>
      _isDark() ? Colors.white70 : const Color(0xff64706a);

  Color get _softBorderColor =>
      _isDark() ? Colors.white12 : const Color(0xffd3ead9);

  List<Map<String, dynamic>> _dailyTips(LanguageProvider lang) => [
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

  @override
  Widget build(BuildContext context) {
    final cropProvider = context.watch<CropProvider>();
    final lang = context.watch<LanguageProvider>();

    return Directionality(
      textDirection:
      lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: _isDark()
            ? Theme.of(context).scaffoldBackgroundColor
            : const Color(0xfff7faf8),
        appBar: FarmerTopBar(
          title: lang.t("dashboard"),
          onNotificationTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const FarmerNotificationScreen(),
              ),
            );
          },
        ),
        bottomNavigationBar:
        const FarmerBottomNavbar(currentIndex: 0),
        body: SafeArea(
          child: RefreshIndicator(
            color: DashboardColors.darkGreen,
            onRefresh: _loadDashboardData,
            child: _isLoading
                ? const Center(
              child: CircularProgressIndicator(
                color: DashboardColors.darkGreen,
              ),
            )
                : _errorMessage != null
                ? DashboardErrorView(
              message: lang.t(_errorMessage!),
              retryText: lang.t("retry"),
              textColor: _textColor,
              onRetry: _loadDashboardData,
            )
                : DashboardContent(
              cropProvider: cropProvider,
              lang: lang,
              isDark: _isDark(),
              cardColor: _cardColor,
              textColor: _textColor,
              subTextColor: _subTextColor,
              softBorderColor: _softBorderColor,
              voiceText: _voiceText,
              onVoiceTap: _openVoiceAssistant,
              dailyTips: _dailyTips(lang),
            ),
          ),
        ),
      ),
    );
  }
}