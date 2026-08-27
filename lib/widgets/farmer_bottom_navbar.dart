import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';

class FarmerBottomNavbar extends StatelessWidget {
  final int currentIndex;

  const FarmerBottomNavbar({
    super.key,
    required this.currentIndex,
  });

  static const Color darkGreen = Color(0xff075739);
  static const Color lightGreen = Color(0xff9ff2c1);

  // ============================================================
  // NAVIGATION LOGIC — UNCHANGED
  // ============================================================

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return;

    final routes = [
      '/farmerDashboard',
      '/myCrops',
      '/farmerChats',
      '/farmerInquiries',
      '/profile',
    ];

    Navigator.pushReplacementNamed(
      context,
      routes[index],
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final lang =
        context.watch<LanguageProvider>();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          10,
          0,
          10,
          10,
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 18,
              sigmaY: 18,
            ),
            child: Container(
              height: 78,

              decoration: BoxDecoration(
                // =================================================
                // GLASS BACKGROUND
                // =================================================

                color: isDark
                    ? const Color(0xff15221c)
                        .withValues(alpha: 0.90)
                    : Colors.white.withValues(
                        alpha: 0.88,
                      ),

                borderRadius:
                    BorderRadius.circular(30),

                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(
                          alpha: 0.10,
                        )
                      : Colors.white.withValues(
                          alpha: 0.85,
                        ),
                  width: 1.2,
                ),

                // =================================================
                // PREMIUM SHADOW
                // =================================================

                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(
                            alpha: 0.35,
                          )
                        : darkGreen.withValues(
                            alpha: 0.10,
                          ),
                    blurRadius: 25,
                    spreadRadius: 1,
                    offset: const Offset(
                      0,
                      8,
                    ),
                  ),
                ],
              ),

              child: Row(
                children: [

                  // =================================================
                  // HOME
                  // =================================================

                  Expanded(
                    child: _navItem(
                      context: context,
                      icon: Icons.home_rounded,
                      label: lang.t("home"),
                      index: 0,
                      isDark: isDark,
                    ),
                  ),

                  // =================================================
                  // CROPS
                  // =================================================

                  Expanded(
                    child: _navItem(
                      context: context,
                      icon: Icons.spa_rounded,
                      label: lang.t("crops"),
                      index: 1,
                      isDark: isDark,
                    ),
                  ),

                  // =================================================
                  // CENTER CHAT
                  // =================================================

                  SizedBox(
                    width: 76,
                    child: _chatButton(
                      context,
                      isDark,
                    ),
                  ),

                  // =================================================
                  // INQUIRY
                  // =================================================

                  Expanded(
                    child: _navItem(
                      context: context,
                      icon: Icons.assignment_rounded,
                      label: lang.t("inquiry"),
                      index: 3,
                      isDark: isDark,
                    ),
                  ),

                  // =================================================
                  // PROFILE
                  // =================================================

                  Expanded(
                    child: _navItem(
                      context: context,
                      icon: Icons.person_rounded,
                      label: lang.t("profile"),
                      index: 4,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // NORMAL NAV ITEM
  // ============================================================

  Widget _navItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required bool isDark,
  }) {
    final bool isActive =
        currentIndex == index;

    final Color activeColor =
        isDark ? lightGreen : darkGreen;

    final Color inactiveColor =
        isDark
            ? Colors.white.withValues(
                alpha: 0.55,
              )
            : const Color(0xff8c938f);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTap: () {
        _navigate(
          context,
          index,
        );
      },

      child: Center(
        child: AnimatedContainer(
          duration:
              const Duration(
            milliseconds: 220,
          ),
          curve: Curves.easeOutCubic,

          padding:
              const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 6,
          ),

          decoration: BoxDecoration(
            color: isActive
                ? (isDark
                    ? lightGreen.withValues(
                        alpha: 0.12,
                      )
                    : const Color(0xffe8f6ed))
                : Colors.transparent,

            borderRadius:
                BorderRadius.circular(20),
          ),

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [

              AnimatedScale(
                scale: isActive
                    ? 1.08
                    : 1.0,

                duration:
                    const Duration(
                  milliseconds: 180,
                ),

                child: Icon(
                  icon,
                  size: 24,
                  color: isActive
                      ? activeColor
                      : inactiveColor,
                ),
              ),

              const SizedBox(
                height: 2,
              ),

              Text(
                label,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,

                style: TextStyle(
                  color: isActive
                      ? activeColor
                      : inactiveColor,

                  fontSize: 11.5,

                  fontWeight: isActive
                      ? FontWeight.w800
                      : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CENTER CHAT BUTTON
  // ============================================================

  Widget _chatButton(
    BuildContext context,
    bool isDark,
  ) {
    final Color green =
        isDark
            ? const Color(0xff0a8b56)
            : darkGreen;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTap: () {
        _navigate(
          context,
          2,
        );
      },

      child: Transform.translate(
        offset: const Offset(
          0,
          -14,
        ),

        child: Container(
          height: 55,
          width: 60,

          padding:
              const EdgeInsets.all(3),

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            color: isDark
                ? const Color(0xff15221c)
                : Colors.white,

            boxShadow: [
              BoxShadow(
                color: green.withValues(
                  alpha: 0.25,
                ),
                blurRadius: 18,
                spreadRadius: 2,
                offset: const Offset(
                  0,
                  5,
                ),
              ),
            ],
          ),

          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,

              gradient:
                  LinearGradient(
                begin:
                    Alignment.topLeft,
                end:
                    Alignment.bottomRight,

                colors: [
                  isDark
                      ? const Color(0xff0d9a61)
                      : const Color(0xff087148),

                  darkGreen,
                ],
              ),
            ),

            child: const Icon(
              Icons.forum_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),
        ),
      ),
    );
  }
}