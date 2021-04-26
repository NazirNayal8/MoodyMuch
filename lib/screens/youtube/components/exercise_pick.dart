

import 'package:flutter/material.dart';
import 'package:moodymuch/constants.dart';
import 'package:moodymuch/screens/youtube/components/category_card.dart';
import 'package:moodymuch/screens/youtube/components/youtube_video_list_screen.dart';
import 'package:moodymuch/size_config.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ExercisePickScreen extends StatelessWidget {

  final double mood = 77;
  // ExercisePickScreen({Key key, this.mood}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                SizedBox(height: getProportionateScreenHeight(10)),
                Text("Exercises", style: headingStyle),
                Text(
                  "Pick one to strengthen your mental health",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: .85,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: <Widget>[
                      CategoryCard(
                        title: "Pilates",
                        svgSrc: "assets/icons/pilates.svg",
                        press: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubeVideoListScreen(title: 'Pilates')));
                        },
                      ),
                      CategoryCard(
                        title: "Kegel Exercises",
                        svgSrc: "assets/icons/exercises.svg",
                        press: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubeVideoListScreen(title: 'Kegel Exercise')));
                        },
                      ),
                      CategoryCard(
                        title: "Meditation",
                        svgSrc: "assets/icons/meditation.svg",
                        press: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubeVideoListScreen(title: 'Meditation')));
                        },
                      ),
                      CategoryCard(
                        title: "Yoga",
                        svgSrc: "assets/icons/yoga.svg",
                        press: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubeVideoListScreen(title: 'Yoga')));        
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}