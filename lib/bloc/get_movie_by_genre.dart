import 'package:flutter/material.dart';
import 'package:moodymuch/helper/movie_api.dart';
import 'package:moodymuch/model/movie_response.dart';
import 'package:rxdart/rxdart.dart';

class MoviesListByGenreBloc {
  final MovieAPI _repository = MovieAPI();
  final BehaviorSubject<MovieResponse> _subject =
      BehaviorSubject<MovieResponse>();

  getMoviesByGenre(List<int> genreIDs, List<int> bannedIDs) async {
    MovieResponse response = await _repository.getMovieByGenre(genreIDs, bannedIDs);
    _subject.sink.add(response);
  }

  void drainStream(){ _subject.value = null; }
  @mustCallSuper
  void dispose() async{
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
  
}
final moviesByGenreBloc = MoviesListByGenreBloc();