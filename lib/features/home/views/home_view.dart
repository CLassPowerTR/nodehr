import 'package:flutter/material.dart';
import 'package:nodehr/core/constants/app_paddings.dart';
import 'package:provider/provider.dart';
import 'package:nodehr/core/constants/app_strings.dart';
import 'package:nodehr/core/widgets/cards/movie_card.dart';
import 'package:nodehr/core/extensions/app/bottom_sheet_ext.dart';
import 'package:nodehr/core/widgets/bottom_sheet/limited_offer_sheet.dart';
import 'package:nodehr/features/home/providers/favorites_provider.dart';
import 'package:nodehr/features/home/providers/all_movies_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final allMoviesProvider = context.watch<AllMoviesProvider>();

    final int totalPages = allMoviesProvider.totalPages;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_offer_outlined),
            onPressed: () => context.presentSheet(const LimitedOfferSheet()),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: totalPages,
                  onPageChanged: (pageIndex) {
                    final newPage = pageIndex + 1; // pages are 1-based in API
                    // update UI current page only; provider already has all data
                    allMoviesProvider.setCurrentPage(newPage);
                    setState(() {});
                  },
                  itemBuilder: (context, pageIndex) {
                    final page = pageIndex + 1;
                    final movies = allMoviesProvider.moviesForPage(page);
                    if (allMoviesProvider.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (allMoviesProvider.error != null) {
                      return Center(child: Text(allMoviesProvider.error!));
                    }

                    return ListView.separated(
                      padding: AppPaddings.all16,
                      itemCount: movies.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final movie = movies[index];
                        return MovieCard(
                          movie: movie,
                          onFavoriteToggle: () async {
                            // Await the provider toggle so HomeView can react if needed.
                            await favoritesProvider.toggleLike(movie.id);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              // simple pager indicator
              if (totalPages > 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(totalPages, (i) {
                      final pageIndex = i + 1;
                      final isSelected =
                          allMoviesProvider.currentPage == pageIndex;
                      return GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            i,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: isSelected ? 18 : 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).disabledColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),

          // overlay when any favorite toggle is pending
          if (favoritesProvider.hasPending)
            Positioned.fill(
              child: IgnorePointer(
                ignoring: false,
                child: Container(
                  color: Colors.black.withOpacity(0.35),
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
