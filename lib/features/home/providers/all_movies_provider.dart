import 'package:flutter/foundation.dart';
import 'package:nodehr/core/api/services/api_service.dart';
import 'package:nodehr/core/models/movies_model.dart';

class AllMoviesProvider extends ChangeNotifier {
  List<MovieModel> _movies = <MovieModel>[];
  int _currentPage = 1;
  PaginationModel? _pagination;
  bool _loading = false;
  String? _error;

  List<MovieModel> get movies => _movies;
  int get currentPage => _currentPage;
  PaginationModel? get pagination => _pagination;
  int get totalPages => _pagination?.maxPage ?? 1;
  bool get loading => _loading;
  String? get error => _error;

  AllMoviesProvider() {
    fetchAllPages();
  }
  Future<void> fetchAllPages() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch first page to get pagination info
      final first = await ApiService.getMovies(1);
      _movies = List<MovieModel>.from(first.movies);
      _pagination = first.pagination;
      _currentPage = 1;

      final int maxPage = _pagination?.maxPage ?? 1;
      for (int p = 2; p <= maxPage; p++) {
        final pageResult = await ApiService.getMovies(p);
        _movies.addAll(pageResult.movies);
      }
    } catch (e) {
      _error = e.toString();
      _movies = <MovieModel>[];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Return the movies that belong to the given 1-based page index using server perPage.
  List<MovieModel> moviesForPage(int page) {
    final per = pagination?.perPage ?? 10;
    final start = (page - 1) * per;
    if (start >= _movies.length) return <MovieModel>[];
    final end = (start + per) > _movies.length ? _movies.length : (start + per);
    return _movies.sublist(start, end);
  }

  int get perPage => pagination?.perPage ?? 10;

  /// Update current page (UI state only)
  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }
}
