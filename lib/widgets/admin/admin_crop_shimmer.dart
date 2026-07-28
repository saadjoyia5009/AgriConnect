import 'package:flutter/material.dart';

class AdminCropShimmer extends StatefulWidget {
  const AdminCropShimmer({super.key});

  @override
  State<AdminCropShimmer> createState() => _AdminCropShimmerState();
}

class _AdminCropShimmerState extends State<AdminCropShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.45,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: AnimatedBuilder(
        animation: _opacityAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: child,
          );
        },
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          itemCount: 5,
          itemBuilder: (context, index) {
            return _cropPlaceholder(isDark);
          },
        ),
      ),
    );
  }

  Widget _cropPlaceholder(bool isDark) {
    final Color placeholderColor = isDark
        ? const Color(0xFF20352B)
        : const Color(0xFFE2E9E5);

    final Color cardColor = isDark
        ? const Color(0xFF15251E)
        : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white10
              : const Color(0xFFE8EEEA),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _placeholderBox(
                color: placeholderColor,
                width: 54,
                height: 54,
                radius: 17,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _placeholderBox(
                      color: placeholderColor,
                      width: double.infinity,
                      height: 16,
                      radius: 8,
                    ),
                    const SizedBox(height: 9),
                    _placeholderBox(
                      color: placeholderColor,
                      width: 130,
                      height: 11,
                      radius: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              _placeholderBox(
                color: placeholderColor,
                width: 22,
                height: 34,
                radius: 8,
              ),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: _placeholderBox(
                  color: placeholderColor,
                  width: double.infinity,
                  height: 12,
                  radius: 6,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: _placeholderBox(
                  color: placeholderColor,
                  width: double.infinity,
                  height: 12,
                  radius: 6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _placeholderBox(
                color: placeholderColor,
                width: 66,
                height: 24,
                radius: 14,
              ),
              const Spacer(),
              _placeholderBox(
                color: placeholderColor,
                width: 85,
                height: 11,
                radius: 6,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _placeholderBox({
    required Color color,
    required double width,
    required double height,
    required double radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}