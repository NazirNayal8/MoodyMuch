import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moodymuch/model/movie.dart';
import 'package:moodymuch/model/movie_detail.dart';
import 'package:moodymuch/size_config.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../constants.dart';

class BackdropAndRating extends StatelessWidget {
  const BackdropAndRating({
    Key key,
    @required this.size,
    @required this.movie,
  }) : super(key: key);

  final Size size;
  final MovieDetail movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      // 40% of our total height
      height: size.height * 0.4,
      child: Stack(
        children: <Widget>[
          Container(
            height: size.height * 0.4 - 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40)),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage("https://image.tmdb.org/t/p/w300/" + movie.backPoster),
              ),
            ),
          ),
          // Rating Box
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              // it will cover 90% of our total width
              width: size.width * 0.85,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 5),
                    blurRadius: 50,
                    color: Color(0xFF12153D).withOpacity(0.2),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset("assets/icons/star_fill.svg"),
                        SizedBox(height: kDefaultPadding / 4),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "${movie.rating}/",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              TextSpan(text: "10\n"),
                              TextSpan(
                                text: '${movie.voteCount}',
                                style: TextStyle(color: kTextLightColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularPercentIndicator(
                          radius: 60.0,
                          lineWidth: 8.0,
                          percent: movie.popularity,
                          center: Text(
                            percentage(movie.popularity),
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(12),
                              fontWeight: FontWeight.bold,
                              color: colorByPercentage(75),
                              height: 1.5,
                            ),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          backgroundColor: Colors.blueGrey.shade100,                         
                          maskFilter: MaskFilter.blur(BlurStyle.solid, 3),
                          progressColor: colorByPercentage(movie.popularity * 100),
                          
                        ),
                        SizedBox(height: kDefaultPadding / 4),
                        Text(
                          "Popularity",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    // Rate this
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset("assets/icons/star.svg"),
                        SizedBox(height: kDefaultPadding / 4),
                        Text("Rate This",
                            style: Theme.of(context).textTheme.bodyText2),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Back Button
          SafeArea(child: BackButton()),
        ],
      ),
    );
  }
}
