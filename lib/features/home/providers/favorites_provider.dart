import 'package:flutter/foundation.dart';
import 'package:nodehr/core/api/services/api_service.dart';

class MovieItem {
  final String id;
  final String title;
  final String posterUrl;

  const MovieItem({
    required this.id,
    required this.title,
    required this.posterUrl,
  });
}

class FavoritesProvider extends ChangeNotifier {
  final List<MovieItem> _movies = const [
    MovieItem(
      id: '1',
      title: 'The Matrix',
      posterUrl: 'https://picsum.photos/200/300?random=1',
    ),
    MovieItem(
      id: '2',
      title: 'Inception',
      posterUrl: 'https://picsum.photos/200/300?random=2',
    ),
    MovieItem(
      id: '3',
      title: 'Interstellar',
      posterUrl: 'https://picsum.photos/200/300?random=3',
    ),
    MovieItem(
      id: '4',
      title: 'Blade Runner 2049',
      posterUrl: 'https://picsum.photos/200/300?random=4',
    ),
  ];

  final Set<String> _likedIds = <String>{};
  final Set<String> _pendingIds = <String>{};

  List<MovieItem> get movies => _movies;
  bool isLiked(String id) => _likedIds.contains(id);

  List<MovieItem> get likedMovies =>
      _movies.where((m) => _likedIds.contains(m.id)).toList(growable: false);

  bool isPending(String id) => _pendingIds.contains(id);

  bool get hasPending => _pendingIds.isNotEmpty;
  Future<bool> toggleLike(String id) async {
    // If already pending for this id, ignore duplicate toggles
    if (_pendingIds.contains(id)) return false;

    final wasLiked = _likedIds.contains(id);
    // mark pending
    _pendingIds.add(id);
    // optimistic local change
    if (wasLiked) {
      _likedIds.remove(id);
    } else {
      _likedIds.add(id);
    }
    notifyListeners();

    try {
      final success = await ApiService.toggleFavoriteById(id);
      _pendingIds.remove(id);
      if (!success) {
        // revert optimistic change
        if (wasLiked) {
          _likedIds.add(id);
        } else {
          _likedIds.remove(id);
        }
      }
      notifyListeners();
      return success;
    } catch (e) {
      // revert optimistic change on failure
      _pendingIds.remove(id);
      if (wasLiked) {
        _likedIds.add(id);
      } else {
        _likedIds.remove(id);
      }
      notifyListeners();
      return false;
    }
  }
}
