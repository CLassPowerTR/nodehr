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
    List<MovieModel> movies = <MovieModel>[];
    try {
      if (data is List) {
        movies = data
            .where((e) => e is Map)
            .map(
              (e) => MovieModel.fromJson(Map<String, dynamic>.from(e as Map)),
            )
            .toList();
      } else if (data is Map<String, dynamic>) {
        // If data contains 'movies' as a list, use it
        if (data.containsKey('movies') && data['movies'] is List) {
          final list = List<dynamic>.from(data['movies']);
          movies = list
              .where((e) => e is Map)
              .map(
                (e) => MovieModel.fromJson(Map<String, dynamic>.from(e as Map)),
              )
              .toList();
        } else {
          // If the map looks like a single movie object (has Title/Poster/_id), wrap it
          final looksLikeMovie =
              data.containsKey('Title') ||
              data.containsKey('Poster') ||
              data.containsKey('_id') ||
              data.containsKey('id');
          if (looksLikeMovie) {
            movies = [MovieModel.fromJson(Map<String, dynamic>.from(data))];
          } else {
            // Otherwise treat it as id->movie map and take values that are maps
            movies = data.values
                .where((e) => e is Map)
                .map(
                  (e) =>
                      MovieModel.fromJson(Map<String, dynamic>.from(e as Map)),
                )
                .toList();
          }
        }
      }
    } catch (_) {
      movies = <MovieModel>[];
    }

    return FavoritesMovieModel(movies: movies, response: resp);
  }
}
