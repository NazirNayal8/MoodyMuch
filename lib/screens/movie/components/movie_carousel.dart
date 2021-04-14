import 'package:flutter/material.dart';
import 'package:moodymuch/bloc/get_movie_by_genre.dart';
import 'package:moodymuch/model/movie.dart';
import 'package:moodymuch/model/movie_response.dart';
import 'package:moodymuch/size_config.dart';
import 'package:moodymuch/constants.dart';
import 'movie_card.dart';
import 'dart:math' as math;


class MovieCarousel extends StatefulWidget {
  final List<int> genreIDs;
  final List<int> bannedIDs;
  MovieCarousel({Key key, @required this.genreIDs, @required this.bannedIDs}) : super(key: key);
  @override
  _MovieCarouselState createState() => _MovieCarouselState(genreIDs, bannedIDs);
}

class _MovieCarouselState extends State<MovieCarousel> {

  final List<int> genreIDs;
  final List<int> bannedIDs;
  _MovieCarouselState(this.genreIDs, this.bannedIDs);

  PageController _pageController;
  int initialPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: initialPage,
    );
    moviesByGenreBloc..getMoviesByGenre(genreIDs, bannedIDs);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    moviesByGenreBloc..drainStream();
  }

  @override
  Widget build(BuildContext context){
    return StreamBuilder<MovieResponse>(
      stream: moviesByGenreBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return _buildErrorWidget(snapshot.data.error);
          }
          return buildBody(snapshot.data);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }
  
  Widget buildBody(MovieResponse data) {
    List<Movie> movies = data.movies;
    movies.shuffle();
    movies = movies.sublist(0,10);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      child: AspectRatio(
        aspectRatio: 0.85,
        child: PageView.builder(
          onPageChanged: (value) {
            initialPage = value;
          },
          controller: _pageController,
          physics: ClampingScrollPhysics(),
          itemCount: movies.length,
          itemBuilder: (context, index) => buildMovieSlider(index, movies[index]),
        ),
      ),
    );
  }

  Widget buildMovieSlider(int index, Movie movie) => AnimatedBuilder(
    animation: _pageController,
    builder: (context, child) {
      double value = 0;
      if (_pageController.position.haveDimensions) {
        value = index - _pageController.page;
        value = (value * 0.038).clamp(-1, 1);
      }
      return AnimatedOpacity(
        duration: Duration(milliseconds: 350),
        opacity: initialPage == index ? 1 : 0.4,
        child: Transform.rotate(
          angle: math.pi * value,
          child: MovieCard(movie: movie),
        ),
      );
    },
  );

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
          SizedBox(
            height: getProportionateScreenHeight(100),
            width: getProportionateScreenWidth(100),
            child: CircularProgressIndicator(
              valueColor:
                new AlwaysStoppedAnimation<Color>(kPrimaryColor),
              strokeWidth: 10.0,
            ),
          )
        ],
      )
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Error occured: $error"),
        ],
      )
    );
  }
}
