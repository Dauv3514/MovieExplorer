import 'package:flutter/material.dart';

import '../models/movie.dart';

class FavoritesProvider extends ChangeNotifier {
  final Map<String, Movie> _favoriteMoviesById = <String, Movie>{};

  List<Movie> get favoriteMovies => _favoriteMoviesById.values.toList();

  bool isFavorite(String imdbId) {
    return _favoriteMoviesById.containsKey(imdbId);
  }

  void toggleFavorite(Movie movie) {
    if (_favoriteMoviesById.containsKey(movie.imdbId)) {
      _favoriteMoviesById.remove(movie.imdbId);
    } else {
      _favoriteMoviesById[movie.imdbId] = movie;
    }

    notifyListeners();
  }
}