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

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/onboarding1': (context) => const OnboardingScreenOne(),
          '/onboarding2': (context) => const OnboardingScreenTwo(),
          '/onboarding3': (context) => const OnboardingScreenThree(),
          '/login': (context) => LoginScreen(),
          '/farmerDashboard': (context) => const FarmerDashboardScreen(),
          '/myCrops': (context) => const MyCropsScreen(),
          '/addCrop': (context) => const AddCropScreen(),
          '/farmerInquiries': (context) => const FarmerInquiriesScreen(),
          '/editCrop': (context) => const EditCropScreen(),
          '/profile': (context) => const FarmerProfileScreen(),
        },
      ),
    );
  }
}