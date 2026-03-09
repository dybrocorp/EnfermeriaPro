import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class PremiumService {
  static const String _premiumKey = 'is_premium';
  static bool _isPremium = false;

  static bool get isPremium => _isPremium;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool(_premiumKey) ?? false;
    
    if (!_isPremium) {
      await MobileAds.instance.initialize();
    }
  }

  static Future<void> setPremium(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, value);
    _isPremium = value;
  }
}
