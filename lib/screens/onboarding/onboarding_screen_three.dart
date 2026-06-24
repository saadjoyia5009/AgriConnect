import 'package:flutter/material.dart';
import '../auth/login_screen.dart';

class OnboardingScreenThree extends StatelessWidget {
  const OnboardingScreenThree({super.key});

  static const Color darkGreen = Color(0xFF0E5A3C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
                child: Image.asset(
                  'assets/images/onboarding3.jpeg',
                  height: 410,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 62, 24, 32),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 62,
                        width: 62,
                        decoration: const BoxDecoration(
                          color: Color(0xFFB8F5D4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.storefront,
                          color: darkGreen,
                          size: 30,
                        ),
                      ),

                      const SizedBox(height: 34),

                      const Text(
                        'Direct Marketplace',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1D1D1D),
                          fontSize: 27,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Skip the middleman. Connect\ndirectly with buyers and get the\nbest value for your hard work.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF3F3F3F),
                          fontSize: 17,
                          height: 1.45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const Spacer(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _dot(),
                          const SizedBox(width: 8),
                          _dot(),
                          const SizedBox(width: 8),
                          Container(
                            width: 32,
                            height: 8,
                            decoration: BoxDecoration(
                              color: darkGreen,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkGreen,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor: darkGreen.withOpacity(0.25),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          child: const Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
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

  Widget _dot() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0xFFE0E0E0),
        shape: BoxShape.circle,
      ),
    );
  }
}