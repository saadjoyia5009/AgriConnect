import 'package:flutter/material.dart';
import 'onboarding_screen_three.dart';

class OnboardingScreenTwo extends StatelessWidget {
  const OnboardingScreenTwo({super.key});

  static const Color darkGreen = Color(0xFF0E5A3C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 28, 26, 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    // Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text(
                    '',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.asset(
                  'assets/images/onboarding2.jpeg',
                  height: 390,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 44),

              const Text(
                'Smart Insights',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Access AI-powered price\npredictions and disease detection\nto maximize your yield.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF444444),
                  fontSize: 17,
                  height: 1.42,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _dot(false),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 8,
                    decoration: BoxDecoration(
                      color: darkGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _dot(false),
                ],
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingScreenThree(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreen,
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shadowColor: darkGreen.withOpacity(0.25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.arrow_forward, size: 22),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0xFFE1E1E1),
        shape: BoxShape.circle,
      ),
    );
  }
}