import 'language_provider.dart';

/// Buyer-only language state backed by its own persisted preference.
///
/// Translation lookup is inherited from [LanguageProvider], keeping the
/// existing English and Urdu dictionaries as the single source of truth.
class BuyerLanguageProvider extends LanguageProvider {
  BuyerLanguageProvider({required super.initialLocale})
    : super(storageKey: 'buyer_language_code');
}
