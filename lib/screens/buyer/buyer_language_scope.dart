import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/buyer_language_provider.dart';
import '../../providers/language_provider.dart';

/// Shadows the app-wide language provider for the buyer section only.
class BuyerLanguageScope extends StatelessWidget {
  const BuyerLanguageScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final buyerLanguage = context.watch<BuyerLanguageProvider>();

    // Existing buyer widgets can keep requesting LanguageProvider while this
    // scope redirects them to the persistent buyer-only instance.
    return ChangeNotifierProvider<LanguageProvider>.value(
      value: buyerLanguage,
      child: Directionality(
        textDirection: buyerLanguage.locale.languageCode == 'ur'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: child,
      ),
    );
  }
}
