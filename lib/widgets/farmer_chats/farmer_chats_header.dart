import 'package:flutter/material.dart';

class FarmerChatsHeader extends StatelessWidget {
  final String title;
  final bool isLoading;
  final VoidCallback onRefresh;

  const FarmerChatsHeader({
    super.key,
    required this.title,
    required this.isLoading,
    required this.onRefresh,
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
          colors: [Color(0xff075739), Color(0xff0b704a)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(left: -45, top: -45, child: _bubble(150)),
          Positioned(right: -45, bottom: -65, child: _bubble(160)),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
            child: Row(
              children: [
                _iconBox(Icons.chat_bubble_outline_rounded),
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
                isLoading
                    ? Container(
                  height: 48,
                  width: 48,
                  decoration: _iconDecoration(),
                  padding: const EdgeInsets.all(13),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : GestureDetector(
                  onTap: onRefresh,
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: _iconDecoration(),
                    child: const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble(double size) => Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withValues(alpha: 0.035),
    ),
  );

  Widget _iconBox(IconData icon) => Container(
    height: 48,
    width: 48,
    decoration: _iconDecoration(),
    child: Icon(icon, color: Colors.white, size: 26),
  );

  BoxDecoration _iconDecoration() => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.13),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
  );
}
