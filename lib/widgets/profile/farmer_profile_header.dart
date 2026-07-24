  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';

  import '../../models/user_profile_model.dart';
  import '../../providers/language_provider.dart';

  class FarmerProfileHeader extends StatelessWidget {
    final UserProfileModel profile;
    final VoidCallback onCameraTap;

    const FarmerProfileHeader({
      super.key,
      required this.profile,
      required this.onCameraTap,
    });

    static const Color darkGreen = Color(0xff075739);

    @override
    Widget build(BuildContext context) {
      final lang = context.watch<LanguageProvider>();

      return Container(
        height: 300,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff063d2c),
              Color(0xff075739),
              Color(0xff0b8f4d),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              bottom: 18,
              child: Icon(
                Icons.eco,
                size: 130,
                color: Colors.white.withValues(
                  alpha: 0.12,
                ),
              ),
            ),
            Positioned(
              top: 46,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 14),
                  Text(
                    lang.t("profile"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              top: 115,
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  _profileImage(),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _profileDetails(
                      context,
                      lang,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget _profileImage() {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 140,
            width: 140,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: profile.profileImage.trim().isNotEmpty
                  ? Image.network(
                profile.profileImage,
                width: 130,
                height: 130,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return _initialsAvatar();
                },
              )
                  : _initialsAvatar(),
            ),
          ),
          Positioned(
            right: -3,
            bottom: -2,
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: onCameraTap,
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: const Color(0xff089b55),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 5,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 23,
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget _initialsAvatar() {
      return Container(
        color: const Color(0xffe8f5ee),
        alignment: Alignment.center,
        child: Text(
          profile.initials,
          style: const TextStyle(
            color: darkGreen,
            fontSize: 38,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    }

    Widget _profileDetails(
        BuildContext context,
        LanguageProvider lang,
        ) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  profile.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (profile.isVerified) ...[
                const SizedBox(width: 7),
                const Icon(
                  Icons.verified,
                  color: Colors.white,
                  size: 25,
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: profile.isVerified
                  ? const Color(0xff18b65f)
                  : Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  profile.isVerified
                      ? Icons.verified_user
                      : Icons.agriculture,
                  color: Colors.white,
                  size: 17,
                ),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    profile.isVerified
                        ? lang.t("verifiedFarmer")
                        : "Farmer",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          _headerInfo(
            icon: Icons.location_on_outlined,
            text: profile.displayAddress,
          ),
          const SizedBox(height: 10),
          _headerInfo(
            icon: Icons.calendar_month_outlined,
            text: profile.memberSince.isEmpty
                ? "Member since unavailable"
                : "Member since ${profile.memberSince}",
          ),
        ],
      );
    }

    Widget _headerInfo({
      required IconData icon,
      required String text,
    }) {
      return Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    }
  }