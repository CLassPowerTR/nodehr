part of '../splash_screen.dart';

/// .env dosyasını yükler. Başarılıysa true döner.
Future<bool> _loadEnvFile({String fileName = '.env'}) async {
  try {
    var dotenv;
    await dotenv.load(fileName: fileName);
    return true;
  } catch (_) {
    // Hata yönetimi veya log ekleyebilirsiniz.
    return false;
  }
}
