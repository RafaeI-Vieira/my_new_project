class Movie {
  final String id;
  final String title;
  final String? originalTitle;
  final String? posterPath;
  final String? overview;
  final List<int> genreIds;
  final bool isSeries;
  final String? releaseDate;
  final int? runtime;
  final List<String>? originCountry;
  final String? productionYear;
  final List<String>? genres;
  final int? numberOfEpisodes;
  final String? director;
  final List<String>? cast;
  final String? globoplayExpirationDate;

  Movie({
    required this.id,
    required this.title,
    this.originalTitle,
    this.posterPath,
    this.overview,
    required this.genreIds,
    required this.isSeries,
    this.releaseDate,
    this.runtime,
    this.originCountry,
    this.productionYear,
    this.genres,
    this.numberOfEpisodes,
    this.director,
    this.cast,
    this.globoplayExpirationDate,
  });

  /// Construtor de fábrica para criar um objeto `Movie` a partir de um JSON.
  factory Movie.fromJson(Map<String, dynamic> json) {
    final List<int> genreIds = List<int>.from(json['genre_ids'] ?? []);
    final bool isSeries = json['media_type'] == 'tv' || genreIds.contains(10765);

    final List<String>? originCountry =
        (json['origin_country'] as List<dynamic>?)?.map((e) => e.toString()).toList();

    final List<String>? genres = (json['genres'] as List<dynamic>?)
        ?.map((e) => e['name']?.toString() ?? 'Gênero desconhecido')
        .toList();

    final List<String>? cast = (json['credits']?['cast'] as List<dynamic>?)
        ?.map((actor) => actor['name'].toString())
        .toList();

    final String? director = (json['credits']?['crew'] as List<dynamic>?)
        ?.firstWhere((crewMember) => crewMember['job'] == 'Director', orElse: () => null)?['name'];

    return Movie(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? 'Título desconhecido',
      originalTitle: json['original_title'] ?? json['original_name'],
      posterPath: json['poster_path'],
      overview: json['overview'],
      genreIds: genreIds,
      isSeries: isSeries,
      releaseDate: json['release_date'] ?? json['first_air_date'],
      runtime: json['runtime'],
      originCountry: originCountry,
      productionYear: json['release_date']?.substring(0, 4) ??
          json['first_air_date']?.substring(0, 4),
      genres: genres,
      numberOfEpisodes: json['number_of_episodes'],
      director: director,
      cast: cast,
      globoplayExpirationDate: json['globoplay_expiration_date'],
    );
  }
}
