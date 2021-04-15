import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moodymuch/model/movie_detail.dart';
import 'package:moodymuch/constants.dart';

class BackdropAndRating extends StatefulWidget {
  final Size size;
  final MovieDetail movie;
  final String backdrop;

  const BackdropAndRating({
    Key key,
    @required this.size,
    @required this.movie,
    @required this.backdrop
  }) : super(key: key);

  BackdropAndRatingState createState() => BackdropAndRatingState(size, movie, backdrop);
}


class BackdropAndRatingState extends State<BackdropAndRating> {

  final Size size;
  final MovieDetail movie;
  final String backdrop;

  BackdropAndRatingState(this.size, this.movie, this.backdrop);

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
                image: NetworkImage("https://image.tmdb.org/t/p/original" + backdrop),
              ),
            ),
          ),
          // Rating Box
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
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
                                text: movie.rating,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: "/10\n",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600
                                  ),
                              ),
                              TextSpan(
                                text: movie.voteCount,
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
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Color(0xFF51CF66),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            movie.metascore + "/100",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: kDefaultPadding / 4),
                        Text(
                          "Metascore",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    // Rate this
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Color(0xFF51CF66),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            movie.rotten,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: kDefaultPadding / 4),
                        Text(
                          "Rotten Tomatoes",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
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

  // void _showRatingDialog() {
  //   final _dialog = RatingDialog(
  //     title: 'Rate Movie',
  //     // encourage your user to leave a high rating?
  //     message:
  //         'Tap a star to set your rating',
  //     // your app's logo?
  //     image: const FlutterLogo(size: 100),
  //     submitButton: 'Submit',
  //     onSubmitted: (response) {
  //       print('rating: ${response.rating}');
  //     },
  //   );

  //   showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (context) => _dialog,
  //   );
  // }
}
