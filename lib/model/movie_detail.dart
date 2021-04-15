class MovieDetail {
  final int id;
  final String imdbID;
  final String title;
  final String overview;
  final String rating;
  final String voteCount;
  final String runtime;
  final String year;
  final String language;
  final List<String> genres;
  final String metascore;
  final String rotten;

  MovieDetail(
    this.id,
    this.imdbID,
    this.title,
    this.overview,
    this.rating,
    this.voteCount,
    this.runtime,
    this.year,
    this.language,
    this.genres,
    this.metascore,
    this.rotten
  );

  MovieDetail.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        imdbID = json["imdbID"],
        title = json["Title"],
        overview = json["Plot"],
        rating = json["imdbRating"],
        voteCount = json["imdbVotes"],
        runtime = json["Runtime"],
        year = json["Year"],
        language = json["Language"].toString().split(", ")[0],
        genres = json["Genre"].toString().split(", ").toList(),
        metascore = json["Metascore"],
        rotten = json["Ratings"].length > 1 ? json["Ratings"][1]["Value"] : "N/A";

        // ratings: metacritics, rotten tomatoes
}
