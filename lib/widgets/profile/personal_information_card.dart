import 'package:flutter/material.dart';

import '../../providers/auth_provider.dart';

class PersonalInformationCard extends StatelessWidget {
  final AuthProvider authProvider;

  const PersonalInformationCard({
    super.key,
    required this.authProvider,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    return _card(
      children: [
        _cardTitle(
          icon: Icons.person,
          title: "Personal Information",
        ),
        const SizedBox(height: 12),
        _infoRow(
          icon: Icons.email,
          title: "Email Address",
          value: authProvider.email.isEmpty
              ? "No email found"
              : authProvider.email,
        ),
        _divider(),
        _infoRow(
          icon: Icons.phone,
          title: "Phone Number",
          value: authProvider.phone.isEmpty
              ? "No phone found"
              : authProvider.phone,
        ),
        _divider(),
        _infoRow(
          icon: Icons.location_on,
          title: "Location",
          value: authProvider.location.isEmpty
              ? "No location found"
              : authProvider.location,
        ),
      ],
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _cardTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        _iconBox(icon),
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
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          _iconBox(icon),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xff4f5955),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xff202525),
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

  Widget _iconBox(IconData icon) {
    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        color: const Color(0xffe8f5ee),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: darkGreen, size: 23),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade300,
    );
  }
}