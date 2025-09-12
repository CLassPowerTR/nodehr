import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nodehr/core/constants/app_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:nodehr/core/constants/app_strings.dart';
import 'package:nodehr/features/home/providers/favorites_provider.dart';
import 'package:nodehr/core/api/services/api_service.dart';
import 'package:nodehr/core/models/profile_model.dart';
import 'package:nodehr/core/models/movies_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File? _photo;
  ProfileModel? _profile;
  List<MovieModel> _favorites = <MovieModel>[];
  bool _loading = false;
  String? _error;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: source, maxWidth: 1024);
    if (result != null) {
      setState(() => _photo = File(result.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    // favorites can come from _favorites (MovieModel) or from the local
    // FavoritesProvider (MovieItem). Use a dynamic list and resolve the
    // poster field at runtime to avoid a static type of Object.
    final List<dynamic> likedMovies = _favorites.isNotEmpty
        ? _favorites
        : favoritesProvider.likedMovies;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.profile),
        centerTitle: true,
        titleTextStyle: AppTextStyles.h1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: _photo != null
                      ? FileImage(_photo!)
                      : (_profile?.photoUrl != null
                            ? NetworkImage(_profile!.photoUrl!) as ImageProvider
                            : null),
                  child: _photo == null
                      ? (_profile == null
                            ? const Icon(Icons.person, size: 40)
                            : null)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _profile?.name ?? 'John Doe',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            icon: const Icon(Icons.photo_library_outlined),
                            label: const Text('Galeriden'),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: () => _pickImage(ImageSource.camera),
                            icon: const Icon(Icons.photo_camera_outlined),
                            label: const Text('Kamera'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.favorites,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (_loading) const Center(child: CircularProgressIndicator()),
            if (_error != null) Center(child: Text(_error!)),

            if (!_loading && _error == null)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.66,
                ),
                itemCount: likedMovies.length,
                itemBuilder: (context, index) {
                  final movie = likedMovies[index];
                  String posterUrl = '';
                  if (movie is MovieModel) {
                    posterUrl = movie.poster;
                  } else if (movie is MovieItem) {
                    posterUrl = movie.posterUrl;
                  }
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: posterUrl.isNotEmpty
                        ? Image.network(posterUrl, fit: BoxFit.cover)
                        : Container(color: Colors.grey[300]),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProfileAndFavorites();
  }

  Future<void> _loadProfileAndFavorites() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final profiles = await ApiService.getMyProfile();
      if (profiles.isNotEmpty) {
        _profile = profiles.first;
      }
      final favs = await ApiService.getFavoriteMovies();
      // FavoritesMovieModel contains a `movies` list parsed from the API's data array
      _favorites = favs.movies;
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
