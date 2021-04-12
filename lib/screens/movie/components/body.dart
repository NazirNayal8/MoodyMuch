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
    // it enable scroll on small device
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
                percent: 0.75,
                center: Text(
                    percentage(0.75),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: colorByPercentage(75),
                    ),
                  ),
                circularStrokeCap: CircularStrokeCap.square,
                backgroundColor: Colors.black12,                         
                maskFilter: MaskFilter.blur(BlurStyle.solid, 3),
                progressColor: colorByPercentage(0.75 * 100)
              ),
              SizedBox(width: getProportionateScreenWidth(10)),
              Text("Very Positive!", 
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorByPercentage(75),
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
