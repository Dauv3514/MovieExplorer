class MovieDetails {
  const MovieDetails({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.posterUrl,
    required this.description,
    required this.actors,
    required this.rating,
  });

  final String imdbId;
  final String title;
  final String year;
  final String posterUrl;
  final String description;
  final String actors;
  final String rating;

  static const String posterNotAvailable = 'N/A';

  bool get hasPoster => posterUrl.isNotEmpty && posterUrl != posterNotAvailable;

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      imdbId: json['imdbID'] as String? ?? '',
      title: json['Title'] as String? ?? 'Titre inconnu',
      year: json['Year'] as String? ?? 'Annee inconnue',
      posterUrl: json['Poster'] as String? ?? posterNotAvailable,
      description: json['Plot'] as String? ?? 'Description indisponible.',
      actors: json['Actors'] as String? ?? 'Acteurs indisponibles.',
      rating: json['imdbRating'] as String? ?? 'Note indisponible',
    );
  }
}