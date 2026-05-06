import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/movie.dart';

class OmdbService {
  OmdbService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _baseUrl = 'www.omdbapi.com';

  Future<List<Movie>> searchMovies(String query) async {
    final apiKey = dotenv.env['OMDB_API_KEY']?.trim() ?? '';

    if (apiKey.isEmpty) {
      throw const OmdbException(
        'Cle API manquante. Ajoute OMDB_API_KEY dans le fichier .env.',
      );
    }

    final uri = Uri.https(_baseUrl, '/', {'apikey': apiKey, 's': query});

    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw OmdbException(
        'Erreur HTTP ${response.statusCode}. Reessaie plus tard.',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final isSuccess = data['Response'] == 'True';

    if (!isSuccess) {
      final errorMessage = data['Error'] as String? ?? '';

      if (errorMessage == 'Movie not found!') {
        return const [];
      }

      throw OmdbException(
        errorMessage.isEmpty
            ? 'Une erreur est survenue pendant la recherche.'
            : errorMessage,
      );
    }

    final results = data['Search'] as List<dynamic>? ?? <dynamic>[];

    return results
        .map((movieJson) => Movie.fromJson(movieJson as Map<String, dynamic>))
        .toList();
  }
}

class OmdbException implements Exception {
  const OmdbException(this.message);

  final String message;

  @override
  String toString() => message;
}