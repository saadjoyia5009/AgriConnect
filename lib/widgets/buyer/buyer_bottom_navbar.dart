import 'package:flutter/material.dart';

class BuyerBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BuyerBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<_BuyerNavItem> _items = [
    _BuyerNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    _BuyerNavItem(
      icon: Icons.favorite_border,
      activeIcon: Icons.favorite,
      label: 'Favorites',
    ),
    _BuyerNavItem(
      icon: Icons.chat_bubble_outline,
      activeIcon: Icons.chat_bubble,
      label: 'Inquiries',
    ),
    _BuyerNavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final isActive = currentIndex == index;

          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: EdgeInsets.symmetric(
                horizontal: isActive ? 22 : 8,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xffA8F0C8) : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isActive ? item.activeIcon : item.icon,
                    size: 21,
                    color: const Color(0xff33443B),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff33443B),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BuyerNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _BuyerNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}