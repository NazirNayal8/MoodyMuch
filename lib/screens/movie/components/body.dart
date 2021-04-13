import 'package:flutter/material.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/size_config.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'movie_carousel.dart';

class Body extends StatelessWidget {
  final List<int> genreIDs;
  final List<int> bannedIDs;
  Body({Key key, @required this.genreIDs, @required this.bannedIDs}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    double mood = 50;
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("Mood", style: headingStyle),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 8.0,
                percent: mood / 100,
                center: Text(
                    mood.toInt().toString() + "%",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: colorByPercentage(mood),
                    ),
                  ),
                circularStrokeCap: CircularStrokeCap.square,
                backgroundColor: Colors.black12,                         
                maskFilter: MaskFilter.blur(BlurStyle.solid, 3),
                progressColor: colorByPercentage(mood)
              ),
              SizedBox(width: getProportionateScreenWidth(10)),
              Text(
                moodText(mood), 
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorByPercentage(mood),
                ),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(5)),
          Text("Movies", style: headingStyle),
          Text(
            "Enjoy with our picks for you",
            textAlign: TextAlign.center,
          ),
          MovieCarousel(genreIDs: genreIDs, bannedIDs: bannedIDs),
          Spacer()
        ],
    );
  }


}
