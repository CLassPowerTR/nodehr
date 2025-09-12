import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  final String userProfileApiUrl = dotenv.env['USER_PROFILE_URL'] ?? '';
  final String loginApiUrl = dotenv.env['LOGIN_URL'] ?? '';
  final String registerApiUrl = dotenv.env['REGISTER_URL'] ?? '';
  final String uploadPhotoApiUrl = dotenv.env['UPLOAD_PHOTO_URL'] ?? '';
  final String favoriteIdMovieApiUrl = dotenv.env['FAVORITE_ID_MOVIE_URL'] ?? '';
  final String favoritesMovieApiUrl = dotenv.env['FAVORITES_MOVIE_URL'] ?? '';
  final String movieListApiUrl = dotenv.env['MOVIE_LIST_URL'] ?? '';


  // Singleton pattern (isteğe bağlı)
  static final ApiConfig instance = ApiConfig._internal();
  factory ApiConfig() => instance;
  ApiConfig._internal();
}