import 'package:flutter/material.dart';
import 'onboarding_screen_two.dart';

class OnboardingScreenOne extends StatelessWidget {
  const OnboardingScreenOne({super.key});

  static const Color darkGreen = Color(0xFF0E5A3C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              'assets/images/onboarding.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          // Bottom White Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 235,
              padding: const EdgeInsets.fromLTRB(22, 36, 22, 28),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(34),
                  topRight: Radius.circular(34),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Empowering Farmers',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: darkGreen,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'List your crops and connect directly with\nbuyers across the region.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 15.5,
                      height: 1.45,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Dots
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 7,
                            decoration: BoxDecoration(
                              color: darkGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE0E0E0),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE0E0E0),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),

                      // Next Button
                      SizedBox(
                        height: 52,
                        width: 112,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OnboardingScreenTwo(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkGreen,
                            foregroundColor: Colors.white,
                            elevation: 10,
                            shadowColor: darkGreen.withOpacity(0.35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.arrow_forward, size: 22),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}