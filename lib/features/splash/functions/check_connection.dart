part of '../splash_screen.dart';

Future<bool> _checkConnection() async {
  try {
    // Basit bir internet kontrolü için Google'a ping atılabilir
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      // İnternet bağlantısı var
      // Burada yönlendirme veya diğer işlemler yapılabilir
      return true;
    } else {
      // İnternet bağlantısı yok
      return false;
    }
  } catch (_) {
    // İnternet bağlantısı yok
    return false;
  }
}
