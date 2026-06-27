import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/crop_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen_one.dart';
import 'screens/onboarding/onboarding_screen_two.dart';
import 'screens/onboarding/onboarding_screen_three.dart';
import 'screens/auth/login_screen.dart';
import 'screens/farmer/farmer_dashboard_screen.dart';
import 'screens/farmer/my_crops_screen.dart';
import 'screens/farmer/add_crop_screen.dart';
import 'providers/inquiry_provider.dart';
import 'screens/farmer/farmer_inquiries_screen.dart';
import 'screens/farmer/edit_crop_screen.dart';
import 'screens/farmer/farmer_profile_screen.dart';
import 'providers/weather_provider.dart';
import 'screens/farmer/weather_forecast_screen.dart';
import 'providers/price_prediction_provider.dart';
import 'screens/farmer/price_prediction_screen.dart';
import 'providers/disease_detection_provider.dart';
import 'screens/farmer/disease_detection_screen.dart';
import 'screens/buyer/buyer_dashboard_screen.dart';
import 'providers/buyer_favorite_provider.dart';
import 'screens/buyer/buyer_favorites_screen.dart';
import 'providers/buyer_inquiry_provider.dart';
import 'screens/buyer/buyer_inquiries_screen.dart';
import 'providers/buyer_profile_provider.dart';
import 'screens/buyer/buyer_profile_screen.dart';
import 'providers/chat_provider.dart';
import 'screens/farmer/farmer_chats_screen.dart';
void main() {
  runApp(const AgriConnectApp());
}

class AgriConnectApp extends StatelessWidget {
  const AgriConnectApp({super.key});

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
        ChangeNotifierProvider(
          create: (_) => BuyerFavoriteProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BuyerInquiryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BuyerProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/onboarding1': (context) => const OnboardingScreenOne(),
          '/onboarding2': (context) => const OnboardingScreenTwo(),
          '/onboarding3': (context) => const OnboardingScreenThree(),
          '/login': (context) => const LoginScreen(),
          '/farmerDashboard': (context) => const FarmerDashboardScreen(),
          '/myCrops': (context) => const MyCropsScreen(),
          '/addCrop': (context) => const AddCropScreen(),
          '/farmerInquiries': (context) => const FarmerInquiriesScreen(),
          '/editCrop': (context) => const EditCropScreen(),
          '/profile': (context) => const FarmerProfileScreen(),
          '/weather': (_) => const WeatherForecastScreen(),
          '/price-prediction': (_) => const PricePredictionScreen(),
          "/disease-detection": (_) => const DiseaseDetectionScreen(),
          '/buyerDashboard': (context) => const BuyerDashboardScreen(),
          '/buyerFavorites': (context) => const BuyerFavoritesScreen(),
          '/buyer-inquiries': (context) => const BuyerInquiriesScreen(),
          '/buyerProfile': (context) => const BuyerProfileScreen(),
          '/farmerChats': (context) => const FarmerChatsScreen(),


        },
      ),
    );
  }
}