# NodeHR (Shartflix)

Shartflix, film keşfi ve favori yönetimi akışlarını içeren Flutter tabanlı bir örnek mobil uygulamadır. Bu README, en son değişikliklere göre güncellenmiştir: NavBar geçiş animasyonları, Splash/Login görsel güncellemeleri, favoriler API normalizasyonu, görsel yükleme hatası dayanıklılığı ve ekran ekran açıklamalar.

## İçindekiler
- Proje Özeti
- Kurulum ve Çalıştırma
- Yapılandırma (.env)
- Ekranlar ve Akış (Ekran Görüntüsü Alanları Dahil)
- Animasyonlar (NavBar)
- Mimari ve Teknik Detaylar
- Görsel Yükleme Dayanıklılığı (URL sanitize, errorBuilder)
- Geliştirme İpuçları

## Proje Özeti
- Çok dilli destek (en, tr)
- Token tabanlı kimlik doğrulama (SharedPreferences)
- Film listesi sayfalamalı olarak çekilir ve görüntülenir
- Favorilere ekleme/çıkarma (iyimser güncelleme)
- Alt gezinme (Home, Profile) ve sayfa çevirme hissi veren Lottie animasyonlar

## Kurulum ve Çalıştırma
1. Bağımlılıkları kurun:
```bash
flutter pub get
```
2. Ortam değişkenlerini tanımlayın (aşağıdaki .env bölümüne bakınız).
3. Uygulamayı çalıştırın:
```bash
flutter run
```

## Yapılandırma (.env)
`lib/core/api/config/api_config.dart` dosyasında okunan anahtarlar:
```env
USER_PROFILE_URL=
LOGIN_URL=
REGISTER_URL=
UPLOAD_PHOTO_URL=
FAVORITE_ID_MOVIE_URL=
FAVORITES_MOVIE_URL=
MOVIE_LIST_URL=
```
Notlar:
- URL’ler mümkünse HTTPS olmalıdır.
- Eksik/boş anahtarlar ilgili özelliğin hata vermesine neden olur.

## Ekranlar ve Akış (Ekran Görüntüsü Alanları)
Navigasyon `lib/core/routes/app_routes.dart` ve `lib/core/routes/app_router.dart` ile yönetilir. Başlangıç rotası: Splash.

### Splash (`/`)
- Dosya: `lib/features/splash/views/splash_view.dart`
- İşlev: Token/profil kontrolü sonrası `/home` veya `/login` rotasına geçiş.
- Görsel: Lottie yerine yerel `Image.asset('assets/icons/AppIcon.png')` kullanılır.
- Ekran Görüntüsü: (görseli buraya ekleyin)
```markdown
![Splash](docs/screenshots/splash.png)
```

### Login (`/login`)
- Dosya: `lib/features/auth/views/login_view.dart`
- İçerik: E‑posta/Şifre alanları (`AppTextFormField`), Giriş butonu, Kayıt ol butonu.
- Görsel: Lottie yerine `Image.asset('assets/icons/AppIcon.png')` kullanılır.
- Ekran Görüntüsü: (görseli buraya ekleyin)
```markdown
![Screenshot_20250914_192849](https://github.com/user-attachments/assets/465310e9-8e8c-4e81-9bf9-dd68b525d4d1)
```

### Register (`/register`)
- Dosya: `lib/features/auth/views/register_view.dart`
- İçerik: İsim/E‑posta/Şifre alanları ve kayıt akışı.
- Ekran Görüntüsü: (görseli buraya ekleyin)
```markdown
![Register](docs/screenshots/register.png)
```

### Home (`/home` → `NavBarView` index 0)
- Dosya: `lib/features/home/views/home_view.dart`
- İşlev: Sayfalamalı film listesi, `MovieCard` ile kart bazlı gösterim, sayfa göstergesi.
- Favori: `FavoritesProvider.toggleLike(id)` ile iyimser güncelleme, bekleyen işlem overlay’i.
- Ekran Görüntüsü: (görseli buraya ekleyin)
```markdown
![Home](docs/screenshots/home.png)
```

### Profile (`/profile` → `NavBarView` index 1)
- Dosya: `lib/features/profile/views/profile_view.dart`
- İşlev: Kullanıcı bilgileri, profil fotoğrafı seçimi (Galeriden/Kamera), favori filmlerin grid görünümü.
- Favoriler: `ApiService.getFavoriteMovies()` artık `List<dynamic>` döner; `ProfileView` bu ham listeyi `List<MovieModel>`’e dönüştürüp (`MovieModel.fromJson`) `_favorites` olarak kullanır. UI’da render, poster URL listesi ile yapılır (tip hatalarına dayanıklı).
- Fotoğraf Alanı: Profil ekranında yer alan “Galeriden” ve “Kamera” butonları ile fotoğraf seçimi/yüklenmesi yapılır.
- Ekran Görüntüsü (foto yükleme alanı dahil):
```markdown
![Profile](docs/screenshots/profile.png)
```

### Alt Gezinme (NavBar)
- Dosya: `lib/features/nav_bar/views/nav_bar_view.dart`
- Sekmeler: Home, Profile
- Özel: Sekmeler arası geçişte yerel Lottie animasyonları ile “kitap sayfası çevirme” etkisi:
  - `assets/animations/page_flip_forward.json`
  - `assets/animations/page_flip_backward.json`
- Ekran Görüntüsü (geçiş anı):
```markdown
![NavBar Transition](docs/screenshots/navbar_transition.png)
```

## Animasyonlar (NavBar)
- Ağ üzerinden Lottie çekmek yerine yerel asset’ler kullanılır: `Lottie.asset('assets/animations/...')`.
- `pubspec.yaml` içinde `assets/animations/` tanımlıdır.

## Mimari ve Teknik Detaylar
- Eyalet Yönetimi: `provider`
  - `AllMoviesProvider`: Sunucudan sayfalı film listesini indirir, UI’ya sayfa bazlı dilimler sağlar.
  - `FavoritesProvider`: İyimser güncellemeyle favori toggle; `ApiService.toggleFavoriteById` ile sunucu senkronizasyonu.
- API Servisleri: `lib/core/api/services/api_service.dart`
  - `getFavoriteMovies()` dönüşü: `Future<List<dynamic>>` (ham film JSON listesi). UI/Model tarafında `MovieModel.fromJson` ile tiplenir.
  - `getMovies()`, `login()`, `register()`, `getMyProfile()` ve `toggleFavoriteById()` kullanılabilir.
- Ortak Bileşenler:
  - `AppTextFormField`: Odak ve şifre görünürlüğü özellikleri.
  - `MovieCard`: URL sanitize (`http→https`) ve `errorBuilder` ile görsel hatalarına dayanıklı.

## Görsel Yükleme Dayanıklılığı
- Poster URL’leri `http` ile başlıyorsa otomatik `https`’e yükseltilir.
- `Image.network(..., errorBuilder: ...)` ile bozuk/erişilemeyen görseller için yer tutucu gösterilir.
- Profil favori grid’i render’ı poster URL listesi üzerinden yapılır; tip uyuşmazlıkları engellenmiştir.

## Ekran Görüntüsü Yükleme
- Bu README’deki görsel alanlarının görünmesi için ekran görüntülerinizi şu klasöre koyun:
  - `docs/screenshots/`
- Önerilen dosya adları:
  - `splash.png`, `login.png`, `register.png`, `home.png`, `profile.png`, `navbar_transition.png`

## Geliştirme İpuçları
- Komutlar:
```bash
flutter pub get
flutter run
flutter build apk --release
```
- 401/403 durumunda token otomatik temizlenir; tekrar giriş istenir.
- `.env` değiştiğinde uygulamayı tamamen yeniden başlatın.

