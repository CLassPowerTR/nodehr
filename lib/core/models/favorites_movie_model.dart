import 'movies_model.dart';

class FavoritesMovieModel {
  final List<MovieModel> movies;
  final Map<String, dynamic>? response;

  FavoritesMovieModel({required this.movies, this.response});

  factory FavoritesMovieModel.fromJson(Map<String, dynamic> json) {
    final resp = (json['response'] is Map)
        ? Map<String, dynamic>.from(json['response'])
        : null;
    final data = json['data'];
    List<MovieModel> movies = [];
    try {
      if (data is List) {
        movies = data
            .map(
              (e) => MovieModel.fromJson(Map<String, dynamic>.from(e as Map)),
            )
            .toList();
      } else if (data is Map) {
        // if data is a map treat its values as movie objects
        movies = Map<String, dynamic>.from(data).values
            .map(
              (e) => MovieModel.fromJson(Map<String, dynamic>.from(e as Map)),
            )
            .toList();
      }
    } catch (_) {
      movies = [];
    }

    return FavoritesMovieModel(movies: movies, response: resp);
  }
}
