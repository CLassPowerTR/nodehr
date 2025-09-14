import 'package:flutter/material.dart';
import 'package:nodehr/core/constants/app_colors.dart';
import 'package:nodehr/core/constants/app_paddings.dart';
import 'package:nodehr/core/constants/app_radius.dart';
import 'package:nodehr/core/constants/app_text_styles.dart';
import 'package:nodehr/core/models/movies_model.dart';

class MovieCard extends StatefulWidget {
  final VoidCallback onFavoriteToggle;
  final String? plot;
  final String? runtime;
  final MovieModel? movie;

  const MovieCard({
    super.key,
    required this.onFavoriteToggle,
    this.plot,
    this.runtime,
    this.movie,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.movie!.isFavorite;
  }

  @override
  void didUpdateWidget(covariant MovieCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.movie!.isFavorite != widget.movie!.isFavorite) {
      _isFavorite = widget.movie!.isFavorite;
    }
  }

  void _handleToggle() {
    // Optimistic UI update locally, then call external callback
    setState(() {
      _isFavorite = !_isFavorite;
    });
    try {
      widget.onFavoriteToggle();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.movie;
    return Container(
      width: double.infinity,
      // Provide a reasonable max height so children with Flex don't receive
      // unbounded constraints which can lead to rendering/semantics errors.
      constraints: const BoxConstraints(minHeight: 120, maxHeight: 220),
      decoration: BoxDecoration(
        borderRadius: AppRadius.r24,
        color: AppColors.background,
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Poster: use flexible width and fixed aspect ratio so it never overflows
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.38,
              minWidth: 80,
            ),
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: m != null && m.poster.isNotEmpty
                  ? ClipRRect(
                      borderRadius: AppRadius.r24,
                      child: Image.network(
                        _sanitizeUrl(m.poster),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _errorPlaceholder(context),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.r24,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.05),
                      ),
                      child: const Center(
                        child: Icon(Icons.image_not_supported),
                      ),
                    ),
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: AppPaddings.all12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m?.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      m?.plot ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(m?.runtime ?? '', style: AppTextStyles.body1),
                      IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.redAccent : null,
                        ),
                        onPressed: _handleToggle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _sanitizeUrl(String url) {
  var u = url.trim();
  if (u.startsWith('http://')) {
    // Bazı kaynaklar http döndürür; çoğu cihazda https gerekli olabilir
    u = u.replaceFirst('http://', 'https://');
  }
  // Geçersiz @.. vb. karakterleri barındırıyorsa yine de döndür ama errorBuilder yakalar
  return u;
}

Widget _errorPlaceholder(BuildContext context) {
  return Container(
    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
    child: const Center(child: Icon(Icons.broken_image)),
  );
}
