import 'package:shared_preferences/shared_preferences.dart';

class AppLocalStorageKeys {
  static const String myRandevuFirstOpenOption = 'MyRandevuFirstOpenOption';
}

/// Kaydeder. Başarılıysa true döner.
Future<bool> saveFirstOpenOption(String value) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setString(AppLocalStorageKeys.myRandevuFirstOpenOption, value);
}

/// Siler. Başarılıysa true döner.
Future<bool> deleteFirstOpenOption() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.remove(AppLocalStorageKeys.myRandevuFirstOpenOption);
}

/// Döndürür. Kayıt yoksa null döner.
Future<String?> getFirstOpenOption() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(AppLocalStorageKeys.myRandevuFirstOpenOption);
}
