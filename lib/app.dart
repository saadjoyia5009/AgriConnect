import 'package:agriconnect/providers/voice_assistant_provider.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';
import 'core/responsive/app_breakpoints.dart';
import 'providers/admin_analytics_provider.dart';
import 'providers/admin_crops_provider.dart';
import 'providers/admin_dashboard_provider.dart';
import 'providers/admin_reports_provider.dart';
import 'providers/admin_users_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/buyer_chat_provider.dart';
import 'providers/buyer_favorite_provider.dart';
import 'providers/buyer_inquiry_provider.dart';
import 'providers/buyer_language_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/crop_provider.dart';
import 'providers/disease_detection_provider.dart';
import 'providers/inquiry_provider.dart';
import 'providers/language_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/price_prediction_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/weather_provider.dart';
import 'screens/admin/admin_support_screen.dart';

import 'screens/admin/admin_analytics_screen.dart';
import 'screens/admin/admin_crops_screen.dart';
import 'screens/admin/admin_main_screen.dart';
import 'screens/admin/admin_profile_screen.dart';
import 'screens/admin/admin_reports_screen.dart';
import 'screens/admin/admin_users_screen.dart';
import 'providers/admin_profile_provider.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/login_screen.dart';

import 'screens/buyer/buyer_chats_screen.dart';
import 'screens/buyer/buyer_dashboard_screen.dart';
import 'screens/buyer/buyer_favorites_screen.dart';
import 'screens/buyer/buyer_inquiries_screen.dart';
import 'screens/buyer/buyer_language_scope.dart';
import 'screens/buyer/buyer_profile_screen.dart';

import 'screens/farmer/add_crop_screen.dart';
import 'screens/farmer/disease_detection_screen.dart';
import 'screens/farmer/edit_crop_screen.dart';
import 'screens/farmer/edit_profile_screen.dart';
import 'screens/farmer/farmer_chats_screen.dart';
import 'screens/farmer/farmer_dashboard_screen.dart';
import 'screens/farmer/farmer_inquiries_screen.dart';
import 'screens/farmer/farmer_notification_screen.dart';
import 'screens/farmer/farmer_profile_screen.dart';
import 'screens/farmer/my_crops_screen.dart';
import 'screens/farmer/price_prediction_screen.dart';
import 'screens/farmer/weather_forecast_screen.dart';

import 'screens/language/language_selection_screen.dart';
import 'screens/support/customer_support_screen.dart';
import 'providers/support_provider.dart';

import 'screens/onboarding/onboarding_screen_one.dart';
import 'screens/onboarding/onboarding_screen_three.dart';
import 'screens/onboarding/onboarding_screen_two.dart';

import 'screens/splash/splash_screen.dart';

class AgriConnectApp extends StatelessWidget {
  const AgriConnectApp({super.key});

  Route<dynamic> _animatedRoute(
      Widget page,
      RouteSettings settings,
      ) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(
        milliseconds: 420,
      ),
      reverseTransitionDuration: const Duration(
        milliseconds: 280,
      ),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (
          _,
          animation,
          secondaryAnimation,
          child,
          ) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }

  Route<dynamic> _generateRoute(
      RouteSettings settings,
      ) {
    // [TRACE-12] _generateRoute receives settings.name
    debugPrint('[NAV-TRACE-12] _generateRoute called with settings.name="${settings.name}"');

    Widget buyerPage(Widget child) {
      return BuyerLanguageScope(
        child: child,
      );
    }

    final routes = <String, Widget>{
      '/': const SplashScreen(),
      '/language': const LanguageSelectionScreen(),

      '/onboarding1': const OnboardingScreenOne(),
      '/onboarding2': const OnboardingScreenTwo(),
      '/onboarding3': const OnboardingScreenThree(),

      '/login': const LoginScreen(),
      '/forgotPassword': const ForgotPasswordScreen(),

      '/farmerDashboard':
      const FarmerDashboardScreen(),
      '/myCrops': const MyCropsScreen(),
      '/addCrop': const AddCropScreen(),
      '/farmerInquiries':
      const FarmerInquiriesScreen(),
      '/editCrop': const EditCropScreen(),
      '/profile': const FarmerProfileScreen(),
      '/editProfile': const EditProfileScreen(),
      '/weather': const WeatherForecastScreen(),
      '/price-prediction':
      const PricePredictionScreen(),
      '/disease-detection':
      const DiseaseDetectionScreen(),
      '/farmerChats': const FarmerChatsScreen(),
      '/notifications':
      const FarmerNotificationScreen(),
      '/customerSupport': const CustomerSupportScreen(),

      '/buyerDashboard': buyerPage(
        const BuyerDashboardScreen(),
      ),
      '/buyerFavorites': buyerPage(
        const BuyerFavoritesScreen(),
      ),
      '/buyer-inquiries': buyerPage(
        const BuyerInquiriesScreen(),
      ),
      '/buyerProfile': buyerPage(
        const BuyerProfileScreen(),
      ),
      '/buyerChats': buyerPage(
        const BuyerChatsScreen(),
      ),

      '/adminDashboard': const _AdminRouteGuard(
        child: AdminMainScreen(),
      ),
      '/adminUsers': const _AdminRouteGuard(
        child: AdminUsersScreen(),
      ),
      '/adminCrops': const _AdminRouteGuard(
        child: AdminCropsScreen(),
      ),
      '/adminAnalytics':
      const _AdminRouteGuard(
        child: AdminAnalyticsScreen(),
      ),
      '/adminReports': const _AdminRouteGuard(
        child: AdminReportsScreen(),
      ),
      '/adminProfile': const _AdminRouteGuard(
        child: AdminProfileScreen(),
      ),
      '/adminSupport': const _AdminRouteGuard(
        child: AdminSupportScreen(),
      ),
    };

    final matched = routes[settings.name];
    debugPrint('[NAV-TRACE-12b] route lookup for "${settings.name}": ${matched != null ? "FOUND (${matched.runtimeType})" : "NOT FOUND — falling back to SplashScreen"}');

    return _animatedRoute(
      matched ?? const SplashScreen(),
      settings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BuyerChatProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => VoiceAssistantProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),

        // Farmer profile backend integration
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdminProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CropProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => InquiryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PricePredictionProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DiseaseDetectionProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BuyerFavoriteProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BuyerInquiryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdminDashboardProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdminUsersProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdminCropsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdminAnalyticsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdminReportsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BuyerLanguageProvider(
            initialLocale: const Locale('en'),
          )..loadLanguage(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
          LanguageProvider()..loadLanguage(),
        ),
        ChangeNotifierProvider(
          create: (_) => SupportProvider(),
        ),
      ],
      child: Consumer2<
          ThemeProvider,
          LanguageProvider
      >(
        builder: (
            context,
            themeProvider,
            languageProvider,
            child,
            ) {
          final fontFamily = languageProvider.isUrdu
              ? 'NotoNastaliqUrdu'
              : 'Poppins';

          final lightTheme =
          AppTheme.lightTheme.copyWith(
            textTheme:
            AppTheme.lightTheme.textTheme.apply(
              fontFamily: fontFamily,
            ),
            primaryTextTheme: AppTheme
                .lightTheme
                .primaryTextTheme
                .apply(
              fontFamily: fontFamily,
            ),
          );

          final darkTheme = AppTheme.darkTheme.copyWith(
            textTheme:
            AppTheme.darkTheme.textTheme.apply(
              fontFamily: fontFamily,
            ),
            primaryTextTheme: AppTheme
                .darkTheme
                .primaryTextTheme
                .apply(
              fontFamily: fontFamily,
            ),
          );

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: _generateRoute,
            builder: (context, child) {
              final page =
                  child ?? const SizedBox.shrink();

              return LayoutBuilder(
                builder: (context, constraints) {
                  if (
                  !AppBreakpoints.isDesktopWidth(
                    constraints.maxWidth,
                  )
                  ) {
                    return page;
                  }

                  return ColoredBox(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor,
                    child: Center(
                      child: ConstrainedBox(
                        constraints:
                        const BoxConstraints(
                          maxWidth: AppBreakpoints
                              .maxContentWidth,
                        ),
                        child: page,
                      ),
                    ),
                  );
                },
              );
            },
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: languageProvider.locale,
            supportedLocales: const [
              Locale('en'),
              Locale('ur'),
            ],
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode,
          );
        },
      ),
    );
  }
}

class _AdminRouteGuard extends StatelessWidget {
  final Widget child;

  const _AdminRouteGuard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final role = context.select<AuthProvider, String>(
          (provider) => provider.role.trim().toLowerCase(),
    );

    if (role == 'admin') {
      return child;
    }

    return const LoginScreen();
  }
}
