import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

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

import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen_one.dart';
import 'screens/onboarding/onboarding_screen_two.dart';
import 'screens/onboarding/onboarding_screen_three.dart';
import 'screens/auth/login_screen.dart';

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

import 'screens/buyer/buyer_dashboard_screen.dart';
import 'screens/buyer/buyer_favorites_screen.dart';
import 'screens/buyer/buyer_inquiries_screen.dart';
import 'screens/buyer/buyer_profile_screen.dart';

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
      '/onboarding1': const OnboardingScreenOne(),
      '/onboarding2': const OnboardingScreenTwo(),
      '/onboarding3': const OnboardingScreenThree(),
      '/login': const LoginScreen(),

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

      '/buyerDashboard': const BuyerDashboardScreen(),
      '/buyerFavorites': const BuyerFavoritesScreen(),
      '/buyer-inquiries': const BuyerInquiriesScreen(),
      '/buyerProfile': const BuyerProfileScreen(),
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
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<CropProvider>(
          create: (_) => CropProvider(),
        ),
        ChangeNotifierProvider<InquiryProvider>(
          create: (_) => InquiryProvider(),
        ),
        ChangeNotifierProvider<WeatherProvider>(
          create: (_) => WeatherProvider(),
        ),
        ChangeNotifierProvider<PricePredictionProvider>(
          create: (_) => PricePredictionProvider(),
        ),
        ChangeNotifierProvider<DiseaseDetectionProvider>(
          create: (_) => DiseaseDetectionProvider(),
        ),
        ChangeNotifierProvider<BuyerFavoriteProvider>(
          create: (_) => BuyerFavoriteProvider(),
        ),
        ChangeNotifierProvider<BuyerInquiryProvider>(
          create: (_) => BuyerInquiryProvider(),
        ),
        ChangeNotifierProvider<BuyerProfileProvider>(
          create: (_) => BuyerProfileProvider(),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (_) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: _generateRoute,
      ),
    );
  }
}