import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen_one.dart';
import 'screens/onboarding/onboarding_screen_two.dart';
import 'screens/onboarding/onboarding_screen_three.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const AgriConnectApp());
}

class AgriConnectApp extends StatelessWidget {
  const AgriConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
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
        },
      ),
    );
  }
}