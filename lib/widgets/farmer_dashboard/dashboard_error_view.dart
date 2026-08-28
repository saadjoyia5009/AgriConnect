import 'package:flutter/material.dart';

import 'dashboard_colors.dart';

class DashboardErrorView extends StatelessWidget {
  final String message;
  final String retryText;
  final Color textColor;
  final VoidCallback onRetry;

  const DashboardErrorView({
    super.key,
    required this.message,
    required this.retryText,
    required this.textColor,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 220),
        Container(
          height: 80,
          width: 80,
          margin: const EdgeInsets.symmetric(horizontal: 150),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.error_outline_rounded,
            size: 45,
            color: DashboardColors.redColor,
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: DashboardColors.darkGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(retryText),
          ),
        ),
      ],
    );
  }
}
