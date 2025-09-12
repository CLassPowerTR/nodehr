// Model classes for movies list and pagination
class MovieModel {
  final String id;
  final String sId;
  final String title;
  final String year;
  final String rated;
  final String released;
  final String runtime;
  final String genre;
  final String director;
  final String writer;
  final String actors;
  final String plot;
  final String language;
  final String country;
  final String awards;
  final String poster;
  final String metascore;
  final String imdbRating;
  final String imdbVotes;
  final String imdbID;
  final String type;
  final String response;
  final List<String> images;
  final bool comingSoon;
  final bool isFavorite;

  MovieModel({
    required this.id,
    required this.sId,
    required this.title,
    required this.year,
    required this.rated,
    required this.released,
    required this.runtime,
    required this.genre,
    required this.director,
    required this.writer,
    required this.actors,
    required this.plot,
    required this.language,
    required this.country,
    required this.awards,
    required this.poster,
    required this.metascore,
    required this.imdbRating,
    required this.imdbVotes,
    required this.imdbID,
    required this.type,
    required this.response,
    required this.images,
    required this.comingSoon,
    required this.isFavorite,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    List<String> _images = <String>[];
    try {
      if (json['Images'] is List) {
        _images = List<dynamic>.from(
          json['Images'],
        ).map((e) => e.toString()).toList();
      }
    } catch (_) {}

    return MovieModel(
      id: (json['id'] ?? '').toString(),
      sId: (json['_id'] ?? '').toString(),
      title: (json['Title'] ?? '').toString(),
      year: (json['Year'] ?? '').toString(),
      rated: (json['Rated'] ?? '').toString(),
      released: (json['Released'] ?? '').toString(),
      runtime: (json['Runtime'] ?? '').toString(),
      genre: (json['Genre'] ?? '').toString(),
      director: (json['Director'] ?? '').toString(),
      writer: (json['Writer'] ?? '').toString(),
      actors: (json['Actors'] ?? '').toString(),
      plot: (json['Plot'] ?? '').toString(),
      language: (json['Language'] ?? '').toString(),
      country: (json['Country'] ?? '').toString(),
      awards: (json['Awards'] ?? '').toString(),
      poster: (json['Poster'] ?? '').toString(),
      metascore: (json['Metascore'] ?? '').toString(),
      imdbRating: (json['imdbRating'] ?? '').toString(),
      imdbVotes: (json['imdbVotes'] ?? '').toString(),
      imdbID: (json['imdbID'] ?? '').toString(),
      type: (json['Type'] ?? '').toString(),
      response: (json['Response'] ?? '').toString(),
      images: _images,
      comingSoon: (json['ComingSoon'] is bool)
          ? json['ComingSoon'] as bool
          : (json['ComingSoon'].toString().toLowerCase() == 'true'),
      isFavorite: (json['isFavorite'] is bool)
          ? json['isFavorite'] as bool
          : (json['isFavorite'].toString().toLowerCase() == 'true'),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    '_id': sId,
    'Title': title,
    'Year': year,
    'Rated': rated,
    'Released': released,
    'Runtime': runtime,
    'Genre': genre,
    'Director': director,
    'Writer': writer,
    'Actors': actors,
    'Plot': plot,
    'Language': language,
    'Country': country,
    'Awards': awards,
    'Poster': poster,
    'Metascore': metascore,
    'imdbRating': imdbRating,
    'imdbVotes': imdbVotes,
    'imdbID': imdbID,
    'Type': type,
    'Response': response,
    'Images': images,
    'ComingSoon': comingSoon,
    'isFavorite': isFavorite,
  };
}

class PaginationModel {
  final int totalCount;
  final int perPage;
  final int maxPage;
  final int currentPage;

  PaginationModel({
    required this.totalCount,
    required this.perPage,
    required this.maxPage,
    required this.currentPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return PaginationModel(
        totalCount: 0,
        perPage: 0,
        maxPage: 0,
        currentPage: 0,
      );
    }
    return PaginationModel(
      totalCount: (json['totalCount'] ?? 0) is int
          ? json['totalCount'] as int
          : int.tryParse(json['totalCount'].toString()) ?? 0,
      perPage: (json['perPage'] ?? 0) is int
          ? json['perPage'] as int
          : int.tryParse(json['perPage'].toString()) ?? 0,
      maxPage: (json['maxPage'] ?? 0) is int
          ? json['maxPage'] as int
          : int.tryParse(json['maxPage'].toString()) ?? 0,
      currentPage: (json['currentPage'] ?? 0) is int
          ? json['currentPage'] as int
          : int.tryParse(json['currentPage'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalCount': totalCount,
    'perPage': perPage,
    'maxPage': maxPage,
    'currentPage': currentPage,
  };
}

class MoviesListModel {
  final List<MovieModel> movies;
  final PaginationModel pagination;

  MoviesListModel({required this.movies, required this.pagination});

  factory MoviesListModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? <String, dynamic>{};
    final dynamic rawMovies = data['movies'];
    List<dynamic> moviesJson = <dynamic>[];
    try {
      if (rawMovies is List) {
        moviesJson = List<dynamic>.from(rawMovies);
      } else if (rawMovies is Map) {
        // If API returns a single movie object (Map with movie fields), wrap it
        // into a single-element list. If API returns a map of id->movie, take values.
        final map = Map<String, dynamic>.from(rawMovies);
        final hasMovieShape =
            map.containsKey('Title') ||
            map.containsKey('Poster') ||
            map.containsKey('_id') ||
            map.containsKey('id');
        if (hasMovieShape) {
          moviesJson = [map];
        } else {
          moviesJson = map.values.toList();
        }
      }
    } catch (_) {
      moviesJson = <dynamic>[];
    }
    final movies = moviesJson
        .map((e) => MovieModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    final pagination = PaginationModel.fromJson(
      (data['pagination'] as Map<String, dynamic>?) ?? <String, dynamic>{},
    );
    return MoviesListModel(movies: movies, pagination: pagination);
  }

  Map<String, dynamic> toJson() => {
    'data': {
      'movies': movies.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    },
  };
}
