import 'package:flutter/material.dart';

class FarmerInquiriesHeader extends StatelessWidget {
  final String title;

  const FarmerInquiriesHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xff075739),
            Color(0xff0b704a),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            left: -45,
            top: -55,
            child: _bubble(155),
          ),
          Positioned(
            right: -45,
            bottom: -70,
            child: _bubble(165),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
            child: Row(
              children: [
                _iconBox(Icons.agriculture_outlined),
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.6,
                      ),
                    ),
                  ),
                ),
                _iconBox(Icons.notifications_none_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble(double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.035),
      ),
    );
  }

  Widget _iconBox(IconData icon) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 27,
      ),
    );
  }
}
