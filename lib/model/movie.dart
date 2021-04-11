class Movie {
  final int id;
  final String title;
  final String poster;
  final double rating;
  final String year;

  Movie(
    this.id,
    this.title,
    this.poster,
    this.rating,
    this.year,
  );

  Movie.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        poster = json["poster_path"],
        rating = json["vote_average"].toDouble(),
        year = json["release_date"].toString().split("-")[0];
}
