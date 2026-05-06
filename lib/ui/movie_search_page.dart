import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';
import '../providers/favorites_provider.dart';
import '../services/omdb_service.dart';
import 'favorites_page.dart';
import 'movie_detail_page.dart';

class MovieSearchPage extends StatefulWidget {
  const MovieSearchPage({super.key, this.service});

  final OmdbService? service;

  @override
  State<MovieSearchPage> createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  late final OmdbService _service;
  List<Movie> _movies = const [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? context.read<OmdbService>();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchMovies() async {
    final query = _searchController.text.trim();

    FocusScope.of(context).unfocus();

    if (query.isEmpty) {
      setState(() {
        _hasSearched = true;
        _movies = const [];
        _errorMessage = 'Saisis un titre de film avant de lancer la recherche.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _hasSearched = true;
      _movies = const [];
    });

    try {
      final movies = await _service.searchMovies(query);

      if (!mounted) {
        return;
      }

      setState(() {
        _movies = movies;
        _errorMessage = null;
      });
    } on OmdbException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Une erreur inattendue est survenue.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Explorer'),
        actions: [
          IconButton(
            onPressed: _openFavoritesPage,
            icon: const Icon(Icons.star),
            tooltip: 'Favoris',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _searchMovies(),
              decoration: const InputDecoration(
                labelText: 'Rechercher un film',
                hintText: 'Exemple : Batman',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isLoading ? null : _searchMovies,
              child: const Text('Rechercher'),
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildContent(favoritesProvider)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(FavoritesProvider favoritesProvider) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!, textAlign: TextAlign.center));
    }

    if (_movies.isEmpty) {
      if (!_hasSearched) {
        return const Center(
          child: Text(
            'Lance une recherche pour afficher des films.',
            textAlign: TextAlign.center,
          ),
        );
      }

      return const Center(
        child: Text('Aucun film trouve.', textAlign: TextAlign.center),
      );
    }

    return ListView.separated(
      itemCount: _movies.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final movie = _movies[index];

        return _MovieCard(
          movie: movie,
          isFavorite: favoritesProvider.isFavorite(movie.imdbId),
          onTap: () => _openMovieDetails(movie),
          onToggleFavorite: () => favoritesProvider.toggleFavorite(movie),
        );
      },
    );
  }

  Future<void> _openMovieDetails(Movie movie) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => MovieDetailPage(movie: movie, service: _service),
      ),
    );
  }

  Future<void> _openFavoritesPage() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => const FavoritesPage()),
    );
  }
}

class _MovieCard extends StatelessWidget {
  const _MovieCard({
    required this.movie,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final Movie movie;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MoviePoster(movie: movie),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text('Annee : ${movie.year}'),
                  ],
                ),
              ),
              IconButton(
                onPressed: onToggleFavorite,
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                tooltip: isFavorite
                    ? 'Retirer des favoris'
                    : 'Ajouter aux favoris',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  const _MoviePoster({required this.movie});

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