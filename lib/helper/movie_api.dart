import 'package:dio/dio.dart';
import 'package:moodymuch/model/cast_response.dart';
import 'package:moodymuch/model/movie_detail_response.dart';
import 'package:moodymuch/model/movie_response.dart';

class MovieAPI {
  final String apiKey = "2b98c67795fa14ddf2d52fd0dd05cecb";
  final String omdbKey = "ebf687a6";
  static String mainUrl = "https://api.themoviedb.org/3";
  final Dio _dio = Dio();

  var movieUrl = "$mainUrl/movie";
  var discoverUrl = '$mainUrl/discover/movie';
  var omdbUrl = "https://www.omdbapi.com/";

  String genreList(List<int> genres){
    String list = "";
    if(genres.length == 0) return list;
    
    for(int i = 0; i < genres.length - 1; i++){
      list += genres[i].toString();
      list += ",";
    }
    list += genres[genres.length - 1].toString();
    return list;
  }

  Future<MovieResponse> getMovieByGenre(List<int> genreIDs) async {
    var params = {
      "api_key": apiKey, 
      "language": "en-US",
      "page": 3,
      "with_genres": genreList(genreIDs),
      "with_original_language": "en",
      "vote_average.gte": 7.2
    };

    try {
      Response response = await _dio.get(discoverUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }
  
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    var params = {
      "api_key": apiKey,
      "language": "en-US"
    };

    try {
      Response response = await _dio.get(movieUrl + "/$id", queryParameters: params);
      Response details = await _dio.get(omdbUrl, queryParameters: {"i": response.data["imdb_id"], "apikey": omdbKey});
      return MovieDetailResponse.fromJson(details.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieDetailResponse.withError("$error");
    }
  }

  Future<CastResponse> getCasts(int id) async {
    var params = {
      "api_key": apiKey,
      "language": "en-US"
    };
    
    try {
      Response response = await _dio.get(movieUrl + "/$id" + "/credits", queryParameters: params);
      return CastResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return CastResponse.withError("$error");
    }
  }
}