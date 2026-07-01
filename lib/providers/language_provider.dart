import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  bool _isLoaded = false;

  Locale get locale => _locale;
  bool get isLoaded => _isLoaded;

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('languageCode') ?? 'en';

    _locale = Locale(code);
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);

    _locale = Locale(languageCode);
    notifyListeners();
  }

  String t(String key) {
    final translations = {
      'en': {
        'appName': 'AgriConnect',
        'welcomeBack': 'Welcome back',
        'loginSubtitle': 'Please enter your details to sign in.',
        'email': 'Email',
        'password': 'Password',
        'selectRole': 'Select Your Role',
        'forgotPassword': 'Forgot Password?',
        'login': 'Login',
        'dontHaveAccount': "Don't have an account? ",
        'signup': 'Sign Up',
        'enterEmailPassword': 'Please enter email and password first',
        'invalidEmailPassword': 'Invalid email or password',
        'enterName': 'Enter Name',
        'createAccount': 'Create Account',
        'signupSubtitle': 'Join AgriConnect and start your journey.',
        'fullName': 'Full Name',
        'phoneNumber': 'Phone Number',
        'fillAllFields': 'Please fill all fields',
        'signupFailed': 'Signup failed',
        'accountCreated': 'Account created successfully. Please login.',
        'alreadyHaveAccount': 'Already have an account? ',
      },
      'ur': {
        'appName': 'ایگری کنیکٹ',
        'welcomeBack': 'خوش آمدید',
        'loginSubtitle': 'سائن اِن کرنے کے لیے اپنی تفصیلات درج کریں۔',
        'email': 'ای میل',
        'password': 'پاس ورڈ',
        'selectRole': 'اپنا کردار منتخب کریں',
        'forgotPassword': 'پاس ورڈ بھول گئے؟',
        'login': 'لاگ اِن',
        'dontHaveAccount': 'اکاؤنٹ نہیں ہے؟ ',
        'signup': 'سائن اَپ',
        'enterEmailPassword': 'براہ کرم پہلے ای میل اور پاس ورڈ درج کریں',
        'invalidEmailPassword': 'ای میل یا پاس ورڈ غلط ہے',
        'enterName': 'نام درج کریں',
        'createAccount': 'اکاؤنٹ بنائیں',
        'signupSubtitle': 'AgriConnect میں شامل ہوں اور اپنا سفر شروع کریں',
        'fullName': 'پورا نام',
        'phoneNumber': 'فون نمبر',
        'fillAllFields': 'براہ کرم تمام فیلڈز بھریں',
        'signupFailed': 'سائن اَپ ناکام',
        'accountCreated': 'اکاؤنٹ کامیابی سے بنایا گیا۔ براہ کرم لاگ ان کریں',
        'alreadyHaveAccount': 'پہلے سے اکاؤنٹ ہے؟ ',
      },
    };

    return translations[_locale.languageCode]?[key] ??
        translations['en']?[key] ??
        key;
  }
}