import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/user_profile_model.dart';
import '../../../providers/language_provider.dart';

class BuyerProfileStats extends StatelessWidget {
  final UserProfileModel profile;

  const BuyerProfileStats({
    super.key,
    required this.profile,
  });

  static const Color darkGreen = Color(0xff0F5C3A);
  static const Color darkCard = Color(0xFF15251E);
  static const Color lightGreen = Color(0xff9ff2c1);

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();

    final String role =
    profile.displayRole.trim().isNotEmpty ? profile.displayRole : 'Buyer';

    final String verificationStatus =
    profile.isVerified ? 'Verified' : 'Not Verified';

    final String memberSince =
    profile.memberSince.trim().isNotEmpty ? profile.memberSince : 'N/A';

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxWidth < 360;

        if (isCompact) {
          return Column(
            children: [
              _statBox(
                context,
                icon: Icons.person_outline_rounded,
                title: languageProvider.t('role'),
                value: role,
              ),
              const SizedBox(height: 10),
              _statBox(
                context,
                icon: profile.isVerified
                    ? Icons.verified_rounded
                    : Icons.info_outline_rounded,
                title: languageProvider.t('status'),
                value: verificationStatus,
              ),
              const SizedBox(height: 10),
              _statBox(
                context,
                icon: Icons.calendar_month_outlined,
                title: languageProvider.t('memberSince'),
                value: memberSince,
              ),
            ],
          );
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _statBox(
                  context,
                  icon: Icons.person_outline_rounded,
                  title: languageProvider.t('role'),
                  value: role,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statBox(
                  context,
                  icon: profile.isVerified
                      ? Icons.verified_rounded
                      : Icons.info_outline_rounded,
                  title: languageProvider.t('status'),
                  value: verificationStatus,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statBox(
                  context,
                  icon: Icons.calendar_month_outlined,
                  title: languageProvider.t('memberSince'),
                  value: memberSince,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statBox(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
      }) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 110,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: isDark ? darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white10
              : const Color(0xffDCE7DD),
        ),
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 23,
            color: isDark ? lightGreen : darkGreen,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: isDark
                  ? Colors.white
                  : const Color(0xff10291D),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: isDark
                  ? Colors.white70
                  : const Color(0xff5F675F),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}