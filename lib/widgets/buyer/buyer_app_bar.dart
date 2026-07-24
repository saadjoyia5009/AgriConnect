import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Farmer-aligned app bar used throughout the Buyer module.
class BuyerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BuyerAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBack,
    this.actions,
    this.showBrandIcon = false,
  });

  static const Color primaryGreen = Color(0xFF0E5A3C);

  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool showBrandIcon;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryGreen,
      surfaceTintColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 72,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              icon: const Icon(Icons.arrow_back_rounded, size: 24),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          : showBrandIcon
          ? const Padding(
              padding: EdgeInsetsDirectional.only(start: 14),
              child: Icon(
                Icons.agriculture_outlined,
                color: Colors.white,
                size: 24,
              ),
            )
          : null,
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.outfit(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
      ),
      actions: actions,
    );
  }
}
