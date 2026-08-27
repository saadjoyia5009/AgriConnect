import 'package:flutter/material.dart';

class BuyerSectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const BuyerSectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  static const Color darkGreen =
      Color(0xff0F5C3A);

  static const Color lightGreen =
      Color(0xff9ff2c1);

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Row(
      children: [

        Container(
          height: 34,
          width: 34,

          decoration:
              BoxDecoration(
            color: isDark
                ? darkGreen
                : const Color(
                    0xffE5F5E9,
                  ),
            borderRadius:
                BorderRadius.circular(
              12,
            ),
          ),

          child: Icon(
            Icons.eco_rounded,
            size: 19,
            color: isDark
                ? lightGreen
                : darkGreen,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            title,

            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,

            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.w900,
              color: isDark
                  ? Colors.white
                  : const Color(
                      0xff18211C,
                    ),
            ),
          ),
        ),

        if (actionText != null)
          GestureDetector(
            onTap: onActionTap,

            child: Row(
              mainAxisSize:
                  MainAxisSize.min,

              children: [

                Text(
                  actionText!,

                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w800,
                    color: isDark
                        ? lightGreen
                        : darkGreen,
                  ),
                ),

                const SizedBox(
                  width: 4,
                ),

                Icon(
                  Icons
                      .arrow_forward_rounded,
                  size: 16,
                  color: isDark
                      ? lightGreen
                      : darkGreen,
                ),
              ],
            ),
          ),
      ],
    );
  }
}