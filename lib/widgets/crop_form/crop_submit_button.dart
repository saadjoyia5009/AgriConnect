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
            : Icon(icon, size: 18),
        label: Text(
          isSubmitting ? loadingTitle : title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: darkGreen,
          foregroundColor: Colors.white,
          disabledBackgroundColor: darkGreen.withOpacity(0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}