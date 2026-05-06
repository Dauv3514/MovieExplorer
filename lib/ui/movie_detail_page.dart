import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../models/movie_details.dart';
import '../services/omdb_service.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({
    super.key,
    required this.movie,
    required this.service,
  });

  final Movie movie;
  final OmdbService service;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  MovieDetails? _movieDetails;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMovieDetails();
  }

  Future<void> _loadMovieDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final movieDetails = await widget.service.getMovieDetails(
        widget.movie.imdbId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _movieDetails = movieDetails;
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
    return Scaffold(
      appBar: AppBar(title: const Text('Detail du film')),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_errorMessage!, textAlign: TextAlign.center),
        ),
      );
    }

    final movieDetails = _movieDetails;

    if (movieDetails == null) {
      return const Center(
        child: Text('Aucun detail disponible.', textAlign: TextAlign.center),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: _MovieDetailsPoster(movieDetails: movieDetails)),
          const SizedBox(height: 16),
          Text(
            movieDetails.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text('Annee : ${movieDetails.year}'),
          const SizedBox(height: 16),
          _DetailSection(label: 'Description', value: movieDetails.description),
          const SizedBox(height: 16),
          _DetailSection(label: 'Acteurs', value: movieDetails.actors),
          const SizedBox(height: 16),
          _DetailSection(label: 'Note IMDb', value: movieDetails.rating),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        Text(value),
      ],
    );
  }
}

class _MovieDetailsPoster extends StatelessWidget {
  const _MovieDetailsPoster({required this.movieDetails});

  final MovieDetails movieDetails;

  @override
  Widget build(BuildContext context) {
    if (!movieDetails.hasPoster) {
      return Container(
        width: 180,
        height: 260,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.movie, size: 56),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        movieDetails.posterUrl,
        width: 180,
        height: 260,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 180,
            height: 260,
            alignment: Alignment.center,
            color: Colors.grey.shade300,
            child: const Icon(Icons.broken_image, size: 56),
          );
        },
      ),
    );
  }
}