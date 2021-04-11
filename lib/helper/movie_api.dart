
import 'package:dio/dio.dart';
import 'package:moodymuch/model/cast_response.dart';
import 'package:moodymuch/model/movie_detail_response.dart';
import 'package:moodymuch/model/movie_response.dart';

class MovieAPI {
  final String apiKey = "2b98c67795fa14ddf2d52fd0dd05cecb";
  static String mainUrl = "https://api.themoviedb.org/3";
  final Dio _dio = Dio();

  var movieUrl = "$mainUrl/movie";
  var discoverUrl = '$mainUrl/discover/movie';

  Future<MovieResponse> getMovieByGenre(int id) async {
    var params = {
      "api_key": apiKey, 
      "language": "en-US", 
      "page": 1, 
      "with_genres": id
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
      return MovieDetailResponse.fromJson(response.data);
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