import 'package:flutter/material.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/size_config.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'movie_carousel.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // it enable scroll on small device
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 80.0,
                lineWidth: 10.0,
                percent: 0.75,
                center: Text(
                    percentage(0.75),
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(16),
                      fontWeight: FontWeight.bold,
                      color: colorByPercentage(75),
                      height: 1.5,
                    ),
                  ),
                circularStrokeCap: CircularStrokeCap.square,
                backgroundColor: Colors.black12,                         
                maskFilter: MaskFilter.blur(BlurStyle.solid, 3),
                progressColor: colorByPercentage(0.75 * 100)
              ),
              SizedBox(width: getProportionateScreenWidth(15)),
              Text("Very Positive!", 
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  fontWeight: FontWeight.bold,
                  color: colorByPercentage(75),
                  height: 1.5,
                ),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          Text("Movies", style: headingStyle),
          Text(
            "Enjoy with our picks for you",
            textAlign: TextAlign.center,
          ),
          MovieCarousel(),
          Spacer()
        ],
    );
  }
}
