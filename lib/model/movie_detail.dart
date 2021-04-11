import 'package:moodymuch/model/genre.dart';

class MovieDetail {
  final int id;
  final double popularity;
  final String title;
  final String backPoster;
  final String poster;
  final String overview;
  final double rating;
  final int voteCount;
  final int runtime;
  final String year;
  final String language;
  final List<Genre> genres;

  MovieDetail(
    this.id,
    this.popularity,
    this.title,
    this.backPoster,
    this.poster,
    this.overview,
    this.rating,
    this.voteCount,
    this.runtime,
    this.year,
    this.language,
    this.genres
  );

  MovieDetail.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        popularity = json["popularity"],
        title = json["title"],
        backPoster = json["backdrop_path"],
        poster = json["poster_path"],
        overview = json["overview"],
        rating = json["vote_average"].toDouble(),
        voteCount = json["vote_count"],
        runtime = json["runtime"],
        year = json["release_date"].toString().split("-")[0],
        language = json["original_language"],
        genres = (json["genres"] as List).map((i) => new Genre.fromJson(i)).toList();
}
