import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';
import '../providers/favorites_provider.dart';
import 'movie_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final favoriteMovies = favoritesProvider.favoriteMovies;

    return Scaffold(
      appBar: AppBar(title: const Text('Favoris')),
      body: favoriteMovies.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Aucun film en favori pour le moment.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteMovies.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];

                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => MovieDetailPage(movie: movie),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FavoriteMoviePoster(movie: movie),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text('Annee : ${movie.year}'),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                favoritesProvider.toggleFavorite(movie),
                            icon: const Icon(Icons.star, color: Colors.amber),
                            tooltip: 'Retirer des favoris',
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _FavoriteMoviePoster extends StatelessWidget {
  const _FavoriteMoviePoster({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    if (!movie.hasPoster) {
      return Container(
        width: 80,
        height: 120,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.movie, size: 36),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        movie.posterUrl,
        width: 80,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 80,
            height: 120,
            alignment: Alignment.center,
            color: Colors.grey.shade300,
            child: const Icon(Icons.broken_image, size: 36),
          );
        },
      ),
    );
  }
}