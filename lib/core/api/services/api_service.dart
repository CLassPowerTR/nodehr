import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:nodehr/core/api/config/api_config.dart';
import 'package:nodehr/core/models/profile_model.dart';
import 'package:nodehr/core/models/user_model.dart';
import 'package:nodehr/core/models/movies_model.dart';
import 'package:nodehr/core/models/favorites_movie_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final config = ApiConfig();

  static Future<String> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('ShartFlixAccesToken') ?? '';
  }

  /// API'den User verisini çekmek için metot.
  static Future<List<ProfileModel>> getMyProfile() async {
    final token = await getAccessToken();
    final response = await http.get(
      Uri.parse(config.userProfileApiUrl),
      headers: {
        'Authorization': token.isNotEmpty ? 'Bearer $token' : '',
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=utf-8',
        'Allow': 'Get',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => ProfileModel.fromJson(json)).toList();
    } else {
      // If token is invalid or expired, remove it from storage so login flow can re-auth
      if (response.statusCode == 401 || response.statusCode == 403) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('ShartFlixAccesToken');
        throw Exception('Yetkilendirme başarısız. Lütfen tekrar giriş yapın.');
      }
      throw Exception(
        'Profil verisi alınamadı. Durum kodu: ${response.statusCode}',
      );
    }
  }

  /// Login isteği atar, token'ı kaydeder ve User döner
  static Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    if (config.loginApiUrl.isEmpty) {
      throw Exception(
        'Login URL tanımlı değil. Lütfen konfigürasyonu kontrol edin.',
      );
    }
    try {
      final response = await http
          .post(
            Uri.parse(config.loginApiUrl),
            headers: const {
              'Accept': 'application/json',
              'Content-Type': 'application/json; charset=utf-8',
            },
            body: json.encode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> body =
            json.decode(response.body) as Map<String, dynamic>;
        final String token = (body['data']['token'] ?? '').toString();
        if (token.isEmpty) {
          throw Exception('Geçersiz yanıt: token bulunamadı.');
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('ShartFlixAccesToken', token);

        final Map<String, dynamic> userJson =
            (body['user'] as Map<String, dynamic>?) ?? <String, dynamic>{};
        return UserModel.fromJson(userJson);
      } else {
        // Try to extract message from body
        String message = 'İstek başarısız. Durum kodu: ${response.statusCode}';
        try {
          final parsed = json.decode(response.body);
          if (parsed is Map && parsed.containsKey('message')) {
            message = parsed['message'].toString();
          } else if (parsed is Map && parsed.containsKey('error')) {
            message = parsed['error'].toString();
          } else if (parsed is String && parsed.isNotEmpty) {
            message = parsed;
          }
        } catch (_) {}
        throw Exception(message);
      }
    } on TimeoutException {
      throw Exception(
        'İstek zaman aşımına uğradı. İnternet bağlantınızı kontrol edin.',
      );
    } on http.ClientException catch (e) {
      final message = e.message.isNotEmpty ? e.message : e.toString();
      throw Exception(message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Register isteği atar, token'ı kaydeder ve User döner
  static Future<UserModel> register({
    required String email,
    required String name,
    required String password,
  }) async {
    if (config.registerApiUrl.isEmpty) {
      throw Exception(
        'Register URL tanımlı değil. Lütfen konfigürasyonu kontrol edin.',
      );
    }
    try {
      final response = await http
          .post(
            Uri.parse(config.registerApiUrl),
            headers: const {
              'Accept': 'application/json',
              'Content-Type': 'application/json; charset=utf-8',
            },
            body: json.encode({
              'email': email,
              'name': name,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 20));
      print(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> body =
            json.decode(response.body) as Map<String, dynamic>;

        // Token may come in different shapes, prefer body['data']['token']
        String token = '';
        try {
          if (body.containsKey('data') && body['data'] is Map) {
            token = (body['data']['token'] ?? '').toString();
          }
        } catch (_) {}
        token = token.isNotEmpty ? token : (body['token'] ?? '').toString();

        if (token.isEmpty) {
          throw Exception('Geçersiz yanıt: token bulunamadı.');
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('ShartFlixAccesToken', token);

        // Build user map from body['data'] if present
        Map<String, dynamic> userJson = <String, dynamic>{};
        if (body.containsKey('data') && body['data'] is Map) {
          final Map<String, dynamic> data = Map<String, dynamic>.from(
            body['data'],
          );
          userJson = {
            'id': (data['id'] ?? data['_id'] ?? '').toString(),
            'name': (data['name'] ?? '').toString(),
            'email': (data['email'] ?? '').toString(),
          };
        } else {
          userJson =
              (body['user'] as Map<String, dynamic>?) ?? <String, dynamic>{};
        }

        return UserModel.fromJson(userJson);
      } else {
        String message = 'İstek başarısız. Durum kodu: ${response.statusCode}';
        try {
          final parsed = json.decode(response.body);
          if (parsed is Map && parsed.containsKey('message')) {
            message = parsed['message'].toString();
          } else if (parsed is Map && parsed.containsKey('error')) {
            message = parsed['error'].toString();
          } else if (parsed is String && parsed.isNotEmpty) {
            message = parsed;
          }
        } catch (_) {}
        throw Exception(message);
      }
    } on TimeoutException {
      throw Exception(
        'İstek zaman aşımına uğradı. İnternet bağlantınızı kontrol edin.',
      );
    } on http.ClientException catch (e) {
      final message = e.message.isNotEmpty ? e.message : e.toString();
      throw Exception(message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Filme listesi çeker ve tiplenmiş bir model döner
  static Future<MoviesListModel> getMovies(int? page) async {
    if (config.movieListApiUrl.isEmpty) {
      throw Exception(
        'Movie list URL tanımlı değil. Lütfen konfigürasyonu kontrol edin.',
      );
    }

    try {
      final token = await getAccessToken();
      final uri = Uri.parse('${config.movieListApiUrl}?page=${page ?? 1}');
      final response = await http
          .get(
            uri,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json; charset=utf-8',
              'Authorization': token.isNotEmpty ? 'Bearer $token' : '',
            },
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> body =
            json.decode(response.body) as Map<String, dynamic>;
        return MoviesListModel.fromJson(body);
      } else {
        if (response.statusCode == 401 || response.statusCode == 403) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('ShartFlixAccesToken');
          throw Exception(
            'Yetkilendirme başarısız. Lütfen tekrar giriş yapın.',
          );
        }

        String message = 'İstek başarısız. Durum kodu: ${response.statusCode}';
        try {
          final parsed = json.decode(response.body);
          if (parsed is Map &&
              parsed.containsKey('response') &&
              parsed['response'] is Map) {
            final resp = parsed['response'] as Map<String, dynamic>;
            if (resp.containsKey('message') &&
                resp['message'].toString().isNotEmpty) {
              message = resp['message'].toString();
            }
          } else if (parsed is Map && parsed.containsKey('message')) {
            message = parsed['message'].toString();
          }
        } catch (_) {}

        throw Exception(message);
      }
    } on TimeoutException {
      throw Exception(
        'İstek zaman aşımına uğradı. İnternet bağlantınızı kontrol edin.',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Toggle favorite for a movie id. Returns true on success.
  static Future<bool> toggleFavoriteById(String movieId) async {
    if (config.favoriteIdMovieApiUrl.isEmpty) {
      throw Exception(
        'Favorite URL tanımlı değil. Lütfen konfigürasyonu kontrol edin.',
      );
    }

    try {
      final token = await getAccessToken();

      // Build URI: support {id} placeholder, numeric trailing segment replacement, or append
      String base = config.favoriteIdMovieApiUrl;
      Uri uri;
      if (base.contains('{id}')) {
        uri = Uri.parse(base.replaceAll('{id}', movieId));
      } else {
        final parsed = Uri.parse(base);
        final segs = parsed.pathSegments;
        if (segs.isNotEmpty) {
          final last = segs.last;
          if (RegExp(r'^\d+\$').hasMatch(last) || last == '1') {
            final newSegs = <String>[]
              ..addAll(segs)
              ..removeLast()
              ..add(movieId);
            uri = parsed.replace(pathSegments: newSegs);
          } else {
            uri = parsed.replace(pathSegments: <String>[...segs, movieId]);
          }
        } else {
          uri = parsed.replace(pathSegments: [movieId]);
        }
      }

      final response = await http
          .post(
            uri,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json; charset=utf-8',
              'Authorization': token.isNotEmpty ? 'Bearer $token' : '',
            },
            body: json.encode({'id': movieId}),
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('ShartFlixAccesToken');
        throw Exception('Yetkilendirme başarısız. Lütfen tekrar giriş yapın.');
      }

      String message = 'İstek başarısız. Durum kodu: ${response.statusCode}';
      try {
        final parsed = json.decode(response.body);
        if (parsed is Map &&
            parsed.containsKey('response') &&
            parsed['response'] is Map) {
          final resp = parsed['response'] as Map<String, dynamic>;
          if (resp.containsKey('message') &&
              resp['message'].toString().isNotEmpty) {
            message = resp['message'].toString();
          }
        } else if (parsed is Map && parsed.containsKey('message')) {
          message = parsed['message'].toString();
        }
      } catch (_) {}

      throw Exception(message);
    } on TimeoutException {
      throw Exception(
        'İstek zaman aşımına uğradı. İnternet bağlantınızı kontrol edin.',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Get favorite movies for the current user. Returns FavoritesMovieModel.
  static Future<FavoritesMovieModel> getFavoriteMovies() async {
    if (config.favoritesMovieApiUrl.isEmpty) {
      throw Exception(
        'Favorites URL tanımlı değil. Lütfen konfigürasyonu kontrol edin.',
      );
    }

    try {
      final token = await getAccessToken();
      final uri = Uri.parse(config.favoritesMovieApiUrl);
      final response = await http
          .get(
            uri,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json; charset=utf-8',
              'Authorization': token.isNotEmpty ? 'Bearer $token' : '',
            },
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          return FavoritesMovieModel.fromJson(decoded);
        } else if (decoded is List) {
          // Wrap raw list into expected envelope
          final wrapped = {'response': null, 'data': decoded};
          return FavoritesMovieModel.fromJson(wrapped);
        } else {
          throw Exception('Beklenmeyen yanıt formatı.');
        }
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('ShartFlixAccesToken');
        throw Exception('Yetkilendirme başarısız. Lütfen tekrar giriş yapın.');
      }

      String message = 'İstek başarısız. Durum kodu: ${response.statusCode}';
      try {
        final parsed = json.decode(response.body);
        if (parsed is Map && parsed.containsKey('message')) {
          message = parsed['message'].toString();
        }
      } catch (_) {}
      throw Exception(message);
    } on TimeoutException {
      throw Exception(
        'İstek zaman aşımına uğradı. İnternet bağlantınızı kontrol edin.',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
