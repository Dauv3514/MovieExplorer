import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/movie.dart';

class FavoritesProvider extends ChangeNotifier {
  FavoritesProvider({required SharedPreferences preferences})
    : _preferences = preferences {
    _loadFavorites();
  }

  static const String _favoritesKey = 'favorite_movies';

  final Map<String, Movie> _favoriteMoviesById = <String, Movie>{};
  final SharedPreferences _preferences;

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

    _saveFavorites();
    notifyListeners();
  }

  void _loadFavorites() {
    final storedFavorites =
        _preferences.getStringList(_favoritesKey) ?? <String>[];

    for (final favorite in storedFavorites) {
      final map = jsonDecode(favorite) as Map<String, dynamic>;
      final movie = Movie.fromMap(map);
      _favoriteMoviesById[movie.imdbId] = movie;
    }
  }

  Future<void> _saveFavorites() async {
    final serializedFavorites = _favoriteMoviesById.values
        .map((movie) => jsonEncode(movie.toMap()))
        .toList();

    await _preferences.setStringList(_favoritesKey, serializedFavorites);
  }
}