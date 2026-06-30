import 'package:flutter/material.dart';

class CropSubmitButton extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onPressed;
  final String title;
  final String loadingTitle;
  final IconData icon;
  final double borderRadius;

  const CropSubmitButton({
    super.key,
    required this.isSubmitting,
    required this.onPressed,
    required this.title,
    required this.loadingTitle,
    this.icon = Icons.add_circle_outline,
    this.borderRadius = 9,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: isSubmitting ? null : onPressed,
        icon: isSubmitting
            ? const SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Icon(
          icon,
          size: 18,
          color: Colors.white,
        ),
        label: Text(
          isSubmitting ? loadingTitle : title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: darkGreen,
          foregroundColor: Colors.white,
          disabledBackgroundColor: isDark
              ? darkGreen.withOpacity(0.45)
              : darkGreen.withOpacity(0.70),
          disabledForegroundColor: Colors.white70,
          elevation: isDark ? 0 : 2,
          shadowColor: isDark
              ? Colors.transparent
              : Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}