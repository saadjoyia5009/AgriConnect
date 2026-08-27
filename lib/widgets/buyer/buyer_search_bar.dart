import 'package:flutter/material.dart';

class BuyerSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;

  const BuyerSearchBar({
    super.key,
    required this.hintText,
    this.onChanged,
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

    return Container(
      height: 58,

      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xff14231C)
            : Colors.white.withValues(
          alpha: 0.96,
        ),

        borderRadius:
        BorderRadius.circular(40),

        border: Border.all(
          color: isDark
              ? Colors.white12
              : const Color(0xffDCE8E0),
          width: 1,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha:
              isDark ? 0.20 : 0.055,
            ),
            blurRadius: 20,
            spreadRadius: 0,
            offset:
            const Offset(0, 7),
          ),
        ],
      ),

      child: TextField(
        onChanged: onChanged,

        textAlignVertical:
        TextAlignVertical.center,

        style: TextStyle(
          color: isDark
              ? Colors.white
              : const Color(
            0xff18211C,
          ),
          fontSize: 15,
          fontWeight:
          FontWeight.w600,
        ),

        cursorColor:
        isDark
            ? lightGreen
            : darkGreen,

        decoration: InputDecoration(
          border:
          InputBorder.none,

          hintText:
          hintText,

          hintStyle:
          TextStyle(
            color: isDark
                ? Colors.white38
                : const Color(
              0xff7A8580,
            ),
            fontSize: 14,
            fontWeight:
            FontWeight.w500,
          ),

          prefixIcon:
          Padding(
            padding:
            const EdgeInsetsDirectional.only(
              start: 3,
              end: 2,
            ),

            child: Icon(
              Icons.search_rounded,
              color: isDark
                  ? Colors.white70
                  : const Color(
                0xff64716A,
              ),
              size: 26,
            ),
          ),

          prefixIconConstraints:
          const BoxConstraints(
            minWidth: 52,
            minHeight: 58,
          ),

          suffixIcon:
          Padding(
            padding:
            const EdgeInsetsDirectional.only(
              top: 7,
              bottom: 7,
              end: 7,
            ),

            child: Material(
              color:
              Colors.transparent,

              child: InkWell(
                borderRadius:
                BorderRadius.circular(
                  15,
                ),

                onTap: () {
                  // Existing filter action
                  // can be connected here
                },

                child: Container(
                  width: 43,
                  height: 43,

                  decoration:
                  BoxDecoration(
                    color: isDark
                        ? darkGreen
                        : const Color(
                      0xffE7F5EC,
                    ),

                    borderRadius:
                    BorderRadius.circular(
                      15,
                    ),

                    border: Border.all(
                      color: isDark
                          ? Colors.white10
                          : const Color(
                        0xffD5EBDD,
                      ),
                    ),
                  ),

                  child: Icon(
                    Icons
                        .tune_rounded,

                    color: isDark
                        ? Colors.white
                        : darkGreen,

                    size: 21,
                  ),
                ),
              ),
            ),
          ),

          suffixIconConstraints:
          const BoxConstraints(
            minWidth: 50,
            minHeight: 58,
          ),

          contentPadding:
          const EdgeInsets.symmetric(
            vertical: 0,
          ),
        ),
      ),
    );
  }
}