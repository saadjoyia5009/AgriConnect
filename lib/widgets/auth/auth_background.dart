import 'dart:ui';
import 'package:flutter/material.dart';

import '../../core/responsive/app_breakpoints.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/img.png', fit: BoxFit.cover),
        ),

        Positioned.fill(
          child: Container(color: Colors.black.withOpacity(0.25)),
        ),

        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.8, sigmaY: 1.8),
            child: Container(color: Colors.transparent),
          ),
        ),

        Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppBreakpoints.mobile),
            child: child,
          ),
        ),
      ],
    );
  }
}
