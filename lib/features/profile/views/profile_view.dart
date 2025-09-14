import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nodehr/core/constants/app_paddings.dart';
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

  String _sanitizeUrl(String url) {
    var u = url.trim();
    if (u.startsWith('http://')) {
      u = u.replaceFirst('http://', 'https://');
    }
    return u;
  }

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
    // Favorileri tek tipe (poster URL listesi) dönüştürerek tip sorunlarını önle
    final List<String> posterUrls = _favorites.isNotEmpty
        ? _favorites
              .map((m) => m.poster)
              .where((p) => p.isNotEmpty)
              .toList(growable: false)
        : favoritesProvider.likedMovies
              .map((m) => m.posterUrl)
              .where((p) => p.isNotEmpty)
              .toList(growable: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.profile),
        centerTitle: true,
        titleTextStyle: AppTextStyles.h1,
      ),
      body: SingleChildScrollView(
        padding: AppPaddings.all16,
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
                        _profile?.name ?? 'Batuhan',
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
            if (_error != null)
              Builder(
                builder: (context) {
                  print(_error);
                  return Center(child: Text(_error!));
                },
              ),

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
                itemCount: posterUrls.length,
                itemBuilder: (context, index) {
                  final String posterUrl = posterUrls[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: posterUrl.isNotEmpty
                        ? Image.network(
                            _sanitizeUrl(posterUrl),
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, st) => Container(
                              color: Colors.grey[300],
                              alignment: Alignment.center,
                              child: const Icon(Icons.broken_image),
                            ),
                          )
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
      final raw = await ApiService.getFavoriteMovies();
      // raw List<dynamic> -> List<MovieModel>
      _favorites = raw
          .where((e) => e is Map)
          .map((e) => MovieModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(growable: false);
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
