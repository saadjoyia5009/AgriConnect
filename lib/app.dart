import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'providers/auth_provider.dart';
import 'providers/crop_provider.dart';
import 'providers/inquiry_provider.dart';
import 'providers/weather_provider.dart';
import 'providers/price_prediction_provider.dart';
import 'providers/disease_detection_provider.dart';
import 'providers/buyer_favorite_provider.dart';
import 'providers/buyer_inquiry_provider.dart';
import 'providers/buyer_profile_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/admin_dashboard_provider.dart';
import 'providers/admin_users_provider.dart';
import 'providers/admin_crops_provider.dart';
import 'providers/admin_analytics_provider.dart';
import 'providers/admin_reports_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';

import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen_one.dart';
import 'screens/onboarding/onboarding_screen_two.dart';
import 'screens/onboarding/onboarding_screen_three.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/forgot_password_screen.dart';

import 'screens/farmer/farmer_dashboard_screen.dart';
import 'screens/farmer/my_crops_screen.dart';
import 'screens/farmer/add_crop_screen.dart';
import 'screens/farmer/farmer_inquiries_screen.dart';
import 'screens/farmer/edit_crop_screen.dart';
import 'screens/farmer/farmer_profile_screen.dart';
import 'screens/farmer/weather_forecast_screen.dart';
import 'screens/farmer/price_prediction_screen.dart';
import 'screens/farmer/disease_detection_screen.dart';
import 'screens/farmer/farmer_chats_screen.dart';
import 'screens/farmer/farmer_notification_screen.dart';

import 'screens/buyer/buyer_dashboard_screen.dart';
import 'screens/buyer/buyer_favorites_screen.dart';
import 'screens/buyer/buyer_inquiries_screen.dart';
import 'screens/buyer/buyer_profile_screen.dart';

import 'screens/admin/admin_main_screen.dart';
import 'screens/admin/admin_users_screen.dart';
import 'screens/admin/admin_crops_screen.dart';
import 'screens/admin/admin_analytics_screen.dart';
import 'screens/admin/admin_reports_screen.dart';
import 'screens/admin/admin_profile_screen.dart';
import 'screens/farmer/edit_profile_screen.dart';
import 'screens/language/language_selection_screen.dart';
import 'config/app_theme.dart';

class AgriConnectApp extends StatelessWidget {
  const AgriConnectApp({super.key});

  Route<dynamic> _animatedRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 420),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    final routes = <String, Widget>{
      '/': const SplashScreen(),
      '/language': const LanguageSelectionScreen(),

      '/onboarding1': const OnboardingScreenOne(),
      '/onboarding2': const OnboardingScreenTwo(),
      '/onboarding3': const OnboardingScreenThree(),

      '/login': const LoginScreen(),
      '/forgotPassword': const ForgotPasswordScreen(),

      '/farmerDashboard': const FarmerDashboardScreen(),
      '/myCrops': const MyCropsScreen(),
      '/addCrop': const AddCropScreen(),
      '/farmerInquiries': const FarmerInquiriesScreen(),
      '/editCrop': const EditCropScreen(),
      '/profile': const FarmerProfileScreen(),
      '/weather': const WeatherForecastScreen(),
      '/price-prediction': const PricePredictionScreen(),
      '/disease-detection': const DiseaseDetectionScreen(),
      '/farmerChats': const FarmerChatsScreen(),
      '/notifications': const FarmerNotificationScreen(),

      '/buyerDashboard': const BuyerDashboardScreen(),
      '/buyerFavorites': const BuyerFavoritesScreen(),
      '/buyer-inquiries': const BuyerInquiriesScreen(),
      '/buyerProfile': const BuyerProfileScreen(),

      '/adminDashboard': const AdminMainScreen(),
      '/adminUsers': const AdminUsersScreen(),
      '/adminCrops': const AdminCropsScreen(),
      '/adminAnalytics': const AdminAnalyticsScreen(),
      '/adminReports': const AdminReportsScreen(),
      '/adminProfile': const AdminProfileScreen(),
      '/editProfile': const EditProfileScreen(),
    };

    return _animatedRoute(
      routes[settings.name] ?? const SplashScreen(),
      settings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CropProvider()),
        ChangeNotifierProvider(create: (_) => InquiryProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => PricePredictionProvider()),
        ChangeNotifierProvider(create: (_) => DiseaseDetectionProvider()),
        ChangeNotifierProvider(create: (_) => BuyerFavoriteProvider()),
        ChangeNotifierProvider(create: (_) => BuyerInquiryProvider()),
        ChangeNotifierProvider(create: (_) => BuyerProfileProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => AdminDashboardProvider()),
        ChangeNotifierProvider(create: (_) => AdminUsersProvider()),
        ChangeNotifierProvider(create: (_) => AdminCropsProvider()),
        ChangeNotifierProvider(create: (_) => AdminAnalyticsProvider()),
        ChangeNotifierProvider(create: (_) => AdminReportsProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()..loadLanguage()),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: _generateRoute,

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

            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
          );
        },
      ),
    );
  }
}