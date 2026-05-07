class Movie {
  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.posterUrl,
  });

  final String imdbId;
  final String title;
  final String year;
  final String posterUrl;

  static const String posterNotAvailable = 'N/A';

  bool get hasPoster => posterUrl.isNotEmpty && posterUrl != posterNotAvailable;

  Map<String, String> toMap() {
    return {
      'imdbID': imdbId,
      'Title': title,
      'Year': year,
      'Poster': posterUrl,
    };
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbId: json['imdbID'] as String? ?? '',
      title: json['Title'] as String? ?? 'Titre inconnu',
      year: json['Year'] as String? ?? 'Annee inconnue',
      posterUrl: json['Poster'] as String? ?? posterNotAvailable,
    );
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie.fromJson(map);
  }
}