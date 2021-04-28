import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moodymuch/model/movie_detail.dart';
import '../../../constants.dart';
import 'package:url_launcher/url_launcher.dart';

class TitleDurationAndFabBtn extends StatelessWidget {
  const TitleDurationAndFabBtn({
    Key key,
    @required this.movie,
  }) : super(key: key);

  final MovieDetail movie;
  final String baseUrl = 'https://www.imdb.com/title/';

  _launchURL(String id) async {
    String url =  baseUrl + id;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kDefaultPadding),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(height: kDefaultPadding / 2),
                Row(
                  children: <Widget>[
                    Text(
                      movie.year,
                      style: TextStyle(color: kTextLightColor),
                    ),
                    SizedBox(width: kDefaultPadding),
                    Text(
                      movie.language.toUpperCase(),
                      style: TextStyle(color: kTextLightColor),
                    ),
                    SizedBox(width: kDefaultPadding),
                    Text(
                      movie.runtime.toString(),
                      style: TextStyle(color: kTextLightColor),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 64,
            width: 64,
            child: IconButton(
              tooltip: "Visit IMDb",
              onPressed: () async {
                await _launchURL(movie.imdbID);
              },
              icon: SvgPicture.asset("assets/icons/imdb.svg", cacheColorFilter: false)
            ),
          ),
        ],
      ),
    );
  }
}
