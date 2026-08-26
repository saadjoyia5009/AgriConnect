import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_profile_model.dart';
import '../../providers/language_provider.dart';

class PersonalInformationCard extends StatelessWidget {
  final UserProfileModel profile;

  const PersonalInformationCard({
    super.key,
    required this.profile,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        22,
        22,
        22,
        20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white10
              : const Color(0xffe3ebe6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.18 : 0.06,
            ),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _cardTitle(
            context: context,
            icon: Icons.person,
            title: lang.t("personalInformation"),
          ),
          const SizedBox(height: 12),
          _infoRow(
            context: context,
            icon: Icons.email,
            title: lang.t("emailAddress"),
            value: profile.email.trim().isEmpty
                ? lang.t("noEmailFound")
                : profile.email,
          ),
          _divider(context),
          _infoRow(
            context: context,
            icon: Icons.phone,
            title: lang.t("phoneNumber"),
            value: profile.phone.trim().isEmpty
                ? lang.t("noPhoneFound")
                : profile.phone,
          ),
          _divider(context),
          _infoRow(
            context: context,
            icon: Icons.location_on,
            title: lang.t("location"),
            value: profile.address.trim().isEmpty
                ? lang.t("noLocationFound")
                : profile.address,
          ),
        ],
      ),
    );
  }

  Widget _cardTitle({
    required BuildContext context,
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        _iconBox(icon , context),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: darkGreen,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
  }) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
      child: Row(
        children: [
          _iconBox(icon, context),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white60
                        : const Color(0xff4f5955),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBox(
      IconData icon,
      BuildContext context,
      ) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xff20372b)
            : const Color(0xffe8f5ee),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: isDark
            ? const Color(0xff65c98e)
            : darkGreen,
        size: 23,
      ),
    );
  }

  Widget _divider(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Divider(
      height: 1,
      thickness: 1,
      color: isDark
          ? Colors.white12
          : Colors.grey.shade300,
    );
  }
}